import 'package:flutter/material.dart';
import 'package:pdsolucoes_front_end/core/constants/app_colors.dart';
import 'package:pdsolucoes_front_end/core/constants/app_typography.dart';

class AppDataTable extends StatelessWidget {
  final List<String> headers;
  final List<List<dynamic>> rows;
  final List<Function(int)>? actions;
  final List<String>? actionLabels;

  const AppDataTable({
    Key? key,
    required this.headers,
    required this.rows,
    this.actions,
    this.actionLabels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                ...headers.map(
                  (header) => Expanded(
                    child: Text(
                      header,
                      style: AppTypography.paragraph(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (actions != null)
                  SizedBox(
                    width: 150,
                    child: Text(
                      'Ações',
                      style: AppTypography.paragraph(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rows.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              color: AppColors.gray2,
            ),
            itemBuilder: (context, index) {
              final row = rows[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    ...row.map(
                      (cell) => Expanded(
                        child: Text(
                          cell.toString(),
                          style: AppTypography.paragraph(color: AppColors.black),
                        ),
                      ),
                    ),
                    if (actions != null)
                      SizedBox(
                        width: 150,
                        child: Center(
                          child: SizedBox(
                            width: 140,
                            child: ElevatedButton(
                              onPressed: () => actions![index](index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.blue,
                                foregroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                actionLabels?[index] ?? 'Ação',
                                style: AppTypography.small(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

