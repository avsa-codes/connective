import { sendEmail } from '../email.service.js';

interface VerificationEmailParams {
  name: string | null;
  email: string;
  url: string;
}

function escapeHtml(value: string): string {
  return value
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;');
}

export async function sendVerificationEmail({
  name,
  email,
  url,
}: VerificationEmailParams) {
  const recipientName = escapeHtml(name?.trim() || 'there');
  const verificationUrl = escapeHtml(url);

  await sendEmail({
    to: email,
    subject: 'Verify your Connective email address',

    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto;">
        <h2>Welcome to Connective!</h2>

        <p>Hi ${recipientName},</p>

        <p>
          Please verify your email address to activate your Connective account.
        </p>

        <a
          href="${verificationUrl}"
          style="
            display: inline-block;
            padding: 12px 24px;
            background: #111827;
            color: #ffffff;
            text-decoration: none;
            border-radius: 6px;
          "
        >
          Verify Email
        </a>

        <p>This verification link expires in 15 minutes.</p>

        <p>
          If you didn't create this account, you can safely ignore this email.
        </p>
      </div>
    `,

    text: `
      Welcome to Connective!

      Hi ${name?.trim() || 'there'},

      Please verify your email address using this link:

      ${url}

      This verification link expires in 15 minutes.

      If you didn't create this account, you can safely ignore this email.
    `,
  });
}
