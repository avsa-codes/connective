import { Router } from 'express';
import { z } from 'zod';
import { validate } from '../../middleware/validate.js';
import { logger } from '../../lib/logger.js';
import { db } from '../../lib/db.js';

const router = Router();

router.get('/health', (_req, res) => {
  
  logger.info({ event: 'health.check' }, 'Health check requested');

  res.status(200).json({
    success: true,
    message: 'Connective API v1 is running',
    version: '1.0.0',
  });
});

router.get('/ready', async (_req, res) => {
  try {
    await db.$queryRaw`SELECT 1`;

    res.status(200).json({
      status: 'ok',
      database: 'connected',
    });
  } catch {
    res.status(503).json({
      status: 'error',
      database: 'disconnected',
    });
  }
});

const testSchema = z.object({
  body: z.object({
    name: z.string().min(3),
    email: z.string().email(),
  }),
});

router.post('/validation-test', validate(testSchema), (req, res) => {
  const { body } = res.locals.validatedData;

  res.status(200).json({
    success: true,
    message: 'Validation successful',
    data: body,
  });
});

export default router;
