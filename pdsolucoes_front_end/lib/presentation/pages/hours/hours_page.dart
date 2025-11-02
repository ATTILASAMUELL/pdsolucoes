import 'package:flutter/material.dart';
import 'package:pdsolucoes_front_end/core/constants/app_colors.dart';
import 'package:pdsolucoes_front_end/core/constants/app_typography.dart';
import 'package:pdsolucoes_front_end/presentation/pages/hours/tabs/squads_hours_tab.dart';
import 'package:pdsolucoes_front_end/presentation/pages/hours/tabs/reports_hours_tab.dart';
import 'package:pdsolucoes_front_end/presentation/pages/hours/tabs/employees_hours_tab.dart';

class HoursPage extends StatelessWidget {
  const HoursPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('Horas', style: AppTypography.h4()),
          backgroundColor: AppColors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          surfaceTintColor: Colors.transparent,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              color: AppColors.white,
              child: TabBar(
                dividerColor: Colors.transparent,
                labelColor: AppColors.blue,
                unselectedLabelColor: AppColors.gray4,
                indicatorColor: AppColors.blue,
                indicatorWeight: 4,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: AppTypography.paragraph(fontWeight: FontWeight.w600),
                unselectedLabelStyle: AppTypography.paragraph(),
                labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                indicator: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  border: const Border(
                    bottom: BorderSide(
                      color: AppColors.blue,
                      width: 4,
                    ),
                  ),
                ),
            tabs: const [
              Tab(
                text: 'Squads',
                height: 48,
              ),
              Tab(
                text: 'Reportes',
                height: 48,
              ),
              Tab(
                text: 'Funcionários(a)',
                height: 48,
              ),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            SquadsHoursTab(),
            ReportsHoursTab(),
            EmployeesHoursTab(),
          ],
        ),
      ),
    );
  }
}

