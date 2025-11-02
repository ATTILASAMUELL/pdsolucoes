class ValidateMiddleware {
  validateLogin(req, res, next) {
    const { email, password } = req.body;
    const errors = [];
    
    if (!email || !email.includes('@')) {
      errors.push('Email inválido');
    }
    
    if (!password) {
      errors.push('Senha é obrigatória');
    }
    
    if (errors.length > 0) {
      return res.status(400).json({
        success: false,
        message: 'Erro de validação',
        errors,
      });
    }
    
    next();
  }
}

module.exports = new ValidateMiddleware();

