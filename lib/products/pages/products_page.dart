// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:piki_admin/products/services/products_service.dart';
import 'package:piki_admin/shared/components/reusable_button.dart';
import 'package:piki_admin/shared/functions/fetch_images_bytes.dart';
import 'package:piki_admin/shared/functions/table_filter.dart';
import 'package:piki_admin/shared/widgets/action_search_bar.dart';
import 'package:piki_admin/shared/widgets/custom_data_table.dart';
import 'package:piki_admin/shared/widgets/custom_dialog.dart';
import 'package:piki_admin/shared/widgets/custom_input_field.dart';
import 'package:piki_admin/theme/app_theme.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  Uint8List? selectedImageBytes;
  final ProductsService _productsService = ProductsService();
  List<Map<String, dynamic>> filteredProducts = [];
  bool isLoading = true;
  String? error;
  Map<String, dynamic> formValues = {
    'name': '',
    'description': '',
    'price': 0.0,
    'stock': 0,
    'isAvailable': true,
    'offerPrice': 0.0,
    'imageBytes': null,
  };
  final states = [
    {"state": true, "name": "Disponible"},
    {"state": false, "name": "No disponible"},
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final products = await _productsService.getProducts();
      setState(() {
        filteredProducts = products.map((product) => product.toJson()).toList();
        filteredProducts = filteredProducts.reversed.toList();
        isLoading = false;
      });
      log('filteredProducts: $filteredProducts');
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _filterProducts(String query) {
    final allProducts = filteredProducts;
    if (query.isEmpty) {
      _loadProducts();
      return;
    }
    setState(() {
      filteredProducts = filterItems(
        allProducts,
        query,
        ['name', 'description', 'price', 'stock', 'isAvailable', 'offerPrice'],
      );
    });
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.first.bytes != null) {
      setState(() {
        selectedImageBytes = result.files.first.bytes;
        formValues['imageBytes'] = selectedImageBytes;
      });
    }
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
              actionButtonText: 'Nuevo producto',
              onActionPressed: () => _createProductDialog(context),
              actionButtonColor: AppTheme.radicalRed,
              actionIcon: Icons.add,
              onSearch: _filterProducts,
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const CircularProgressIndicator()
            else if (error != null)
              Text('Error: $error')
            else
              Expanded(
                child: CustomDataTable(
                  dataRowMaxHeight: 150,
                  columns: const [
                    'Imagen',
                    'Producto',
                    'Descripción',
                    'Precio',
                    'Stock',
                    'Estado',
                    'Precio oferta',
                    'Opciones'
                  ],
                  displayFields: const [
                    'imageUrl',
                    'name',
                    'description',
                    'price',
                    'stock',
                    'isAvailable',
                    'offerPrice',
                  ],
                  imageFields: const ['imageUrl'],
                  columnSpacing: 0,
                  rows: filteredProducts,
                  headerStyle: textStyle,
                  actionsBuilder: (product) => Row(
                    children: [
                      ReusableButton(
                        childText: 'Eliminar',
                        onPressed: () =>
                            _deleteProductDialog(context, product['id']),
                        buttonColor: Colors.red,
                        childTextColor: Colors.white,
                        iconData: Icons.delete,
                      ),
                      const SizedBox(width: 10),
                      ReusableButton(
                        childText: 'Editar',
                        onPressed: () async {
                          _editProductDialog(context, product);
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

  _createProductDialog(BuildContext context) {
    selectedImageBytes = null;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return CustomDialog(
              title: 'Crear producto',
              formFields: [
                Center(
                  child: selectedImageBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.memory(
                            selectedImageBytes!,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            'assets/no-image-selected.jpg',
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                ),
                const SizedBox(height: 10),
                ReusableButton(
                  childText: 'Subir imagen',
                  onPressed: () async {
                    await _pickImage();
                    setState(() {});
                  },
                  buttonColor: AppTheme.pinkSalmonShade200,
                  childTextColor: Colors.white,
                  iconData: Icons.upload,
                ),
                const SizedBox(height: 10),
                CustomInputField(
                  label: 'Nombre producto',
                  placeHolder: 'Ingrese el nombre del producto',
                  suffixIcon: Icons.shopping_cart,
                  formProperty: 'name',
                  fromValues: formValues,
                  maxLength: 150,
                  customValidation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el nombre del producto';
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
                  label: 'Descripción del producto',
                  placeHolder: 'Ingrese la descripción del producto',
                  suffixIcon: Icons.shopping_cart,
                  formProperty: 'description',
                  fromValues: formValues,
                  maxLength: 150,
                  customValidation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la descripción del producto';
                    }
                    return null;
                  },
                  customOnChanged: (value) {
                    setState(() {
                      formValues['description'] = value;
                    });
                    return null;
                  },
                ),
                CustomInputField(
                  label: 'Precio del producto',
                  placeHolder: 'Ingrese el precio del producto',
                  suffixIcon: Icons.price_change,
                  formProperty: 'price',
                  fromValues: formValues,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  customValidation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el precio del producto';
                    }
                    return null;
                  },
                  customOnChanged: (value) {
                    setState(() {
                      formValues['price'] = value;
                    });
                    return null;
                  },
                ),
                CustomInputField(
                  label: 'Stock del producto',
                  placeHolder: 'Ingrese el stock del producto',
                  suffixIcon: Icons.shopping_cart,
                  formProperty: 'stock',
                  fromValues: formValues,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  customValidation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el stock del producto';
                    }
                    return null;
                  },
                  customOnChanged: (value) {
                    setState(() {
                      formValues['stock'] = value;
                    });
                    return null;
                  },
                ),
                CustomInputField(
                  label: 'Precio de oferta del producto',
                  placeHolder: 'Ingrese el precio de oferta del producto',
                  suffixIcon: Icons.price_change,
                  formProperty: 'offerPrice',
                  fromValues: formValues,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  customValidation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el precio de oferta del producto';
                    }
                    return null;
                  },
                  customOnChanged: (value) {
                    setState(() {
                      formValues['offerPrice'] = value;
                    });
                    return null;
                  },
                ),
              ],
              onCancel: () => Navigator.of(context).pop(),
              onConfirm: () async {
                setState(() {
                  isLoading = true;
                });

                try {
                  await _productsService.createProduct(formValues);
                  Navigator.of(context).pop();
                  _loadProducts();
                } catch (e) {
                  log('Error: $e');
                } finally {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
            );
          },
        );
      },
    );
  }

  _editProductDialog(BuildContext context, Map<String, dynamic> product) async {
    selectedImageBytes = null;
    initFormValues(product);
    Uint8List? imageBytes = await fetchImageBytes(product['imageUrl']);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            if (imageBytes != null && selectedImageBytes == null) {
              Future.delayed(Duration.zero, () {
                setState(() {
                  selectedImageBytes = imageBytes;
                  formValues['imageBytes'] = selectedImageBytes;
                });
              });
            }
            return CustomDialog(
              title: 'Editar producto',
              formFields: [
                Center(
                  child: selectedImageBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.memory(
                            selectedImageBytes!,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            'assets/no-image-selected.jpg',
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                ),
                const SizedBox(height: 10),
                ReusableButton(
                  childText: 'Subir imagen',
                  onPressed: () async {
                    await _pickImage();
                    setState(() {});
                  },
                  buttonColor: AppTheme.pinkSalmonShade200,
                  childTextColor: Colors.white,
                  iconData: Icons.upload,
                ),
                const SizedBox(height: 10),
                CustomInputField(
                  label: 'Nombre producto',
                  placeHolder: 'Ingrese el nombre del producto',
                  suffixIcon: Icons.shopping_cart,
                  formProperty: 'name',
                  fromValues: formValues,
                  initialValue: product['name'],
                  maxLength: 150,
                  customValidation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el nombre del producto';
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
                  label: 'Descripción del producto',
                  placeHolder: 'Ingrese la descripción del producto',
                  suffixIcon: Icons.shopping_cart,
                  formProperty: 'description',
                  fromValues: formValues,
                  initialValue: product['description'],
                  maxLength: 150,
                  customValidation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la descripción del producto';
                    }
                    return null;
                  },
                  customOnChanged: (value) {
                    setState(() {
                      formValues['description'] = value;
                    });
                    return null;
                  },
                ),
                CustomInputField(
                  label: 'Precio del producto',
                  placeHolder: 'Ingrese el precio del producto',
                  suffixIcon: Icons.price_change,
                  formProperty: 'price',
                  fromValues: formValues,
                  initialValue: product['price'].toString(),
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  customValidation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el precio del producto';
                    }
                    return null;
                  },
                  customOnChanged: (value) {
                    setState(() {
                      formValues['price'] = value;
                    });
                    return null;
                  },
                ),
                CustomInputField(
                  label: 'Stock del producto',
                  placeHolder: 'Ingrese el stock del producto',
                  suffixIcon: Icons.shopping_cart,
                  formProperty: 'stock',
                  fromValues: formValues,
                  initialValue: product['stock'].toString(),
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  customValidation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el stock del producto';
                    }
                    return null;
                  },
                  customOnChanged: (value) {
                    setState(() {
                      formValues['stock'] = value;
                    });
                    return null;
                  },
                ),
                DropdownButtonFormField<bool>(
                  value: product['isAvailable'] == 'Disponible' ? true : false,
                  decoration: InputDecoration(
                    labelText: 'Estado',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  items: states.map((state) {
                    return DropdownMenuItem<bool>(
                      value: state['state'] as bool,
                      child: Text(state['name'] as String),
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
                  label: 'Precio de oferta del producto',
                  placeHolder: 'Ingrese el precio de oferta del producto',
                  suffixIcon: Icons.price_change,
                  formProperty: 'offerPrice',
                  fromValues: formValues,
                  initialValue: product['offerPrice'].toString(),
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  customValidation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el precio de oferta del producto';
                    }
                    return null;
                  },
                  customOnChanged: (value) {
                    setState(() {
                      formValues['offerPrice'] = value;
                    });
                    return null;
                  },
                ),
              ],
              onCancel: () => Navigator.of(context).pop(),
              onConfirm: () async {
                setState(() {
                  isLoading = true;
                });

                try {
                  await _productsService.updateProduct(
                      formValues, product['id']);
                  Navigator.of(context).pop();
                  _loadProducts();
                } catch (e) {
                  log('Error: $e');
                } finally {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
            );
          },
        );
      },
    );
  }

  _deleteProductDialog(BuildContext context, int id) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
            title: 'Eliminar producto',
            dialogSize: 0.4,
            formFields: const [
              Text('¿Estás seguro de querer eliminar este producto?'),
            ],
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: () async {
              try {
                await _productsService.deleteProduct(id);
                Navigator.of(context).pop();
                _loadProducts();
              } catch (e) {
                log('Error: $e');
              }
            });
      },
    );
  }

  initFormValues(Map<String, dynamic> product) {
    formValues['name'] = product['name'];
    formValues['description'] = product['description'];
    formValues['price'] = product['price'];
    formValues['stock'] = product['stock'];
    formValues['isAvailable'] =
        product['isAvailable'] == 'Disponible' ? true : false;
    formValues['offerPrice'] = product['offerPrice'];
  }
}
