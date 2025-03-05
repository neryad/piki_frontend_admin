// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:piki_admin/materials/services/materials_service.dart';
import 'package:piki_admin/shared/components/reusable_button.dart';
import 'package:piki_admin/shared/functions/table_filter.dart';
import 'package:piki_admin/shared/widgets/custom_dialog.dart';
import 'package:piki_admin/shared/widgets/custom_input_field.dart';
import 'package:piki_admin/shared/widgets/show_snackbar.dart';
import 'package:piki_admin/suppliers/models/supplier_models.dart';
import 'package:piki_admin/suppliers/services/suppliers_services.dart';
import 'package:piki_admin/theme/app_theme.dart';
import 'package:piki_admin/shared/widgets/custom_data_table.dart';
import 'package:piki_admin/shared/widgets/action_search_bar.dart';

class MaterialsPage extends StatefulWidget {
  const MaterialsPage({super.key});

  @override
  State<MaterialsPage> createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage> {
  final MaterialsService _materialService = MaterialsService();
  final SuppliersServices _suppliersServices = SuppliersServices();
  List<Map<String, dynamic>> filteredMaterials = [];
  bool isLoading = true;
  String? error;
  final availableMaterials = [
    {"state": true, "name": "Disponible"},
    {"state": false, "name": "No disponible"},
  ];
  //TODO: Replace this with the actual API suppliers

  List<Suppliers> suppliers = [];

  // final suppliers = [
  //   {"id": 1, "name": "Suplidor 1"},
  //   {"id": 2, "name": "Suplidor 2"},
  //   {"id": 3, "name": "Suplidor 3"},
  // ];
  Map<String, dynamic> formValues = {
    "name": "String",
    "description": "String",
    "isAvailable": true,
    "cost": 0,
    "date": "2023-10-01",
    "supplier_id": 0,
    "quantity": 0,
    "quantityByUnit": 0,
    "costByUnit": 0.0
  };

  @override
  void initState() {
    super.initState();
    _loadMaterials();
    _loadSuppliers();
  }

  Future<void> _loadSuppliers() async {
    try {
      suppliers = await _suppliersServices.getSuppliers();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _loadMaterials() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });
      formValues['date'] = DateTime.now().toString();
      final materials = await _materialService.getMaterials();
      setState(() {
        filteredMaterials = materials.map((mat) => mat.toJson()).toList();
        filteredMaterials = filteredMaterials.reversed.toList();
        isLoading = false;
      });
      log('filteredMaterials: $filteredMaterials');
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _filterMaterials(String query) {
    final allMaterials = filteredMaterials;
    if (query.isEmpty) {
      _loadMaterials();
      return;
    }
    setState(() {
      filteredMaterials = filterItems(
        allMaterials,
        query,
        ['name', 'description', 'cost'],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontWeight: FontWeight.bold);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ActionSearchBar(
              actionButtonText: 'Nuevo material',
              onActionPressed: () => _createMaterialDialog(context),
              actionButtonColor: AppTheme.radicalRed,
              actionIcon: Icons.add,
              onSearch: _filterMaterials,
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const CircularProgressIndicator()
            else if (error != null)
              Text('Error: $error')
            else
              Expanded(
                child: CustomDataTable(
                  columns: const [
                    'Nombre',
                    'Descripción',
                    'Estado',
                    'Costo',
                    'Suplidor',
                    'Cantidad',
                    'Unidades',
                    'Costo Unidad',
                    'Opciones'
                  ],
                  displayFields: const [
                    'name',
                    'description',
                    'isAvailable',
                    'cost',
                    'supplier_id',
                    'quantity',
                    'quantityByUnit',
                    'costByUnit',
                  ],
                  columnSpacing: 0,
                  rows: filteredMaterials,
                  headerStyle: textStyle,
                  actionsBuilder: (mat) => Row(
                    children: [
                      ReusableButton(
                        childText: 'Eliminar',
                        onPressed: () =>
                            _deleteMaterialDialog(mat['id'] as int),
                        buttonColor: Colors.red,
                        childTextColor: Colors.white,
                        iconData: Icons.delete,
                      ),
                      const SizedBox(width: 10),
                      ReusableButton(
                        childText: 'Editar',
                        onPressed: () async {
                          _editMaterialDialog(context, mat);
                          return;
                        },
                        buttonColor: AppTheme.rose,
                        childTextColor: Colors.white,
                        iconData: Icons.edit,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _createMaterialDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Crear material',
          formFields: [
            CustomInputField(
                label: 'Nombre del material',
                placeHolder: 'Ingrese el nombre del material',
                suffixIcon: Icons.insert_page_break,
                formProperty: 'name',
                maxLength: 30,
                fromValues: formValues,
                customValidation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
                customOnChanged: (value) {
                  setState(() {
                    formValues['name'] = value;
                  });
                  return null;
                }),
            CustomInputField(
                label: 'Descripción del material',
                placeHolder: 'Ingrese la descripción',
                suffixIcon: Icons.pages,
                formProperty: 'description',
                maxLength: 100,
                fromValues: formValues,
                customValidation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
                customOnChanged: (value) {
                  setState(() {
                    formValues['description'] = value;
                  });
                  return null;
                }),
            const SizedBox(height: 10),
            DropdownButtonFormField<bool>(
              decoration: InputDecoration(
                labelText: 'Disponibilidad',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: availableMaterials.map((material) {
                return DropdownMenuItem<bool>(
                  value: material['state'] as bool,
                  child: Text(material['name'] as String),
                );
              }).toList(),
              onChanged: (bool? value) {
                setState(() {
                  formValues['isAvailable'] = value;
                });
              },
            ),
            const SizedBox(height: 10),
            CustomInputField(
                label: 'Costo',
                placeHolder: 'Ingrese el costo del material',
                suffixIcon: Icons.price_change,
                formProperty: 'cost',
                maxLength: 10,
                keyboardType: TextInputType.number,
                fromValues: formValues,
                customValidation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un costo';
                  }
                  return null;
                },
                customOnChanged: (value) {
                  setState(() {
                    formValues['cost'] = value;
                  });
                  return null;
                }),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Suplidor',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: suppliers.map((Suppliers sup) {
                return DropdownMenuItem<int>(
                  value: sup.id,
                  child: Text('${sup.name} ${sup.lastName}'),
                );
              }).toList(),
              onChanged: (int? value) {
                setState(() {
                  formValues['supplier_id'] = value;
                });
              },
            ),
            const SizedBox(height: 10),
            CustomInputField(
                label: 'Cantidad',
                placeHolder: 'Ingrese la cantidad del material',
                suffixIcon: Icons.shopping_bag_rounded,
                formProperty: 'quantity',
                maxLength: 10,
                keyboardType: TextInputType.number,
                fromValues: formValues,
                customValidation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una cantidad';
                  }
                  return null;
                },
                customOnChanged: (value) {
                  setState(() {
                    formValues['quantity'] = value;
                  });
                  return null;
                }),
            CustomInputField(
                label: 'Cantidad por unidad',
                placeHolder: 'Ingrese la cantidad por unidad',
                suffixIcon: Icons.shopping_bag_rounded,
                formProperty: 'quantityByUnit',
                maxLength: 10,
                keyboardType: TextInputType.number,
                fromValues: formValues,
                customValidation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una cantidad por unidad';
                  }
                  return null;
                },
                customOnChanged: (value) {
                  setState(() {
                    formValues['quantityByUnit'] = value;
                  });
                  return null;
                }),
            CustomInputField(
                label: 'Costo de unidad',
                placeHolder: 'Ingrese el costo de la unidad',
                suffixIcon: Icons.price_change,
                formProperty: 'costByUnit',
                maxLength: 10,
                keyboardType: TextInputType.number,
                fromValues: formValues,
                customValidation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un costo';
                  }
                  return null;
                },
                customOnChanged: (value) {
                  setState(() {
                    formValues['costByUnit'] = value;
                  });
                  return null;
                }),
          ],
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: () async {
            try {
              final result = await _materialService.postMaterial(formValues);
              if (!result) {
                showSnackBar(context, 'Error creando material');
                return;
              }
              Navigator.of(context).pop();
              _loadMaterials();
            } catch (e) {
              log(e.toString());
            }
          },
        );
      },
    );
  }

  _editMaterialDialog(BuildContext context, Map<String, dynamic> materialData) {
    setState(() {
      formValues = materialData;
    });
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Editar material',
          formFields: [
            CustomInputField(
                label: 'Nombre del material',
                placeHolder: 'Ingrese el nombre del material',
                suffixIcon: Icons.insert_page_break,
                formProperty: 'name',
                initialValue: formValues['name'],
                maxLength: 30,
                fromValues: formValues,
                customValidation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
                customOnChanged: (value) {
                  setState(() {
                    formValues['name'] = value;
                  });
                  return null;
                }),
            CustomInputField(
                label: 'Descripción del material',
                placeHolder: 'Ingrese la descripción',
                suffixIcon: Icons.pages,
                formProperty: 'description',
                maxLength: 100,
                fromValues: formValues,
                initialValue: formValues['description'],
                customValidation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
                customOnChanged: (value) {
                  setState(() {
                    formValues['description'] = value;
                  });
                  return null;
                }),
            const SizedBox(height: 10),
            DropdownButtonFormField<bool>(
              decoration: InputDecoration(
                labelText: 'Disponibilidad',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              value: formValues['isAvailable'] == 'Disponible' ? true : false,
              items: availableMaterials.map((material) {
                return DropdownMenuItem<bool>(
                  value: material['state'] as bool,
                  child: Text(material['name'] as String),
                );
              }).toList(),
              onChanged: (bool? value) {
                setState(() {
                  formValues['isAvailable'] = value;
                });
              },
            ),
            const SizedBox(height: 10),
            CustomInputField(
                label: 'Costo',
                placeHolder: 'Ingrese el costo del material',
                suffixIcon: Icons.price_change,
                formProperty: 'cost',
                maxLength: 10,
                keyboardType: TextInputType.number,
                fromValues: formValues,
                initialValue: formValues['cost'].toString(),
                customValidation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un costo';
                  }
                  return null;
                },
                customOnChanged: (value) {
                  setState(() {
                    formValues['cost'] = value;
                  });
                  return null;
                }),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Suplidor',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              value: formValues['supplier_id'],
              items: suppliers.map((Suppliers sup) {
                return DropdownMenuItem<int>(
                  value: sup.id,
                  child: Text('${sup.name} ${sup.lastName}'),
                );
              }).toList(),
              onChanged: (int? value) {
                setState(() {
                  formValues['supplier_id'] = value;
                });
              },
            ),
            const SizedBox(height: 10),
            CustomInputField(
                label: 'Cantidad',
                placeHolder: 'Ingrese la cantidad del material',
                suffixIcon: Icons.shopping_bag_rounded,
                formProperty: 'quantity',
                maxLength: 10,
                keyboardType: TextInputType.number,
                fromValues: formValues,
                initialValue: formValues['quantity'].toString(),
                customValidation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una cantidad';
                  }
                  return null;
                },
                customOnChanged: (value) {
                  setState(() {
                    formValues['quantity'] = value;
                  });
                  return null;
                }),
            CustomInputField(
                label: 'Cantidad por unidad',
                placeHolder: 'Ingrese la cantidad por unidad',
                suffixIcon: Icons.shopping_bag_rounded,
                formProperty: 'quantityByUnit',
                maxLength: 10,
                keyboardType: TextInputType.number,
                fromValues: formValues,
                initialValue: formValues['quantityByUnit'].toString(),
                customValidation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una cantidad por unidad';
                  }
                  return null;
                },
                customOnChanged: (value) {
                  setState(() {
                    formValues['quantityByUnit'] = value;
                  });
                  return null;
                }),
            CustomInputField(
                label: 'Costo de unidad',
                placeHolder: 'Ingrese el costo de la unidad',
                suffixIcon: Icons.price_change,
                formProperty: 'costByUnit',
                maxLength: 10,
                keyboardType: TextInputType.number,
                fromValues: formValues,
                initialValue: formValues['costByUnit'].toString(),
                customValidation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un costo';
                  }
                  return null;
                },
                customOnChanged: (value) {
                  setState(() {
                    formValues['costByUnit'] = value;
                  });
                  return null;
                }),
          ],
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: () async {
            try {
              final result = await _materialService.updateMaterial(
                  formValues, materialData['id'] as int);
              if (!result) {
                showSnackBar(context, 'Error editando material');
                return;
              }
              Navigator.of(context).pop();
              _loadMaterials();
            } catch (e) {
              log(e.toString());
            }
          },
        );
      },
    );
  }

  _deleteMaterialDialog(int id) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
            title: 'Eliminar material',
            dialogSize: 0.4,
            formFields: const [
              Text('¿Estás seguro de querer eliminar este material?'),
            ],
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: () async {
              try {
                await _materialService.deleteMaterial(id);
                Navigator.of(context).pop();
                _loadMaterials();
              } catch (e) {
                log(e.toString());
              }
            });
      },
    );
  }
}
