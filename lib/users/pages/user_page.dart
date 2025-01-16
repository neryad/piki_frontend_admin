import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  static List<Map<String, dynamic>> users = [
    {
      'name': 'Sample user',
      'email': 'sample@email.com',
      'role': 'Administrador',
      'phone': '809-808-0808',
    },
    {
      'name': 'Sample user',
      'email': 'sample@email.com',
      'role': 'Administrador',
      'phone': '809-808-0808',
    },
    {
      'name': 'Sample user',
      'email': 'sample@email.com',
      'role': 'Usuario',
      'phone': '809-808-0808',
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
                  TextButton.icon(
                    onPressed: () {},
                    label: const Text('Nuevo usuario',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    icon: const Icon(Icons.add),
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.pink.shade300),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                    ),
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
                columnSpacing: MediaQuery.of(context).size.width / 8,
                columns: const [
                  DataColumn(label: Text('Nombre', style: textStyle)),
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
                    DataCell(Text(product['email'])),
                    DataCell(Text(product['role'])),
                    DataCell(Text(product['phone'])),
                    DataCell(Row(
                      children: [
                        TextButton.icon(
                          label: const Text('Eliminar'),
                          icon: const Icon(Icons.delete),
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.red.shade400),
                            foregroundColor:
                                WidgetStateProperty.all(Colors.white),
                          ),
                          onPressed: () {
                            // Acción para eliminar
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        TextButton.icon(
                          label: const Text('Editar'),
                          icon: const Icon(Icons.edit),
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.pink.shade300),
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
