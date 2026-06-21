'use strict';

const { errorResponse } = require('../utils/response');
const { z } = require('zod');

const logger = require('../utils/logger');

/**
 * Global Error Handler Middleware
 */
const errorHandler = (err, req, res, next) => {
  logger.error(`[Error Middleware] ${err.message}`, { stack: err.stack, method: req.method, url: req.url });

  // Handle Zod validation errors (400)
  if (err instanceof z.ZodError) {
    return res.status(400).json(
      errorResponse('Validation failed', 400, err.flatten().fieldErrors)
    );
  }

  // Handle Prisma unique constraint errors (409)
  if (err.code === 'P2002') {
    return res.status(409).json(
      errorResponse('A record with this unique field already exists', 409)
    );
  }

  // Handle JWT errors (401)
  if (err.name === 'JsonWebTokenError' || err.name === 'TokenExpiredError') {
    return res.status(401).json(
      errorResponse(err.name === 'TokenExpiredError' ? 'Token has expired' : 'Invalid token', 401)
    );
  }

  // Handle generic errors (500)
  const statusCode = err.statusCode || 500;
  const message = err.message || 'Internal server error';

  return res.status(statusCode).json(
    errorResponse(message, statusCode)
  );
};

module.exports = errorHandler;
