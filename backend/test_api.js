const axios = require('axios');

const test = async () => {
  try {
    console.log('Testing Health Check...');
    const health = await axios.get('http://localhost:5000/health');
    console.log('Health:', health.data);

    console.log('Testing Signup...');
    try {
      const signup = await axios.post('http://localhost:5000/auth/signup', {
        name: 'Tester',
        email: `test_${Date.now()}@test.com`,
        password: 'password123'
      });
      console.log('Signup Success:', signup.data);
    } catch (e) {
      console.error('Signup Failed:', e.response?.data || e.message);
    }
  } catch (e) {
    console.error('Initial Connection Failed:', e.message);
  }
};

test();
