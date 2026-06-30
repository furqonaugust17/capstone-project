const axios = require('axios');
const api = axios.create({ baseURL: 'http://localhost:3001/api' });

async function run() {
  try {
    const { data: statsData } = await api.get('/statistics/detailed');
    console.log('Top Users:', statsData.data?.topUsers);
  } catch (e) {
    console.error(e.message);
  }
}
run();
