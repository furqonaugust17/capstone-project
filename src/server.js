'use strict';

const app = require('./app');
const { env } = require('./config/env');

const PORT = env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT} [${env.NODE_ENV}]`);
});
