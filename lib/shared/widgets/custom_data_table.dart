import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  final List<String> columns;
  final List<Map<String, dynamic>> rows;
  final List<String> displayFields;
  final TextStyle headerStyle;
  final double? columnSpacing;
  final Widget Function(Map<String, dynamic>)? actionsBuilder;

  const CustomDataTable({
    super.key,
    required this.columns,
    required this.rows,
    required this.displayFields,
    this.headerStyle = const TextStyle(fontWeight: FontWeight.bold),
    this.columnSpacing,
    this.actionsBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        child: DataTable(
          columnSpacing:
              columnSpacing ?? MediaQuery.of(context).size.width / 12,
          columns: columns
              .map((column) => DataColumn(
                    label: Text(column, style: headerStyle),
                  ))
              .toList(),
          rows: rows.map((row) {
            final cells = displayFields
                .map((field) => DataCell(Text(row[field].toString())))
                .toList();

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
