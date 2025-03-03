// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:piki_admin/materials/models/material_model.dart';
import 'package:piki_admin/materials/services/materials_service.dart';
import 'package:piki_admin/products/models/products_model.dart';
import 'package:piki_admin/products/services/products_service.dart';
import 'package:piki_admin/products_materials/models/product_material_model.dart';
import 'package:piki_admin/products_materials/services/product_material_service.dart';
import 'package:piki_admin/shared/components/reusable_button.dart';
import 'package:piki_admin/shared/functions/table_filter.dart';
import 'package:piki_admin/shared/widgets/action_search_bar.dart';
import 'package:piki_admin/shared/widgets/custom_data_table.dart';
import 'package:piki_admin/shared/widgets/custom_dialog.dart';
import 'package:piki_admin/shared/widgets/custom_input_field.dart';
import 'package:piki_admin/theme/app_theme.dart';

class ProductsMaterialPage extends StatefulWidget {
  const ProductsMaterialPage({super.key});

  @override
  State<ProductsMaterialPage> createState() => _ProductsMaterialPageState();
}

class _ProductsMaterialPageState extends State<ProductsMaterialPage> {
  final ProductsMaterialService _productsMaterialService =
      ProductsMaterialService();
  List<Map<String, dynamic>> filteredProductMaterials = [];
  List<Product> products = [];
  List<MaterialModel> materials = [];
  bool isLoading = true;
  String? error;
  Map<String, dynamic> formValues = {
    "product_id": 0,
    "material_id": 0,
    "quantityUsed": 0
  };

  @override
  void initState() {
    super.initState();
    _loadProductMaterials();
    _loadProducts();
    _loadMaterials();
  }

  Future<void> _loadProductMaterials() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final productMaterials =
          await _productsMaterialService.getProductsMaterials();
      setState(() {
        filteredProductMaterials =
            productMaterials.map((pm) => pm.toJson()).toList();
        filteredProductMaterials = filteredProductMaterials.reversed.toList();
        isLoading = false;
      });
      log('filteredProductMaterials: $filteredProductMaterials');
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _loadProducts() async {
    try {
      products = await ProductsService().getProducts();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _loadMaterials() async {
    try {
      materials = await MaterialsService().getMaterials();
    } catch (e) {
      log(e.toString());
    }
  }

  void _filterProductMaterials(String query) {
    final allUsers = filteredProductMaterials;
    if (query.isEmpty) {
      _loadProductMaterials();
      return;
    }
    setState(() {
      filteredProductMaterials = filterItems(
        allUsers,
        query,
        ['materialName', 'productName'],
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
              actionButtonText: 'Nuevo material de producto',
              onActionPressed: () => _createPMDialog(context),
              actionButtonColor: AppTheme.radicalRed,
              actionIcon: Icons.add,
              onSearch: _filterProductMaterials,
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
                    'Nombre del material',
                    'Nombre del producto',
                    'Cantidad utilizada',
                    'Opciones'
                  ],
                  displayFields: const [
                    'materialName',
                    'productName',
                    'quantityUsed',
                  ],
                  rows: filteredProductMaterials,
                  headerStyle: textStyle,
                  actionsBuilder: (pm) => Row(
                    children: [
                      ReusableButton(
                        childText: 'Eliminar',
                        onPressed: () => _deletePMDialog(context, pm['id']),
                        buttonColor: Colors.red,
                        childTextColor: Colors.white,
                        iconData: Icons.delete,
                      ),
                      const SizedBox(width: 10),
                      ReusableButton(
                        childText: 'Editar',
                        onPressed: () async {
                          _editPMDialog(context, pm);
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

  _createPMDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Crear material de producto',
          formFields: [
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Nombre del producto',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: products.map((Product pd) {
                return DropdownMenuItem<int>(
                  value: pd.id,
                  child: Text(pd.name),
                );
              }).toList(),
              onChanged: (int? value) {
                setState(() {
                  formValues['product_id'] = value;
                });
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Nombre del material',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: materials.map((MaterialModel mat) {
                return DropdownMenuItem<int>(
                  value: mat.id,
                  child: Text(mat.name),
                );
              }).toList(),
              onChanged: (int? value) {
                setState(() {
                  formValues['material_id'] = value;
                });
              },
            ),
            const SizedBox(height: 10),
            CustomInputField(
                label: 'Cantidad utilizada',
                placeHolder: 'Ingrese la cantidad utilizada',
                suffixIcon: Icons.production_quantity_limits,
                formProperty: 'quantityUsed',
                maxLength: 10,
                keyboardType: TextInputType.number,
                fromValues: formValues,
                customValidation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la cantidad utilizada';
                  }
                  return null;
                },
                customOnChanged: (value) {
                  setState(() {
                    formValues['quantityUsed'] = value;
                  });
                  return null;
                }),
          ],
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: () async {
            try {
              await _productsMaterialService.createProductMaterial(formValues);
              Navigator.of(context).pop();
              _loadProductMaterials();
            } catch (e) {
              log(e.toString());
            }
          },
        );
      },
    );
  }

  _editPMDialog(BuildContext context, Map<String, dynamic> productMaterial) {
    log('productMaterial: $productMaterial');
    _initializeFormValues(ProductMaterials.fromJson(productMaterial));
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Editar material de producto',
          formFields: [
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: productMaterial['productId'],
              decoration: InputDecoration(
                labelText: 'Nombre del producto',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: products.map((Product pd) {
                return DropdownMenuItem<int>(
                  value: pd.id,
                  child: Text(pd.name),
                );
              }).toList(),
              onChanged: (int? value) {
                setState(() {
                  formValues['product_id'] = value;
                });
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: productMaterial['materialId'],
              decoration: InputDecoration(
                labelText: 'Nombre del material',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: materials.map((MaterialModel mat) {
                return DropdownMenuItem<int>(
                  value: mat.id,
                  child: Text(mat.name),
                );
              }).toList(),
              onChanged: (int? value) {
                setState(() {
                  formValues['material_id'] = value;
                });
              },
            ),
            const SizedBox(height: 10),
            CustomInputField(
                label: 'Cantidad utilizada',
                placeHolder: 'Ingrese la cantidad utilizada',
                suffixIcon: Icons.production_quantity_limits,
                formProperty: 'quantityUsed',
                maxLength: 10,
                keyboardType: TextInputType.number,
                fromValues: formValues,
                initialValue: productMaterial['quantityUsed'].toString(),
                customValidation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la cantidad utilizada';
                  }
                  return null;
                },
                customOnChanged: (value) {
                  setState(() {
                    formValues['quantityUsed'] = value;
                  });
                  return null;
                }),
          ],
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: () async {
            try {
              await _productsMaterialService.updateProductMaterial(
                  productMaterial['id'], formValues);
              Navigator.of(context).pop();
              _loadProductMaterials();
            } catch (e) {
              log(e.toString());
            }
          },
        );
      },
    );
  }

  _deletePMDialog(BuildContext context, int id) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
            title: 'Eliminar material de producto',
            dialogSize: 0.4,
            formFields: const [
              Text(
                  '¿Estás seguro de querer eliminar este material de producto?'),
            ],
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: () async {
              try {
                await _productsMaterialService.deleteProductMaterial(id);
                Navigator.of(context).pop();
                _loadProductMaterials();
              } catch (e) {
                log(e.toString());
              }
            });
      },
    );
  }

  _initializeFormValues(ProductMaterials productMaterial) {
    formValues = {
      "product_id": productMaterial.productId,
      "material_id": productMaterial.materialId,
      "quantityUsed": productMaterial.quantityUsed
    };
  }
}
