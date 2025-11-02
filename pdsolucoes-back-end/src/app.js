const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const swaggerUi = require('swagger-ui-express');
const swaggerSpec = require('./config/swagger');

const authRoutes = require('./routes/auth.routes');
const employeeRoutes = require('./routes/employee.routes');
const squadRoutes = require('./routes/squad.routes');
const reportRoutes = require('./routes/report.routes');

const errorMiddleware = require('./middlewares/error.middleware');
const accessLogger = require('./middlewares/access.middleware');

const app = express();

app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(morgan('dev'));
app.use(accessLogger);

app.get('/', (req, res) => {
  res.redirect('/api-docs');
});

app.get('/health', (req, res) => {
  res.status(200).json({ 
    status: 'OK', 
    version: 'v1',
    timestamp: new Date().toISOString() 
  });
});

app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec, {
  customCss: '.swagger-ui .topbar { display: none }',
  customSiteTitle: 'PD Hours Control API v1',
}));

app.get('/api-docs.json', (req, res) => {
  res.setHeader('Content-Type', 'application/json');
  res.send(swaggerSpec);
});

app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/employees', employeeRoutes);
app.use('/api/v1/squads', squadRoutes);
app.use('/api/v1/reports', reportRoutes);

app.use(errorMiddleware);

module.exports = app;

