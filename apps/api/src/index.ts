import { app } from './app.js';
import { env } from './config/env.js';
import { db } from './lib/db.js';
import { logger } from './lib/logger.js';


const server = app.listen(env.PORT, () => {
  logger.info(`Server running on port ${env.PORT}`);
});

// Prevent multiple shutdown attempts
let isShuttingDown = false;

// shutdown function
async function shutdown(signal: string) {
  if (isShuttingDown) return;

  isShuttingDown = true;

  logger.info({ signal }, 'Server shutdown started');

  // Stop accepting new requests
  server.close(async () => {
    try {
     
      await db.$disconnect();

      logger.info('Database disconnected successfully');
      logger.info('Server shutdown completed');
    } catch (error) {
      logger.error({ err: error }, 'Shutdown failed');
      process.exitCode = 1;
    }
  });
}

// Listen for shutdown signals
process.on('SIGINT', () => shutdown('SIGINT'));
process.on('SIGTERM', () => shutdown('SIGTERM'));
