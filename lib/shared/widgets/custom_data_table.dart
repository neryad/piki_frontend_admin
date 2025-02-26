import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  final List<String> columns;
  final List<Map<String, dynamic>> rows;
  final List<String> displayFields;
  final List<String>? imageFields; // Nueva propiedad para los campos de imagen
  final TextStyle headerStyle;
  final double? columnSpacing;
  final double? dataRowMaxHeight;
  final Widget Function(Map<String, dynamic>)? actionsBuilder;

  const CustomDataTable({
    super.key,
    required this.columns,
    required this.rows,
    required this.displayFields,
    this.imageFields,
    this.headerStyle = const TextStyle(fontWeight: FontWeight.bold),
    this.columnSpacing,
    this.dataRowMaxHeight,
    this.actionsBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        child: DataTable(
          dataRowMaxHeight: dataRowMaxHeight ?? 60,
          columnSpacing:
              columnSpacing ?? MediaQuery.of(context).size.width / 12,
          columns: columns
              .map((column) => DataColumn(
                    label: Text(column, style: headerStyle),
                  ))
              .toList(),
          rows: rows.map((row) {
            final cells = displayFields.map((field) {
              if (imageFields != null && imageFields!.contains(field)) {
                return DataCell(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage(
                        image: NetworkImage(row[field]),
                        placeholder:
                            const AssetImage('assets/loading-pink.jpg'),
                        fit: BoxFit.cover,
                        width: 300,
                        height: 150,
                      ),
                    ),
                  ),
                );
              } else {
                return DataCell(Text(
                  row[field].toString(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ));
              }
            }).toList();

            if (actionsBuilder != null) {
              cells.add(DataCell(actionsBuilder!(row)));
            }

            return DataRow(cells: cells);
          }).toList(),
        ),
      ),
    );
  }
}
