class ApiEndpoints {
  ApiEndpoints._();

  static const String baseApi = '/api/v1';

  static const String auth = '$baseApi/auth';
  static const String users = '$baseApi/users';
  static const String employees = '$baseApi/employees';
  static const String squads = '$baseApi/squads';
  static const String reports = '$baseApi/reports';

  static String login = '$auth/login';
  static String refreshToken = '$auth/refresh-token';
  static String logout = '$auth/logout';
  static String forgotPassword = '$auth/forgot-password';
  static String resetPassword = '$auth/reset-password';

  static String getAllUsers = users;
  static String getUserById(String id) => '$users/$id';
  static String updateUser(String id) => '$users/$id';
  static String deleteUser(String id) => '$users/$id';

  static String getAllEmployees = employees;
  static String getEmployeeById(String id) => '$employees/$id';
  static String createEmployee = employees;
  static String updateEmployee(String id) => '$employees/$id';
  static String deleteEmployee(String id) => '$employees/$id';

  static String getAllSquads = squads;
  static String getSquadById(String id) => '$squads/$id';
  static String createSquad = squads;
  static String updateSquad(String id) => '$squads/$id';
  static String deleteSquad(String id) => '$squads/$id';

  static String getAllReports = reports;
  static String createReport = reports;
  static String getSquadMemberHours(String squadId) => '$reports/squad/$squadId/member-hours';
  static String getSquadTotalHours(String squadId) => '$reports/squad/$squadId/total-hours';
  static String getSquadAverageHours(String squadId) => '$reports/squad/$squadId/average-hours';
  static String getDashboard = '$reports/dashboard';
}

