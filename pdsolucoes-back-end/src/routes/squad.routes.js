const express = require('express');
const squadController = require('../controllers/squad.controller');
const authMiddleware = require('../middlewares/auth.middleware');

const router = express.Router();

router.use(authMiddleware.protect);

/**
 * @swagger
 * /api/v1/squads:
 *   get:
 *     tags: [Squads]
 *     summary: Listar todos os squads
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: search
 *         required: false
 *         schema:
 *           type: string
 *         description: Filtrar squads por nome
 *     responses:
 *       200:
 *         description: Lista de squads
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Squad'
 *       401:
 *         description: Não autorizado
 */
router.get('/', squadController.getAllSquads);

/**
 * @swagger
 * /api/v1/squads/{id}:
 *   get:
 *     tags: [Squads]
 *     summary: Buscar squad por ID
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
 *         description: Squad encontrado
 *       404:
 *         description: Squad não encontrado
 */
router.get('/:id', squadController.getSquadById);

/**
 * @swagger
 * /api/v1/squads:
 *   post:
 *     tags: [Squads]
 *     summary: Criar novo squad
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
 *             properties:
 *               name:
 *                 type: string
 *                 example: Squad Alpha
 *     responses:
 *       201:
 *         description: Squad criado com sucesso
 *       400:
 *         description: Erro de validação
 */
router.post('/', squadController.createSquad);

/**
 * @swagger
 * /api/v1/squads/{id}:
 *   put:
 *     tags: [Squads]
 *     summary: Atualizar squad
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *     responses:
 *       200:
 *         description: Squad atualizado
 *       404:
 *         description: Squad não encontrado
 */
router.put('/:id', squadController.updateSquad);

/**
 * @swagger
 * /api/v1/squads/{id}:
 *   delete:
 *     tags: [Squads]
 *     summary: Deletar squad
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
 *         description: Squad deletado
 *       404:
 *         description: Squad não encontrado
 */
router.delete('/:id', squadController.deleteSquad);

module.exports = router;

