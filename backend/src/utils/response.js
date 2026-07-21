'use strict';

/**
 * Standard success response wrapper
 * @param {any} data - The data to return to the client
 * @param {number} statusCode - HTTP status code (default 200)
 * @param {string} message - Custom success message
 */
const successResponse = (data, statusCode = 200, message = 'Operation successful') => {
  return {
    success: true,
    message,
    data,
    statusCode,
  };
};

/**
 * Standard error response wrapper
 * @param {string} message - Error message to return to the client
 * @param {number} statusCode - HTTP status code
 * @param {any} errors - Detailed error list (e.g., Zod validation errors)
 */
const errorResponse = (message, statusCode = 500, errors = null) => {
  return {
    success: false,
    message,
    errors,
    statusCode,
  };
};

module.exports = {
  successResponse,
  errorResponse,
};
