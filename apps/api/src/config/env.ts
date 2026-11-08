import 'dotenv/config';
import { z } from 'zod';

const envSchema = z.object({
  DATABASE_URL: z.string().min(1, 'DATABASE_URL is required'),

  RESEND_API_KEY: z.string().min(1, 'RESEND_API_KEY is required'),

  RESEND_FROM_EMAIL: z
    .string()
    .email('RESEND_FROM_EMAIL must be a valid email'),

  BETTER_AUTH_URL: z.string().url('BETTER_AUTH_URL must be a valid URL'),

  BETTER_AUTH_SECRET: z
    .string()
    .min(32, 'BETTER_AUTH_SECRET must be at least 32 characters'),

  FAST2SMS_API_KEY: z.string().min(1, 'FAST2SMS_API_KEY is required'),

  FAST2SMS_PHONE_NUMBER_ID: z
    .string()
    .min(1, 'FAST2SMS_PHONE_NUMBER_ID is required'),

  FAST2SMS_WHATSAPP_TEMPLATE_ID: z
    .string()
    .min(1, 'FAST2SMS_WHATSAPP_TEMPLATE_ID is required'),

  FAST2SMS_WHATSAPP_TEMPLATE_NAME: z.string().min(1),

  FAST2SMS_WHATSAPP_TEMPLATE_LANGUAGE: z.string().min(1),

  CORS_ORIGINS: z.string().default(''),

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
