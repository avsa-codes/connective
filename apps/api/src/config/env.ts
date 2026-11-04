import 'dotenv/config';
import { z } from 'zod';

const envSchema = z.object({
  DATABASE_URL: z.string().min(1, 'DATABASE_URL is required'),

  NODE_ENV: z
    .enum(['development', 'production', 'test'])
    .default('development'),

  LOG_LEVEL: z
    .enum(['fatal', 'error', 'warn', 'info', 'debug', 'trace', 'silent'])
    .default('info'),

  PORT: z.coerce.number().int().positive().default(3000),
});

const result = envSchema.safeParse(process.env);

if (!result.success) {
  console.error('Invalid environment configuration:');
  console.error(result.error.flatten().fieldErrors);
  process.exit(1);
}

export const env = result.data;
