const express = require('express');
const reportController = require('../controllers/report.controller');
const authMiddleware = require('../middlewares/auth.middleware');

const router = express.Router();

router.use(authMiddleware.protect);

/**
 * @swagger
 * /api/v1/reports:
 *   get:
 *     tags: [Reports]
 *     summary: Listar todos os reports
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Lista de reports
 */
router.get('/', reportController.getAllReports);

/**
 * @swagger
 * /api/v1/reports:
 *   post:
 *     tags: [Reports]
 *     summary: Criar novo report
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - description
 *               - employeeId
 *               - spentHours
 *             properties:
 *               description:
 *                 type: string
 *                 example: Desenvolvimento de feature X
 *               employeeId:
 *                 type: string
 *                 example: 507f1f77bcf86cd799439011
 *               spentHours:
 *                 type: integer
 *                 example: 6
 *     responses:
 *       201:
 *         description: Report criado com sucesso
 *       400:
 *         description: Erro de validação
 *       404:
 *         description: Employee não encontrado
 */
router.post('/', reportController.createReport);

/**
 * @swagger
 * /api/v1/reports/squad/{squadId}/member-hours:
 *   get:
 *     tags: [Reports]
 *     summary: Horas gastas de cada membro de uma squad por período
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: squadId
 *         required: true
 *         schema:
 *           type: string
 *       - in: query
 *         name: startDate
 *         required: true
 *         schema:
 *           type: string
 *           format: date
 *           example: 2025-01-01
 *       - in: query
 *         name: endDate
 *         required: true
 *         schema:
 *           type: string
 *           format: date
 *           example: 2025-01-31
 *     responses:
 *       200:
 *         description: Horas por membro
 *       400:
 *         description: Parâmetros inválidos
 */
router.get('/squad/:squadId/member-hours', reportController.getSquadMemberHours);

/**
 * @swagger
 * /api/v1/reports/squad/{squadId}/total-hours:
 *   get:
 *     tags: [Reports]
 *     summary: Tempo total gasto de uma squad em um período
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: squadId
 *         required: true
 *         schema:
 *           type: string
 *       - in: query
 *         name: startDate
 *         required: true
 *         schema:
 *           type: string
 *           format: date
 *       - in: query
 *         name: endDate
 *         required: true
 *         schema:
 *           type: string
 *           format: date
 *     responses:
 *       200:
 *         description: Total de horas
 */
router.get('/squad/:squadId/total-hours', reportController.getSquadTotalHours);

/**
 * @swagger
 * /api/v1/reports/squad/{squadId}/average-hours:
 *   get:
 *     tags: [Reports]
 *     summary: Média de horas por dia de uma squad em um período
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: squadId
 *         required: true
 *         schema:
 *           type: string
 *       - in: query
 *         name: startDate
 *         required: true
 *         schema:
 *           type: string
 *           format: date
 *       - in: query
 *         name: endDate
 *         required: true
 *         schema:
 *           type: string
 *           format: date
 *     responses:
 *       200:
 *         description: Média de horas por dia
 */
router.get('/squad/:squadId/average-hours', reportController.getSquadAverageHoursPerDay);

/**
 * @swagger
 * /api/v1/reports/dashboard:
 *   get:
 *     tags: [Reports]
 *     summary: Dados do dashboard
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Estatísticas gerais
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   type: object
 *                   properties:
 *                     totalEmployees:
 *                       type: integer
 *                     totalSquads:
 *                       type: integer
 *                     totalReports:
 *                       type: integer
 */
router.get('/dashboard', reportController.getDashboardData);

module.exports = router;

