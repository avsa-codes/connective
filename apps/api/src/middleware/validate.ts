import type { RequestHandler } from 'express';
import type { ZodType } from 'zod';

import { AppError } from '../utils/app-error.js';

export const validate = (schema: ZodType): RequestHandler => {
  return (req, res, next) => {
    const result = schema.safeParse({
      body: req.body,
      params: req.params,
      query: req.query,
    });

    if (!result.success) {
      return next(
        new AppError(
          'Request validation failed',
          400,
          'VALIDATION_ERROR',
          result.error.issues.map((issue) => ({
            path: issue.path,
            message: issue.message,
          }))
        )
      );
    }

    res.locals.validatedData = result.data;

    next();
  };
};
