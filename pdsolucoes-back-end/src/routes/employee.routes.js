const express = require('express');
const employeeController = require('../controllers/employee.controller');
const authMiddleware = require('../middlewares/auth.middleware');

const router = express.Router();

router.use(authMiddleware.protect);

/**
 * @swagger
 * /api/v1/employees:
 *   get:
 *     tags: [Employees]
 *     summary: Listar todos os funcionários
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: search
 *         required: false
 *         schema:
 *           type: string
 *         description: Filtrar funcionários por nome
 *     responses:
 *       200:
 *         description: Lista de funcionários
 */
router.get('/', employeeController.getAllEmployees);

/**
 * @swagger
 * /api/v1/employees/{id}:
 *   get:
 *     tags: [Employees]
 *     summary: Buscar funcionário por ID
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Funcionário encontrado
 *       404:
 *         description: Funcionário não encontrado
 */
router.get('/:id', employeeController.getEmployeeById);

/**
 * @swagger
 * /api/v1/employees:
 *   post:
 *     tags: [Employees]
 *     summary: Criar novo funcionário
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *               - estimatedHours
 *               - squadId
 *             properties:
 *               name:
 *                 type: string
 *                 example: João Silva
 *               estimatedHours:
 *                 type: integer
 *                 minimum: 1
 *                 maximum: 12
 *                 example: 8
 *               squadId:
 *                 type: string
 *                 example: 507f1f77bcf86cd799439011
 *     responses:
 *       201:
 *         description: Funcionário criado
 *       400:
 *         description: Erro de validação
 */
router.post('/', employeeController.createEmployee);

/**
 * @swagger
 * /api/v1/employees/{id}:
 *   put:
 *     tags: [Employees]
 *     summary: Atualizar funcionário
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     requestBody:
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               estimatedHours:
 *                 type: integer
 *                 minimum: 1
 *                 maximum: 12
 *               squadId:
 *                 type: string
 *     responses:
 *       200:
 *         description: Funcionário atualizado
 */
router.put('/:id', employeeController.updateEmployee);

/**
 * @swagger
 * /api/v1/employees/{id}:
 *   delete:
 *     tags: [Employees]
 *     summary: Deletar funcionário
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Funcionário deletado
 */
router.delete('/:id', employeeController.deleteEmployee);

module.exports = router;

