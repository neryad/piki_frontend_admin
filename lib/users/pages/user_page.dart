import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:piki_admin/roles/models/role_model.dart';
import 'package:piki_admin/roles/services/role_services.dart';
import 'package:piki_admin/shared/components/reusable_button.dart';
import 'package:piki_admin/shared/functions/table_filter.dart';
import 'package:piki_admin/shared/widgets/custom_dialog.dart';
import 'package:piki_admin/shared/widgets/custom_input_field.dart';
import 'package:piki_admin/theme/app_theme.dart';
import 'package:piki_admin/shared/widgets/custom_data_table.dart';
import 'package:piki_admin/shared/widgets/action_search_bar.dart';
// import 'package:piki_admin/users/models/user_model.dart';
import 'package:piki_admin/users/services/users_service.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final UsersService _usersService = UsersService();
  final RoleService _rolService = RoleService();
  List<Map<String, dynamic>> filteredUsers = [];
  List<Roles> roles = [];
  bool isLoading = true;
  String? error;
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> formValues = {};

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _loadRoles();
  }

  Future<void> _loadUsers() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final users = await _usersService.getUsers();
      setState(() {
        filteredUsers = users.map((user) => user.toMap()).toList();
        isLoading = false;
      });
      log('filteredUsers: $filteredUsers');
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _loadRoles() async {
    try {
      roles = await _rolService.getRoles();
      log(roles.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  void _filterUsers(String query) {
    final allUsers = filteredUsers;
    setState(() {
      filteredUsers = filterItems(
        allUsers,
        query,
        ['name', 'lastName', 'email', 'phone'],
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
              actionButtonText: 'Nuevo usuario',
              onActionPressed: () => _createUserDialog(context),
              actionButtonColor: AppTheme.radicalRed,
              actionIcon: Icons.add,
              onSearch: _filterUsers,
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
                    'Apellido',
                    'Correo',
                    'Rol',
                    'Teléfono',
                    'Opciones'
                  ],
                  displayFields: const [
                    'name',
                    'lastName',
                    'email',
                    'role',
                    'phone'
                  ],
                  rows: filteredUsers,
                  headerStyle: textStyle,
                  actionsBuilder: (user) => Row(
                    children: [
                      ReusableButton(
                        childText: 'Eliminar',
                        onPressed: () => _deleteUserDialog(context, user['id']),
                        buttonColor: Colors.red,
                        childTextColor: Colors.white,
                        iconData: Icons.delete,
                      ),
                      const SizedBox(width: 10),
                      ReusableButton(
                        childText: 'Editar',
                        onPressed: () async {
                          _editUserDialog(context, user);
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

  Future<void> _editUserDialog(
    BuildContext context,
    Map<String, dynamic> userData,
  ) async {
    setState(() {
      formValues = userData;
    });
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Crear usuario',
          formFields: [
            CustomInputField(
                label: 'Nombre',
                placeHolder: 'Ingrese el nombre del usuario',
                suffixIcon: Icons.person,
                formProperty: 'name',
                maxLength: 30,
                fromValues: formValues,
                initialValue: formValues['name'],
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
                label: 'Apellido',
                placeHolder: 'Ingrese el apellido del usuario',
                suffixIcon: Icons.person,
                formProperty: 'lastName',
                maxLength: 30,
                fromValues: formValues,
                initialValue: formValues['lastName'],
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
                }),
            CustomInputField(
                label: 'Correo',
                placeHolder: 'Ingrese el correo del usuario',
                suffixIcon: Icons.email,
                formProperty: 'email',
                maxLength: 30,
                fromValues: formValues,
                initialValue: formValues['email'],
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
                }),
            CustomInputField(
                label: 'Teléfono',
                placeHolder: 'Ingrese el teléfono del usuario',
                suffixIcon: Icons.phone,
                formProperty: 'phone',
                maxLength: 10,
                fromValues: formValues,
                initialValue: formValues['phone'],
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
                }),
            CustomInputField(
                label: 'Contraseña',
                placeHolder: 'Ingrese la contraseña del usuario',
                suffixIcon: Icons.password,
                formProperty: 'password',
                fromValues: formValues,
                initialValue: formValues['password'],
                customValidation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un contraseña';
                  }
                  return null;
                },
                customOnChanged: (value) {
                  setState(() {
                    formValues['password'] = value;
                  });
                  return null;
                }),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Rol',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: roles.map((Roles role) {
                return DropdownMenuItem<int>(
                  value: role.id,
                  child: Text(role.name),
                );
              }).toList(),
              value: formValues['role_id'],
              onChanged: (int? value) {
                setState(() {
                  formValues['role_id'] = value == value;
                });
              },
            ),
          ],
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: () async {
            try {
              await _usersService.updateUser(formValues);
              Navigator.of(context).pop();
              _loadUsers();
            } catch (e) {
              log(e.toString());
            }
          },
        );
      },
    );
  }

  Future<void> _createUserDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Crear usuario',
          formFields: [
            CustomInputField(
                label: 'Nombre',
                placeHolder: 'Ingrese el nombre del usuario',
                suffixIcon: Icons.person,
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
                label: 'Apellido',
                placeHolder: 'Ingrese el apellido del usuario',
                suffixIcon: Icons.person,
                formProperty: 'lastName',
                maxLength: 30,
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
                }),
            CustomInputField(
                label: 'Correo',
                placeHolder: 'Ingrese el correo del usuario',
                suffixIcon: Icons.email,
                formProperty: 'email',
                maxLength: 30,
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
                }),
            CustomInputField(
                label: 'Teléfono',
                placeHolder: 'Ingrese el teléfono del usuario',
                suffixIcon: Icons.phone,
                formProperty: 'phone',
                maxLength: 10,
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
                }),
            CustomInputField(
                label: 'Contraseña',
                placeHolder: 'Ingrese la contraseña del usuario',
                suffixIcon: Icons.password,
                formProperty: 'password',
                fromValues: formValues,
                customValidation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un contraseña';
                  }
                  return null;
                },
                customOnChanged: (value) {
                  setState(() {
                    formValues['password'] = value;
                  });
                  return null;
                }),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Rol',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: roles.map((role) {
                return DropdownMenuItem<int>(
                  value: role.id,
                  child: Text(role.name),
                );
              }).toList(),
              onChanged: (int? value) {
                setState(() {
                  formValues['role_id'] = value;
                });
              },
            ),
          ],
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: () async {
            try {
              await _usersService.createUser(formValues);
              Navigator.of(context).pop();
              _loadUsers();
            } catch (e) {
              log(e.toString());
            }
          },
        );
      },
    );
  }

  Future<void> _deleteUserDialog(BuildContext context, int id) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
            title: 'Eliminar usuario',
            dialogSize: 0.4,
            formFields: const [
              Text('¿Estás seguro de querer eliminar este usuario?'),
            ],
            onCancel: () => Navigator.of(context).pop(),
            // onConfirm: () => Navigator.of(context).pop(),
            onConfirm: () async {
              try {
                await _usersService.deleteUser(id);
                Navigator.of(context).pop();
                _loadUsers();
              } catch (e) {
                log(e.toString());
              }
            });
      },
    );
  }
}
