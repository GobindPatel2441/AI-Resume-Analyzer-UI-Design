const axios = require('axios');
require('dotenv').config();

const BASE_URL = 'http://localhost:5000';

const runTest = async () => {
  try {
    console.log('--- Starting Analysis Test ---');

    // 1. Signup a test user
    const email = `test_user_${Date.now()}@example.com`;
    const signupRes = await axios.post(`${BASE_URL}/auth/signup`, {
      name: 'Test User',
      email: email,
      password: 'password123'
    });
    console.log('✅ Signup successful');

    // 2. Login
    const loginRes = await axios.post(`${BASE_URL}/auth/login`, {
      email: email,
      password: 'password123'
    });
    const token = loginRes.data.token;
    console.log('✅ Login successful');

    // 3. Analyze Resume
    console.log('⏳ Sending analysis request to Gemini via backend...');
    const analysisRes = await axios.post(`${BASE_URL}/analyze-resume`, {
      resumeText: 'Experience: Senior Software Engineer at Google. Skills: Flutter, Node.js, AI. Education: Computer Science.',
      jobRole: 'Senior Full Stack Developer',
      resumeName: 'test_resume.pdf'
    }, {
      headers: { Authorization: `Bearer ${token}` }
    });

    console.log('✅ Analysis complete!');
    console.log('Result:', JSON.stringify(analysisRes.data, null, 2));

    if (analysisRes.data.score >= 0 && analysisRes.data.summary) {
      console.log('🎉 TEST PASSED: Gemini returned a valid score and summary.');
    } else {
      console.log('❌ TEST FAILED: Invalid response structure.');
    }

  } catch (error) {
    console.error('❌ Test failed with error:', error.response?.data || error.message);
  }
};

runTest();
