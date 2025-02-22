import 'package:flutter/material.dart';
import 'package:piki_admin/shared/components/reusable_button.dart';
import 'package:piki_admin/shared/functions/table_filter.dart';
import 'package:piki_admin/shared/widgets/custom_dialog.dart';
import 'package:piki_admin/shared/widgets/custom_input_field.dart';
import 'package:piki_admin/theme/app_theme.dart';
import 'package:piki_admin/shared/widgets/custom_data_table.dart';
import 'package:piki_admin/shared/widgets/action_search_bar.dart';
import 'package:piki_admin/users/models/user_model.dart';
import 'package:piki_admin/users/services/users_service.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final UsersService _usersService = UsersService();
  List<Map<String, dynamic>> filteredUsers = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadUsers();
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
      print('filteredUsers: $filteredUsers');
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
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
                        onPressed: () => _deleteUserDialog(context),
                        buttonColor: Colors.red,
                        childTextColor: Colors.white,
                        iconData: Icons.delete,
                      ),
                      const SizedBox(width: 10),
                      ReusableButton(
                        childText: 'Editar',
                        onPressed: () async {
                          //  print(user['id']);
                          final userData = await _usersService.getUserById(3);
                          print(userData);
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

  Future<void> _editUserDialog(BuildContext context, String id) async {
    print(id);
    return;
    final User user = await _usersService.getUserById(int.parse(id));
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Editar usuario',
          formFields: [
            CustomInputField(
              label: 'Nombre',
              placeHolder: 'Ingrese el nombre del usuario',
              suffixIcon: Icons.person,
              formProperty: 'name',
              maxLength: 30,
              fromValues: {'name': user.name},
            ),
            CustomInputField(
              label: 'Apellido',
              placeHolder: 'Ingrese el apellido del usuario',
              suffixIcon: Icons.person,
              formProperty: 'lastName',
              maxLength: 30,
              fromValues: {'lastName': user.lastName},
            ),
            CustomInputField(
              label: 'Correo',
              placeHolder: 'Ingrese el correo del usuario',
              suffixIcon: Icons.email,
              formProperty: 'email',
              maxLength: 30,
              fromValues: {'email': user.email},
            ),
            CustomInputField(
              label: 'Teléfono',
              placeHolder: 'Ingrese el teléfono del usuario',
              suffixIcon: Icons.phone,
              formProperty: 'phone',
              maxLength: 10,
              fromValues: {'phone': user.phone},
            ),
            // CustomInputField(
            //   label: 'Contraseña',
            //   placeHolder: 'Ingrese la contraseña del usuario',
            //   suffixIcon: Icons.password,
            //   formProperty: 'password',
            //   fromValues: {'password': user.},
            // ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Rol',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: ['Administrador', 'Usuario'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {},
            ),
          ],
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: () => Navigator.of(context).pop(),
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
            const CustomInputField(
              label: 'Nombre',
              placeHolder: 'Ingrese el nombre del usuario',
              suffixIcon: Icons.person,
              formProperty: 'name',
              maxLength: 30,
              fromValues: {},
            ),
            const CustomInputField(
              label: 'Apellido',
              placeHolder: 'Ingrese el apellido del usuario',
              suffixIcon: Icons.person,
              formProperty: 'lastName',
              maxLength: 30,
              fromValues: {},
            ),
            const CustomInputField(
              label: 'Correo',
              placeHolder: 'Ingrese el correo del usuario',
              suffixIcon: Icons.email,
              formProperty: 'email',
              maxLength: 30,
              fromValues: {},
            ),
            const CustomInputField(
              label: 'Teléfono',
              placeHolder: 'Ingrese el teléfono del usuario',
              suffixIcon: Icons.phone,
              formProperty: 'phone',
              maxLength: 10,
              fromValues: {},
            ),
            const CustomInputField(
              label: 'Contraseña',
              placeHolder: 'Ingrese la contraseña del usuario',
              suffixIcon: Icons.password,
              formProperty: 'password',
              fromValues: {},
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Rol',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: ['Administrador', 'Usuario'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {},
            ),
          ],
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  Future<void> _deleteUserDialog(BuildContext context) {
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
          onConfirm: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}
