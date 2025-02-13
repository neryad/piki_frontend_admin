import 'package:flutter/material.dart';
import 'package:piki_admin/shared/components/reusable_button.dart';
import 'package:piki_admin/theme/app_theme.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  static List<Map<String, dynamic>> users = [
    {
      'name': 'Sample user',
      'lastName': 'Sample lastName',
      'phone': '809-808-0808',
      'email': 'sample@email.com',
      'role': 'Administrador',
    },
    {
      'name': 'Sample user',
      'lastName': 'Sample lastName',
      'phone': '809-808-0808',
      'email': 'sample@email.com',
      'role': 'Administrador',
    },
    {
      'name': 'Sample user',
      'lastName': 'Sample lastName',
      'phone': '809-808-0808',
      'email': 'sample@email.com',
      'role': 'Administrador',
    },
  ];

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontWeight: FontWeight.bold);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Barra de búsqueda
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 115),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusableButton(
                    childText: 'Nuevo usuario',
                    onPressed: () {},
                    buttonColor: AppTheme.radicalRed,
                    childTextColor: Colors.white,
                    iconData: Icons.add,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            // Tabla de productos
            Expanded(
              child: DataTable(
                columnSpacing: MediaQuery.of(context).size.width / 10,
                columns: const [
                  DataColumn(label: Text('Nombre', style: textStyle)),
                  DataColumn(label: Text('Apellido', style: textStyle)),
                  DataColumn(
                      label: Text(
                    'Correo',
                    style: textStyle,
                  )),
                  DataColumn(
                      label: Text(
                    'Rol',
                    style: textStyle,
                  )),
                  DataColumn(
                      label: Text(
                    'Teléfono',
                    style: textStyle,
                  )),
                  DataColumn(
                      label: Text(
                    'Opciones',
                    style: textStyle,
                  )),
                ],
                rows: users.map((product) {
                  return DataRow(cells: [
                    DataCell(Text(product['name'])),
                    DataCell(Text(product['lastName'])),
                    DataCell(Text(product['email'])),
                    DataCell(Text(product['role'])),
                    DataCell(Text(product['phone'])),
                    DataCell(Row(
                      children: [
                        TextButton.icon(
                          label: const Text('Eliminar'),
                          icon: const Icon(Icons.delete, color: Colors.white),
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.red),
                            foregroundColor:
                                WidgetStateProperty.all(Colors.white),
                          ),
                          onPressed: () {
                            // Acción para eliminar
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        TextButton.icon(
                          label: const Text('Editar'),
                          icon: const Icon(Icons.edit, color: Colors.white),
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(AppTheme.rose),
                            foregroundColor:
                                WidgetStateProperty.all(Colors.white),
                          ),
                          onPressed: () {
                            // Acción para eliminar
                          },
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
