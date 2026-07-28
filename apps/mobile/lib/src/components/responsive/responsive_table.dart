import 'package:flutter/material.dart';
import 'responsive_breakpoints.dart';
import '../glass_components.dart';
import '../../theme/app_colors.dart';
import '../../theme/design_tokens.dart';

class ResponsiveTableColumn {
  final String title;
  final bool numeric;

  const ResponsiveTableColumn({
    required this.title,
    this.numeric = false,
  });
}

class ResponsiveTableRow {
  final List<Widget> cells;
  final VoidCallback? onTap;

  const ResponsiveTableRow({
    required this.cells,
    this.onTap,
  });
}

/// Adaptive Table Component that automatically transforms:
/// - Compact (< 600px): Accessible Card/List view per row
/// - Medium (600 - 840px): Compact scrollable table
/// - Expanded/Large (> 840px): Full data table with headers and crisp alignment
class ResponsiveTable extends StatelessWidget {
  final List<ResponsiveTableColumn> columns;
  final List<ResponsiveTableRow> rows;
  final String? emptyText;

  const ResponsiveTable({
    super.key,
    required this.columns,
    required this.rows,
    this.emptyText = 'No data available',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (rows.isEmpty) {
      return GlassCard(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(DesignTokens.space24),
            child: Text(
              emptyText!,
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                fontSize: 14,
              ),
            ),
          ),
        ),
      );
    }

    // 1. Compact View (< 600px): Render as Card / List view per row
    if (context.isCompact) {
      return Column(
        children: rows.map((row) {
          return Padding(
            padding: const EdgeInsets.only(bottom: DesignTokens.space12),
            child: GlassCard(
              onTap: row.onTap,
              child: Column(
                children: List.generate(columns.length, (index) {
                  if (index >= row.cells.length) return const SizedBox.shrink();
                  final col = columns[index];
                  final cellWidget = row.cells[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          col.title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                        Flexible(child: cellWidget),
                      ],
                    ),
                  );
                }),
              ),
            ),
          );
        }).toList(),
      );
    }

    // 2. Medium, Expanded, Large View (Full Responsive Table)
    return GlassCard(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: context.screenWidth - 64),
          child: DataTable(
            columns: columns.map((col) {
              return DataColumn(
                numeric: col.numeric,
                label: Text(
                  col.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              );
            }).toList(),
            rows: rows.map((row) {
              return DataRow(
                onSelectChanged: row.onTap != null ? (_) => row.onTap!() : null,
                cells: row.cells.map((cell) {
                  return DataCell(cell);
                }).toList(),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
