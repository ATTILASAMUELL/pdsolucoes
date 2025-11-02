const bcrypt = require('bcryptjs');
const prisma = require('../prisma/client');
const tokenUtil = require('../utils/token.util');
const emailService = require('./email.service');
const { UnauthorizedError, BadRequestError } = require('../exceptions');
const ErrorCodes = require('../constants/errorCodes');

class AuthService {
  async login({ email, password }) {
    const user = await prisma.user.findUnique({
      where: { email },
    });
    
    if (!user) {
      throw new UnauthorizedError(ErrorCodes.AUTH_001, 'AuthService.login');
    }
    
    const isPasswordValid = await bcrypt.compare(password, user.password);
    
    if (!isPasswordValid) {
      throw new UnauthorizedError(ErrorCodes.AUTH_001, 'AuthService.login');
    }
    
    const accessToken = tokenUtil.generateToken(user.id);
    const refreshToken = tokenUtil.generateRefreshToken(user.id);
    const hashedRefreshToken = tokenUtil.hashToken(refreshToken);

    await prisma.user.update({
      where: { id: user.id },
      data: { refreshToken: hashedRefreshToken },
    });
    
    return {
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
      },
      accessToken,
      refreshToken,
    };
  }

  async refreshToken(refreshToken) {
    if (!refreshToken) {
      throw new UnauthorizedError(ErrorCodes.AUTH_007, 'AuthService.refreshToken');
    }

    const decoded = tokenUtil.verifyRefreshToken(refreshToken);
    
    if (!decoded) {
      throw new UnauthorizedError(ErrorCodes.AUTH_008, 'AuthService.refreshToken');
    }

    const hashedRefreshToken = tokenUtil.hashToken(refreshToken);

    const user = await prisma.user.findFirst({
      where: {
        id: decoded.userId,
        refreshToken: hashedRefreshToken,
      },
    });

    if (!user) {
      throw new UnauthorizedError(ErrorCodes.AUTH_009, 'AuthService.refreshToken');
    }

    const newAccessToken = tokenUtil.generateToken(user.id);
    const newRefreshToken = tokenUtil.generateRefreshToken(user.id);
    const newHashedRefreshToken = tokenUtil.hashToken(newRefreshToken);

    await prisma.user.update({
      where: { id: user.id },
      data: { refreshToken: newHashedRefreshToken },
    });

    return {
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
      },
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
    };
  }

  async logout(userId) {
    await prisma.user.update({
      where: { id: userId },
      data: { refreshToken: null },
    });
  }

  async forgotPassword(email) {
    const user = await prisma.user.findUnique({
      where: { email },
    });
    
    if (!user) {
      return;
    }
    
    const resetToken = tokenUtil.generateResetToken();
    const resetTokenExpiry = new Date(Date.now() + 3600000);
    
    await prisma.user.update({
      where: { id: user.id },
      data: {
        resetToken,
        resetTokenExpiry,
      },
    });
    
    await emailService.sendPasswordResetEmail(email, resetToken);
  }

  async resetPassword(token, newPassword) {
    const user = await prisma.user.findFirst({
      where: {
        resetToken: token,
        resetTokenExpiry: {
          gt: new Date(),
        },
      },
    });
    
    if (!user) {
      throw new BadRequestError(ErrorCodes.AUTH_005, 'AuthService.resetPassword');
    }
    
    const hashedPassword = await bcrypt.hash(newPassword, 10);
    
    await prisma.user.update({
      where: { id: user.id },
      data: {
        password: hashedPassword,
        resetToken: null,
        resetTokenExpiry: null,
      },
    });
  }
}

module.exports = new AuthService();

