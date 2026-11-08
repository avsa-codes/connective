import express from 'express';
import v1Routes from './routes/v1/index.js';
import { requestLogger } from './middleware/request-logger.js';
import { notFoundHandler } from './middleware/not-found.js';
import { errorHandler } from './middleware/error-handler.js';
import { toNodeHandler } from 'better-auth/node';
import { auth } from './lib/auth.js';
import cors from 'cors';
import { env } from './config/env.js';

export const app = express();

// Request logging
app.use(requestLogger);

// CORS configuration
const allowedOrigins = [
  'connective://',
  ...env.CORS_ORIGINS.split(',')
    .map((origin) => origin.trim())
    .filter(Boolean),
];

app.use(
  cors({
    origin: (origin, callback) => {
      // Allow native clients and requests without an Origin header.
      if (!origin) {
        return callback(null, true);
      }

      callback(null, allowedOrigins.includes(origin));
    },
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  }),
);

// Better Auth handler
app.all('/api/auth/*splat', toNodeHandler(auth)); //Http method opener + wildcard

// JSON body parsing for application routes
app.use(express.json());

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
