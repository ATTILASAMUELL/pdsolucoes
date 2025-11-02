class ApiResponse {
  static success(res, data, message = null, statusCode = 200, meta = null) {
    const response = {
      success: true,
      status: 'success',
      ...(message && { message }),
      data,
      ...(meta && { meta }),
      timestamp: new Date().toISOString(),
    };

    return res.status(statusCode).json(response);
  }

  static created(res, data, message = 'Recurso criado com sucesso', meta = null) {
    const response = {
      success: true,
      status: 'success',
      message,
      data,
      ...(meta && { meta }),
      timestamp: new Date().toISOString(),
    };

    return res.status(201).json(response);
  }

  static noContent(res, message = 'Operação realizada com sucesso') {
    const response = {
      success: true,
      status: 'success',
      message,
      timestamp: new Date().toISOString(),
    };

    return res.status(200).json(response);
  }

  static paginated(res, data, pagination, message = null) {
    const response = {
      success: true,
      status: 'success',
      ...(message && { message }),
      data,
      pagination: {
        page: pagination.page,
        limit: pagination.limit,
        total: pagination.total,
        totalPages: Math.ceil(pagination.total / pagination.limit),
        hasNext: pagination.page < Math.ceil(pagination.total / pagination.limit),
        hasPrev: pagination.page > 1,
      },
      timestamp: new Date().toISOString(),
    };

    return res.status(200).json(response);
  }

  static cached(res, data, message = null, meta = null) {
    const response = {
      success: true,
      status: 'success',
      ...(message && { message }),
      data,
      cached: true,
      ...(meta && { meta }),
      timestamp: new Date().toISOString(),
    };

    return res.status(200).json(response);
  }
}

module.exports = ApiResponse;




