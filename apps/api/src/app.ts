import express from 'express';
import v1Routes from './routes/v1/index.js';
import { requestLogger } from './middleware/request-logger.js';
import { notFoundHandler } from './middleware/not-found.js';
import { errorHandler } from './middleware/error-handler.js';

export const app = express();

// Global middleware
app.use(express.json());
app.use(requestLogger);

// Base health check (infrastructure)
app.get('/health', (_req, res) => {
  res.status(200).json({
    success: true,
    message: 'Connective API is running',
  });
});

// Versioned API routes
app.use('/api/v1', v1Routes);

// Handle unknown routes
app.use(notFoundHandler);

// Centralised error handling
app.use(errorHandler);
