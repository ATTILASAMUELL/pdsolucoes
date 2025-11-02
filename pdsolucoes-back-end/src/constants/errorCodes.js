const ErrorCodes = {
  AUTH_001: {
    code: 'AUTH_001',
    message: 'Credenciais inválidas',
    statusCode: 401,
  },
  AUTH_002: {
    code: 'AUTH_002',
    message: 'Token não fornecido',
    statusCode: 401,
  },
  AUTH_003: {
    code: 'AUTH_003',
    message: 'Token inválido',
    statusCode: 401,
  },
  AUTH_004: {
    code: 'AUTH_004',
    message: 'Token expirado',
    statusCode: 401,
  },
  AUTH_005: {
    code: 'AUTH_005',
    message: 'Token de reset inválido ou expirado',
    statusCode: 400,
  },
  AUTH_006: {
    code: 'AUTH_006',
    message: 'Usuário não encontrado',
    statusCode: 401,
  },
  AUTH_007: {
    code: 'AUTH_007',
    message: 'Refresh token não fornecido',
    statusCode: 401,
  },
  AUTH_008: {
    code: 'AUTH_008',
    message: 'Refresh token inválido',
    statusCode: 401,
  },
  AUTH_009: {
    code: 'AUTH_009',
    message: 'Sessão expirada, faça login novamente',
    statusCode: 401,
  },

  USER_001: {
    code: 'USER_001',
    message: 'Usuário não encontrado',
    statusCode: 404,
  },
  USER_002: {
    code: 'USER_002',
    message: 'Email já está em uso',
    statusCode: 409,
  },

  SQUAD_001: {
    code: 'SQUAD_001',
    message: 'Squad não encontrado',
    statusCode: 404,
  },
  SQUAD_002: {
    code: 'SQUAD_002',
    message: 'Campo obrigatório: name',
    statusCode: 400,
  },

  EMPLOYEE_001: {
    code: 'EMPLOYEE_001',
    message: 'Funcionário não encontrado',
    statusCode: 404,
  },
  EMPLOYEE_002: {
    code: 'EMPLOYEE_002',
    message: 'Campos obrigatórios: name, estimatedHours, squadId',
    statusCode: 400,
  },
  EMPLOYEE_003: {
    code: 'EMPLOYEE_003',
    message: 'estimatedHours deve estar entre 1 e 12',
    statusCode: 400,
  },

  REPORT_001: {
    code: 'REPORT_001',
    message: 'Report não encontrado',
    statusCode: 404,
  },
  REPORT_002: {
    code: 'REPORT_002',
    message: 'Campos obrigatórios: description, employeeId, spentHours',
    statusCode: 400,
  },
  REPORT_003: {
    code: 'REPORT_003',
    message: 'Parâmetros obrigatórios: startDate, endDate (formato: YYYY-MM-DD)',
    statusCode: 400,
  },

  DB_001: {
    code: 'DB_001',
    message: 'Registro duplicado',
    statusCode: 409,
  },
  DB_002: {
    code: 'DB_002',
    message: 'Registro não encontrado',
    statusCode: 404,
  },
  DB_003: {
    code: 'DB_003',
    message: 'Relação inválida no banco de dados',
    statusCode: 400,
  },
  DB_004: {
    code: 'DB_004',
    message: 'Violação de restrição de relacionamento',
    statusCode: 400,
  },
  DB_005: {
    code: 'DB_005',
    message: 'Erro no banco de dados',
    statusCode: 500,
  },

  VALIDATION_001: {
    code: 'VALIDATION_001',
    message: 'Erro de validação',
    statusCode: 400,
  },

  INTERNAL_001: {
    code: 'INTERNAL_001',
    message: 'Erro interno do servidor',
    statusCode: 500,
  },

  FORBIDDEN_001: {
    code: 'FORBIDDEN_001',
    message: 'Acesso negado',
    statusCode: 403,
  },
  FORBIDDEN_002: {
    code: 'FORBIDDEN_002',
    message: 'Você não tem permissão para realizar esta ação',
    statusCode: 403,
  },
};

module.exports = ErrorCodes;


