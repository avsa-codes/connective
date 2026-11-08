import { env } from '../../config/env.js';

interface SendWhatsAppOtpResult {
  success: boolean;
  requestId?: string;
}

interface Fast2SMSResponse {
  status?: boolean;
  message?: string;
  request_id?: string;
}

export async function sendWhatsAppOtp(
  phoneNumber: string,
  otp: string
): Promise<SendWhatsAppOtpResult> {
  const normalizedPhone = phoneNumber.replace(/\D/g, '');

  if (!/^\d{10,15}$/.test(normalizedPhone)) {
    throw new Error('Invalid recipient phone number.');
  }

  if (!/^\d{6}$/.test(otp)) {
    throw new Error('OTP must contain exactly six digits.');
  }

  const endpoint =
    `https://www.fast2sms.com/dev/whatsapp/v26.0/` +
    `${env.FAST2SMS_PHONE_NUMBER_ID}/messages`;

  const payload = {
    messaging_product: 'whatsapp',
    recipient_type: 'individual',
    to: normalizedPhone,
    type: 'template',
    template: {
      name: env.FAST2SMS_WHATSAPP_TEMPLATE_NAME,
      language: {
        code: env.FAST2SMS_WHATSAPP_TEMPLATE_LANGUAGE,
      },
      components: [
        {
          type: 'body',
          parameters: [
            {
              type: 'text',
              text: otp,
            },
          ],
        },
        {
          type: 'button',
          sub_type: 'url',
          index: '0',
          parameters: [
            {
              type: 'text',
              text: otp,
            },
          ],
        },
      ],
    },
  };

  const response = await fetch(endpoint, {
    method: 'POST',
    headers: {
      Authorization: env.FAST2SMS_API_KEY,
      'Content-Type': 'application/json',
      Accept: 'application/json',
    },
    body: JSON.stringify(payload),
  });

  const responseText = await response.text();

  let result: Fast2SMSResponse;

  try {
    result = JSON.parse(responseText) as Fast2SMSResponse;
  } catch {
    throw new Error(
      `Fast2SMS returned an invalid response (HTTP ${response.status}).`
    );
  }

  if (!response.ok || result.status === false) {
    throw new Error(
      result.message || `WhatsApp delivery request failed (${response.status}).`
    );
  }

  return {
    success: true,
    requestId: result.request_id,
  };
}
