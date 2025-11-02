const authService = require('../services/auth.service');
const asyncHandler = require('../utils/asyncHandler');
const ApiResponse = require('../utils/apiResponse');

class AuthController {
  login = asyncHandler(async (req, res) => {
    const { email, password } = req.body;
    const result = await authService.login({ email, password });
    
    return ApiResponse.success(res, result, 'Login realizado com sucesso');
  });

  refreshToken = asyncHandler(async (req, res) => {
    const { refreshToken } = req.body;
    const result = await authService.refreshToken(refreshToken);
    
    return ApiResponse.success(res, result, 'Token atualizado com sucesso');
  });

  logout = asyncHandler(async (req, res) => {
    await authService.logout(req.user.id);
    
    return ApiResponse.noContent(res, 'Logout realizado com sucesso');
  });

  forgotPassword = asyncHandler(async (req, res) => {
    const { email } = req.body;
    await authService.forgotPassword(email);
    
    return ApiResponse.noContent(res, 'Email de recuperação enviado com sucesso');
  });

  resetPassword = asyncHandler(async (req, res) => {
    const { token, newPassword } = req.body;
    await authService.resetPassword(token, newPassword);
    
    return ApiResponse.noContent(res, 'Senha alterada com sucesso');
  });
}

module.exports = new AuthController();

