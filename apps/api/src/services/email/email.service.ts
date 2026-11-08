import { Resend } from 'resend';
import { env } from '../../config/env.js';
import { logger } from '../../lib/logger.js';

const resend = new Resend(env.RESEND_API_KEY);

interface SendEmailOptions {
  to: string;
  subject: string;
  html: string;
  text?: string;
}

export async function sendEmail({ to, subject, html, text }: SendEmailOptions) {
  const { data, error } = await resend.emails.send({
    from: env.RESEND_FROM_EMAIL,
    to,
    subject,
    html,
    text,
  });

  if (error) {
    logger.error(
      {
        error,
        recipient: to,
        subject,
      },
      'Resend email delivery failed'
    );

    throw new Error(`Failed to send email: ${error.message}`);
  }

  logger.info({ emailId: data?.id, recipient: to }, 'Email sent successfully');

  return data;
}
