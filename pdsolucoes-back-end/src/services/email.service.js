const nodemailer = require('nodemailer');
const env = require('../config/env');

class EmailService {
  constructor() {
    this.transporter = nodemailer.createTransport({
      host: env.EMAIL_HOST,
      port: env.EMAIL_PORT,
      secure: env.EMAIL_PORT === '465',
      auth: {
        user: env.EMAIL_USER,
        pass: env.EMAIL_PASS,
      },
    });
  }

  async sendPasswordResetEmail(to, resetToken) {
    const resetUrl = `${env.FRONTEND_URL}/reset-password?token=${resetToken}`;
    
    const mailOptions = {
      from: env.EMAIL_FROM,
      to,
      subject: 'Recuperação de Senha',
      html: `
        <h1>Recuperação de Senha</h1>
        <p>Você solicitou a recuperação de senha.</p>
        <p>Clique no link abaixo para resetar sua senha:</p>
        <a href="${resetUrl}">${resetUrl}</a>
        <p>Este link expira em 1 hora.</p>
        <p>Se você não solicitou isso, ignore este email.</p>
      `,
    };
    
    try {
      await this.transporter.sendMail(mailOptions);
      console.log('Email de recuperação enviado para:', to);
    } catch (error) {
      console.error('Erro ao enviar email:', error);
      throw new Error('Erro ao enviar email de recuperação');
    }
  }

  async sendWelcomeEmail(to, name) {
    const mailOptions = {
      from: env.EMAIL_FROM,
      to,
      subject: 'Bem-vindo!',
      html: `
        <h1>Bem-vindo, ${name}!</h1>
        <p>Sua conta foi criada com sucesso.</p>
        <p>Acesse o sistema em: ${env.FRONTEND_URL}</p>
      `,
    };
    
    try {
      await this.transporter.sendMail(mailOptions);
      console.log('Email de boas-vindas enviado para:', to);
    } catch (error) {
      console.error('Erro ao enviar email:', error);
    }
  }
}

module.exports = new EmailService();





