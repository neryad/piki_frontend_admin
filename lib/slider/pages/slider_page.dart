// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:piki_admin/shared/components/reusable_button.dart';
import 'package:piki_admin/shared/functions/fetch_images_bytes.dart';
import 'package:piki_admin/shared/functions/table_filter.dart';
import 'package:piki_admin/shared/widgets/action_search_bar.dart';
import 'package:piki_admin/shared/widgets/custom_data_table.dart';
import 'package:piki_admin/shared/widgets/custom_dialog.dart';
import 'package:piki_admin/shared/widgets/custom_input_field.dart';
import 'package:piki_admin/slider/services/slider_service.dart';
import 'package:piki_admin/theme/app_theme.dart';

class SliderPage extends StatefulWidget {
  const SliderPage({super.key});

  @override
  State<SliderPage> createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  Uint8List? selectedImageBytes;
  bool imageLoaded = false;
  final SliderService _sliderService = SliderService();
  List<Map<String, dynamic>> filteredSliders = [];
  bool isLoading = true;
  String? error;
  Map<String, dynamic> formValues = {
    'imageBytes': null,
    'link': '',
    'isActive': true,
  };
  final states = [
    {"state": true, "name": "Activo"},
    {"state": false, "name": "Inactivo"},
  ];

  @override
  void initState() {
    super.initState();
    _loadSliders();
  }

  Future<void> _loadSliders() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final sliders = await _sliderService.getSliders();
      setState(() {
        filteredSliders = sliders.map((user) => user.toJson()).toList();
        filteredSliders = filteredSliders.reversed.toList();
        isLoading = false;
      });
      log('filteredUsers: $filteredSliders');
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _filterSliders(String query) {
    final allSliders = filteredSliders;
    if (query.isEmpty) {
      _loadSliders();
      return;
    }
    setState(() {
      filteredSliders = filterItems(
        allSliders,
        query,
        ['link'],
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
              actionButtonText: 'Nuevo slider',
              onActionPressed: () => _createSliderDialog(context),
              actionButtonColor: AppTheme.radicalRed,
              actionIcon: Icons.add,
              onSearch: _filterSliders,
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
                  columns: const ['Imagen', 'Enlace', 'Estado', 'Opciones'],
                  displayFields: const [
                    'imageUrl',
                    'link',
                    'isActive',
                  ],
                  imageFields: const ['imageUrl'],
                  rows: filteredSliders,
                  headerStyle: textStyle,
                  actionsBuilder: (slider) => Row(
                    children: [
                      ReusableButton(
                        childText: 'Eliminar',
                        onPressed: () =>
                            _deleteSliderDialog(context, slider['id']),
                        buttonColor: Colors.red,
                        childTextColor: Colors.white,
                        iconData: Icons.delete,
                      ),
                      const SizedBox(width: 10),
                      ReusableButton(
                        childText: 'Editar',
                        onPressed: () async {
                          _editSliderDialog(context, slider);
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

  _createSliderDialog(BuildContext context) {
    selectedImageBytes = null;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return CustomDialog(
              title: 'Crear slider',
              formFields: [
                selectedImageBytes != null
                    ? Image.memory(
                        selectedImageBytes!,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/no-image-selected.jpg',
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.contain,
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
                  label: 'Enlace',
                  placeHolder: 'Ingrese el enlace',
                  suffixIcon: Icons.link,
                  formProperty: 'link',
                  fromValues: formValues,
                  maxLength: 150,
                  customValidation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un enlace';
                    }
                    return null;
                  },
                  customOnChanged: (value) {
                    setState(() {
                      formValues['link'] = value;
                    });
                    return null;
                  },
                ),
                DropdownButtonFormField<bool>(
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
                      formValues['isActive'] = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
              ],
              onCancel: () => Navigator.of(context).pop(),
              onConfirm: () async {
                setState(() {
                  isLoading = true;
                });

                try {
                  await _sliderService.createSlider(formValues);
                  Navigator.of(context).pop();
                  _loadSliders();
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

  _editSliderDialog(BuildContext context, Map<String, dynamic> slider) async {
    selectedImageBytes = null;

    Uint8List? imageBytes = await fetchImageBytes(slider['imageUrl']);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // Actualizar selectedImageBytes dentro del StatefulBuilder
            if (imageBytes != null && selectedImageBytes == null) {
              Future.delayed(Duration.zero, () {
                setState(() {
                  selectedImageBytes = imageBytes;
                  formValues['imageBytes'] = selectedImageBytes;
                });
              });
            }

            return CustomDialog(
              title: 'Editar slider',
              formFields: [
                selectedImageBytes != null
                    ? Image.memory(
                        selectedImageBytes!,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/no-image-selected.jpg',
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.contain,
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
                  label: 'Enlace',
                  placeHolder: 'Ingrese el enlace',
                  suffixIcon: Icons.link,
                  formProperty: 'link',
                  fromValues: formValues,
                  initialValue: slider['link'],
                  maxLength: 150,
                  customValidation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un enlace';
                    }
                    return null;
                  },
                  customOnChanged: (value) {
                    setState(() {
                      formValues['link'] = value;
                    });
                    return null;
                  },
                ),
                DropdownButtonFormField<bool>(
                  value: slider['isActive'] == 'Activo' ? true : false,
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
                      formValues['isActive'] = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
              ],
              onCancel: () => Navigator.of(context).pop(),
              onConfirm: () async {
                setState(() {
                  isLoading = true;
                });

                try {
                  await _sliderService.updateSlider(formValues, slider['id']);
                  Navigator.of(context).pop();
                  _loadSliders();
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

  _deleteSliderDialog(BuildContext context, int id) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
            title: 'Eliminar slider',
            dialogSize: 0.4,
            formFields: const [
              Text('¿Estás seguro de querer eliminar este slider?'),
            ],
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: () async {
              try {
                await _sliderService.deleteSlider(id);
                Navigator.of(context).pop();
                _loadSliders();
              } catch (e) {
                log('Error: $e');
              }
            });
      },
    );
  }
}
