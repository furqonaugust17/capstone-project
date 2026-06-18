'use strict';

require('dotenv').config();
const { PrismaPg } = require("@prisma/adapter-pg");
const { PrismaClient } = require('../generated/prisma/client');

const adapter = new PrismaPg({ connectionString: process.env.DATABASE_URL });

const prisma = new PrismaClient({
  adapter: adapter,
  log: process.env.NODE_ENV === 'development' ? ['query', 'error', 'warn'] : ['error'],
});

module.exports = prisma;
