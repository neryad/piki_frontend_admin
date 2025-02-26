import 'package:flutter/material.dart';
// import 'package:piki_admin/roles/models/role_model.dart';
import 'package:piki_admin/roles/services/role_services.dart';
import 'package:piki_admin/shared/components/reusable_button.dart';
import 'package:piki_admin/shared/functions/table_filter.dart';
import 'package:piki_admin/shared/widgets/action_search_bar.dart';
import 'package:piki_admin/shared/widgets/custom_data_table.dart';
import 'package:piki_admin/shared/widgets/custom_dialog.dart';
import 'package:piki_admin/shared/widgets/custom_input_field.dart';
import 'package:piki_admin/theme/app_theme.dart';

class RolesPages extends StatefulWidget {
  const RolesPages({super.key});

  @override
  State<RolesPages> createState() => _RolesPagesState();
}

class _RolesPagesState extends State<RolesPages> {
  final RoleService _roleService = RoleService();
  List<Map<String, dynamic>> filteredRoles = [];
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> formValues = {};
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });
      final roles = await _roleService.getRoles();
      setState(() {
        filteredRoles = roles.map((role) => role.toMap()).toList();
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

  void _filterRoles(String query) {
    final allRoles = filteredRoles;
    if (query.isEmpty) {
      _loadRoles();
      return;
    }
    setState(() {
      filteredRoles = filterItems(allRoles, query, ['name']);
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
              actionButtonText: 'Nuevo rol',
              onActionPressed: () => _createRoleDialog(context),
              actionButtonColor: AppTheme.radicalRed,
              actionIcon: Icons.add,
              onSearch: _filterRoles,
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const CircularProgressIndicator()
            else if (error != null)
              Text('Error: $error')
            else
              Expanded(
                  child: CustomDataTable(
                      columns: const ['id', 'Nombre', 'Opciones'],
                      rows: filteredRoles,
                      displayFields: const ['id', 'name'],
                      headerStyle: textStyle,
                      actionsBuilder: (role) => Row(
                            children: [
                              ReusableButton(
                                childText: 'Eliminar',
                                onPressed: () async {
                                  await _deleteRoleDialog(context, role['id']);
                                },
                                buttonColor: Colors.red,
                                childTextColor: Colors.white,
                                iconData: Icons.delete,
                              ),
                              const SizedBox(width: 10),
                              ReusableButton(
                                childText: 'Editar',
                                onPressed: () async {
                                  //TODO: Implementar la edición de roles en el back
                                  // Roles roleToUpdate =
                                  //     await _roleService.getRole(role['id']);

                                  // print(roleToUpdate);
                                  _editRoleDialog(context, role);
                                },
                                buttonColor: AppTheme.rose,
                                childTextColor: Colors.white,
                              )
                            ],
                          )))
          ],
        ),
      ),
    );
  }

  Future<void> _createRoleDialog(BuildContext context) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: 'Crear rol',
            formFields: [
              CustomInputField(
                label: 'Nombre del rol',
                placeHolder: 'Ingrese el nombre del rol',
                suffixIcon: Icons.workspace_premium_rounded,
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
                    print(formValues['name']);
                  });
                  return null;
                },
              )
            ],
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: () async {
              // if (_formKey.currentState!.validate()) {
              //   _formKey.currentState!.save();
              try {
                final roleName = formValues['name'];
                if (roleName != null && roleName.isNotEmpty) {
                  await _roleService.createRole(roleName);
                  Navigator.of(context).pop();
                  _loadRoles();
                } else {
                  print('El nombre del rol no puede estar vacío');
                }
              } catch (e) {
                print(e);
              }
              // }
            },
          );
        });
  }

  Future<void> _deleteRoleDialog(BuildContext context, int id) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: 'Eliminar rol',
            formFields: const [
              Text('¿Está seguro que desea eliminar este rol?')
            ],
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: () async {
              try {
                await _roleService.deleteRole(id);
                Navigator.of(context).pop();
                // setState(() {});
                _loadRoles();
              } catch (e) {
                print(e);
              }
            },
          );
        });
  }

  Future<void> _editRoleDialog(
    BuildContext context,
    Map<String, dynamic> roleData,
  ) {
    setState(() {
      formValues = roleData;
    });

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: 'Editar rol',
            formFields: [
              CustomInputField(
                label: 'Nombre del rol',
                placeHolder: 'Ingrese el nombre del rol',
                suffixIcon: Icons.workspace_premium_rounded,
                formProperty: 'name',
                maxLength: 30,
                initialValue: roleData['name'],
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
              )
            ],
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: () async {
              try {
                final roleName = formValues['name'];
                if (roleName != null && roleName.isNotEmpty) {
                  await _roleService.updateRole(roleData['id'], roleName);
                  Navigator.of(context).pop();
                  _loadRoles();
                } else {
                  print('El nombre del rol no puede estar vacío');
                }
              } catch (e) {
                print(e);
              }
            },
          );
        });
  }
}
