// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piki_admin/shared/components/reusable_button.dart';
import 'package:piki_admin/shared/functions/table_filter.dart';
import 'package:piki_admin/shared/widgets/action_search_bar.dart';
import 'package:piki_admin/shared/widgets/custom_data_table.dart';
import 'package:piki_admin/shared/widgets/custom_dialog.dart';
import 'package:piki_admin/shared/widgets/custom_input_field.dart';
import 'package:piki_admin/suppliers/services/suppliers_services.dart';
import 'package:piki_admin/theme/app_theme.dart';

class SupplierPage extends StatefulWidget {
  const SupplierPage({super.key});

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  final SuppliersServices _supplierService = SuppliersServices();
  List<Map<String, dynamic>> filteredSuppliers = [];
  Map<String, dynamic> formValues = {};
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
  }

  Future<void> _loadSuppliers() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final suppliers = await _supplierService.getSuppliers();
      setState(() {
        filteredSuppliers = suppliers.map((supplier) {
          final supplierMap = supplier.toJson();
          supplierMap['created_at'] = DateFormat('dd/MM/yyy')
              .format(DateTime.parse(supplierMap['created_at']));
          return supplierMap;
        }).toList();
        filteredSuppliers = filteredSuppliers.reversed.toList();
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _filterSuppliers(String query) {
    final allSuppliers = filteredSuppliers;
    if (query.isEmpty) {
      _loadSuppliers();
      return;
    }
    setState(() {
      filteredSuppliers = filterItems(allSuppliers, query, ['name']);
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
                actionButtonText: 'Nuevo suplidor',
                onActionPressed: () async {
                  await _createSupplierDialog(context);
                },
                actionButtonColor: AppTheme.radicalRed,
                actionIcon: Icons.add,
                onSearch: _filterSuppliers),
            const SizedBox(height: 16),
            if (isLoading)
              const CircularProgressIndicator()
            else if (error != null)
              Text('Error: $error')
            else
              Expanded(
                  child: CustomDataTable(
                columns: const [
                  'id',
                  'Nombre',
                  'Apellido',
                  'Teléfono',
                  'Correo',
                  'Creado en',
                  'Opciones'
                ],
                rows: filteredSuppliers,
                displayFields: const [
                  'id',
                  'name',
                  'lastName',
                  'phone',
                  'email',
                  'created_at'
                ],
                headerStyle: textStyle,
                actionsBuilder: (supplier) => Row(
                  children: [
                    ReusableButton(
                      childText: 'Eliminar',
                      onPressed: () async {
                        // await _deleteRoleDialog(context, role['id']);
                        await _deleteSupplierDialog(context, supplier['id']);
                      },
                      buttonColor: Colors.red,
                      childTextColor: Colors.white,
                      iconData: Icons.delete,
                    ),
                    const SizedBox(width: 10),
                    ReusableButton(
                      childText: 'Editar',
                      onPressed: () async {
                        await _editSupplierDialog(context, supplier);
                      },
                      iconData: Icons.edit,
                      buttonColor: AppTheme.rose,
                      childTextColor: Colors.white,
                    )
                  ],
                ),
              ))
          ],
        ),
      ),
    );
  }

  Future<void> _deleteSupplierDialog(BuildContext context, int id) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: 'Eliminar suplidor',
            formFields: const [
              Text('¿Estás seguro de que deseas eliminar este suplidor?')
            ],
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: () async {
              await _supplierService.deleteSupplier(id);
              Navigator.of(context).pop();
              _loadSuppliers();
            },
          );
        });
  }

  Future<void> _createSupplierDialog(BuildContext context) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: 'Crear suplidor',
            formFields: [
              CustomInputField(
                label: 'Nombre',
                placeHolder: 'Ingrese el nombre',
                suffixIcon: Icons.person,
                formProperty: 'name',
                maxLength: 50,
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
                },
              ),
              CustomInputField(
                label: 'Apellido',
                placeHolder: 'Ingrese el apellido',
                suffixIcon: Icons.person,
                formProperty: 'lastName',
                maxLength: 50,
                fromValues: formValues,
                customValidation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un apellido';
                  }
                  return null;
                },
                customOnChanged: (value) {
                  setState(() {
                    formValues['lastName'] = value;
                  });
                  return null;
                },
              ),
              CustomInputField(
                label: 'Teléfono',
                placeHolder: 'Ingrese el teléfono',
                suffixIcon: Icons.phone,
                formProperty: 'phone',
                maxLength: 10,
                keyboardType: TextInputType.phone,
                fromValues: formValues,
                customValidation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un teléfono';
                  }
                  return null;
                },
                customOnChanged: (value) {
                  setState(() {
                    formValues['phone'] = value;
                  });
                  return null;
                },
              ),
              CustomInputField(
                label: 'Correo',
                placeHolder: 'Ingrese el correo',
                suffixIcon: Icons.email,
                formProperty: 'email',
                maxLength: 50,
                keyboardType: TextInputType.emailAddress,
                fromValues: formValues,
                customValidation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un correo';
                  }
                  return null;
                },
                customOnChanged: (value) {
                  setState(() {
                    formValues['email'] = value;
                  });
                  return null;
                },
              ),
            ],
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: () async {
              await _supplierService.createSupplier(formValues);
              Navigator.of(context).pop();
              _loadSuppliers();
            },
          );
        });
  }

  Future<void> _editSupplierDialog(
      BuildContext context, Map<String, dynamic> supplier) async {
    setState(() {
      formValues = supplier;
    });
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: 'Editar suplidor',
            formFields: [
              CustomInputField(
                label: 'Nombre',
                placeHolder: 'Ingrese el nombre',
                suffixIcon: Icons.person,
                formProperty: 'name',
                maxLength: 50,
                initialValue: supplier['name'],
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
                },
              ),
              CustomInputField(
                label: 'Apellido',
                placeHolder: 'Ingrese el apellido',
                suffixIcon: Icons.person,
                formProperty: 'lastName',
                maxLength: 50,
                initialValue: supplier['lastName'],
                fromValues: formValues,
                customValidation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un apellido';
                  }
                  return null;
                },
                customOnChanged: (value) {
                  setState(() {
                    formValues['lastName'] = value;
                  });
                  return null;
                },
              ),
              CustomInputField(
                label: 'Teléfono',
                placeHolder: 'Ingrese el teléfono',
                suffixIcon: Icons.phone,
                formProperty: 'phone',
                maxLength: 10,
                initialValue: supplier['phone'],
                keyboardType: TextInputType.phone,
                fromValues: formValues,
                customValidation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un teléfono';
                  }
                  return null;
                },
                customOnChanged: (value) {
                  setState(() {
                    formValues['phone'] = value;
                  });
                  return null;
                },
              ),
              CustomInputField(
                label: 'Correo',
                placeHolder: 'Ingrese el correo',
                suffixIcon: Icons.email,
                formProperty: 'email',
                maxLength: 50,
                initialValue: supplier['email'],
                keyboardType: TextInputType.emailAddress,
                fromValues: formValues,
                customValidation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un correo';
                  }
                  return null;
                },
                customOnChanged: (value) {
                  setState(() {
                    formValues['email'] = value;
                  });
                  return null;
                },
              ),
            ],
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: () async {
              await _supplierService.updateSupplier(formValues, supplier['id']);
              Navigator.of(context).pop();
              _loadSuppliers();
            },
          );
        });
  }
}
