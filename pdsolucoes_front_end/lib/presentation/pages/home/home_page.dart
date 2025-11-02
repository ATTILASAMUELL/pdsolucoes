import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdsolucoes_front_end/core/constants/app_colors.dart';
import 'package:pdsolucoes_front_end/core/constants/app_typography.dart';
import 'package:pdsolucoes_front_end/presentation/pages/employees/employees_page.dart';
import 'package:pdsolucoes_front_end/presentation/pages/squads/squads_page.dart';
import 'package:pdsolucoes_front_end/presentation/pages/reports/reports_page.dart';
import 'package:pdsolucoes_front_end/presentation/pages/hours/hours_page.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/auth/auth_bloc.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/auth/auth_event.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/squad/squad_bloc.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/squad/squad_event.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/alerts/app_alert.dart';
import 'package:pdsolucoes_front_end/presentation/widgets/navigation/bottom_nav_bar.dart';
import 'package:pdsolucoes_front_end/data/datasources/auth_remote_datasource.dart';
import 'package:pdsolucoes_front_end/data/datasources/squad_remote_datasource.dart';
import 'package:pdsolucoes_front_end/data/repositories/auth_repository_impl.dart';
import 'package:pdsolucoes_front_end/data/repositories/squad_repository_impl.dart';
import 'package:pdsolucoes_front_end/domain/usecases/login_usecase.dart';
import 'package:pdsolucoes_front_end/domain/usecases/logout_usecase.dart';
import 'package:pdsolucoes_front_end/domain/usecases/forgot_password_usecase.dart';
import 'package:pdsolucoes_front_end/domain/usecases/get_all_squads_usecase.dart';
import 'package:pdsolucoes_front_end/domain/usecases/create_squad_usecase.dart';

class HomePage extends StatelessWidget {
  final int initialPage;

  static const int pageDashboard = 0;
  static const int pageHours = 1;
  static const int pageEmployees = 2;
  static const int pageSquads = 3;

  const HomePage({
    Key? key,
    this.initialPage = pageDashboard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final dataSource = AuthRemoteDataSource();
            final repository = AuthRepositoryImpl(dataSource);
            return AuthBloc(
              loginUseCase: LoginUseCase(repository),
              logoutUseCase: LogoutUseCase(repository),
              forgotPasswordUseCase: ForgotPasswordUseCase(repository),
            );
          },
        ),
        BlocProvider(
          create: (context) {
            final dataSource = SquadRemoteDataSource();
            final repository = SquadRepositoryImpl(dataSource);
            final bloc = SquadBloc(
              getAllSquadsUseCase: GetAllSquadsUseCase(repository),
              createSquadUseCase: CreateSquadUseCase(repository),
            );
            bloc.add(LoadSquadsEvent(isInitialLoad: true));
            return bloc;
          },
        ),
      ],
      child: _HomePageContent(initialPage: initialPage),
    );
  }
}

class _HomePageContent extends StatefulWidget {
  final int initialPage;

  const _HomePageContent({
    Key? key,
    required this.initialPage,
  }) : super(key: key);

  @override
  State<_HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<_HomePageContent> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialPage;
  }

  List<Widget> get _pages => [
        const ReportsPage(),
        const HoursPage(),
        const EmployeesPage(),
        const SquadsPage(),
      ];

  void _onItemTapped(int index) {
    String route;
    switch (index) {
      case 0:
        route = '/dashboard';
        break;
      case 1:
        route = '/horas';
        break;
      case 2:
        route = '/funcionarios';
        break;
      case 3:
        route = '/squads';
        break;
      default:
        route = '/dashboard';
    }
    
    Navigator.of(context).pushReplacementNamed(route);
  }

  void _handleLogout() {
    context.read<AuthBloc>().add(LogoutEvent());
    AppAlert.success(context, 'Logout realizado com sucesso!');
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          if (!isSmallScreen)
            Container(
              width: 250,
              color: AppColors.white,
              child: _buildSidebar(),
            ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
      appBar: isSmallScreen
          ? AppBar(
              backgroundColor: AppColors.blue,
              centerTitle: true,
              title: SvgPicture.asset(
                'assets/logo/pds-logo-v2 1.svg',
                height: 40,
                fit: BoxFit.contain,
                color: AppColors.white,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout, color: AppColors.white),
                  onPressed: _handleLogout,
                ),
              ],
              iconTheme: const IconThemeData(color: AppColors.white),
            )
          : null,
      bottomNavigationBar: isSmallScreen
          ? BottomNavBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            )
          : null,
    );
  }

  Widget _buildSidebar() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.gray2, width: 1),
            ),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/logo/pds-logo-v2 1.svg',
              height: 60,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              _buildMenuItem(
                icon: Icons.dashboard,
                title: 'Dashboard',
                index: 0,
              ),
              _buildMenuItem(
                icon: Icons.access_time,
                title: 'Horas',
                index: 1,
              ),
              _buildMenuItem(
                icon: Icons.people,
                title: 'Funcionários(a)',
                index: 2,
              ),
              _buildMenuItem(
                icon: Icons.groups,
                title: 'Squads',
                index: 3,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.gray2, width: 1),
            ),
          ),
          child: ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: Text(
              'Sair',
              style: AppTypography.paragraph(color: AppColors.error),
            ),
            onTap: _handleLogout,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.blue.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? AppColors.blue : AppColors.gray4,
        ),
        title: Text(
          title,
          style: AppTypography.paragraph(
            color: isSelected ? AppColors.blue : AppColors.black,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () => _onItemTapped(index),
      ),
    );
  }

  String _getTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Horas';
      case 2:
        return 'Funcionários(a)';
      case 3:
        return 'Squads';
      default:
        return 'PDSoluções';
    }
  }
}


