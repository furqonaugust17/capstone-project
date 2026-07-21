'use strict';

require('dotenv').config();
const { Pool } = require('pg');
const { PrismaPg } = require("@prisma/adapter-pg");
const { PrismaClient } = require('../generated/prisma/client');

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);

const prisma = new PrismaClient({
  adapter: adapter,
  log: process.env.NODE_ENV === 'development' ? ['query', 'error', 'warn'] : ['error'],
});

module.exports = prisma;
