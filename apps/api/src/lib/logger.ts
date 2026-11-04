import { env } from '../config/env.js';
import pino from 'pino';

const isProduction = env.NODE_ENV === 'production';

export const logger = pino({
  level: env.LOG_LEVEL,

  redact: {
    paths: [
      'req.headers.authorization',
      'req.headers.cookie',
      'res.headers.set-cookie',
    ],
    censor: '[REDACTED]',
  },

  ...(isProduction
    ? {}
    : {
        transport: {
          target: 'pino-pretty',
          options: {
            colorize: true,
            translateTime: 'SYS:standard',
            ignore: 'pid,hostname',
          },
        },
      }),
});
