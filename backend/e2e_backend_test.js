const axios = require('axios');
require('dotenv').config();

const BASE_URL = 'http://localhost:5000';

async function runE2ETests() {
  console.log('🚀 Starting Full Backend E2E Testing...');
  console.log('-------------------------------------------');

  let token = '';
  const testEmail = `tester_${Date.now()}@test.com`;

  try {
    // 1. Health Check
    console.log('[TEST 1] Health Check...');
    const health = await axios.get(`${BASE_URL}/health`);
    console.log('✅ Health check passed:', health.data);

    // 2. Signup
    console.log('\n[TEST 2] User Signup...');
    const signup = await axios.post(`${BASE_URL}/auth/signup`, {
      name: 'E2E Tester',
      email: testEmail,
      password: 'password123'
    });
    console.log('✅ Signup successful');

    // 3. Login
    console.log('\n[TEST 3] User Login...');
    const login = await axios.post(`${BASE_URL}/auth/login`, {
      email: testEmail,
      password: 'password123'
    });
    token = loginResData = login.data.token;
    console.log('✅ Login successful, token received');

    // 4. Resume Analysis (Gemini)
    console.log('\n[TEST 4] Resume Analysis (Gemini Integration)...');
    console.log('⏳ Sending request to Gemini (may take a few seconds)...');
    const analysis = await axios.post(`${BASE_URL}/analyze-resume`, {
      resumeText: 'Experience: Lead Flutter Developer at TechCorp. Skills: Firebase, Gemini AI, Clean Architecture. Education: MIT.',
      jobRole: 'Senior Mobile Engineer',
      resumeName: 'e2e_resume.pdf'
    }, {
      headers: { Authorization: `Bearer ${token}` }
    });
    console.log('✅ Analysis complete!');
    console.log('Analysis Result:', {
      score: analysis.data.score,
      summary: analysis.data.summary.substring(0, 50) + '...',
      historyId: analysis.data.historyId
    });

    // 5. History Retrieval
    console.log('\n[TEST 5] History Retrieval...');
    const history = await axios.get(`${BASE_URL}/analyze-resume/history`, {
      headers: { Authorization: `Bearer ${token}` }
    });
    console.log(`✅ History retrieved: ${history.data.length} items found`);
    if (history.data.length > 0) {
      console.log('First item job title:', history.data[0].jobTitle);
    }

    // 6. Profile Stats
    console.log('\n[TEST 6] User Profile Stats...');
    const profile = await axios.get(`${BASE_URL}/analyze-resume/profile`, {
      headers: { Authorization: `Bearer ${token}` }
    });
    console.log('✅ Profile stats retrieved:', {
      name: profile.data.name,
      totalAnalyses: profile.data.totalAnalyses,
      avgScore: profile.data.avgScore
    });

    console.log('\n-------------------------------------------');
    console.log('🎉 ALL BACKEND E2E TESTS PASSED SUCCESSFULLY!');
    console.log('-------------------------------------------');

  } catch (error) {
    console.error('\n❌ E2E TEST FAILED!');
    console.error('Error:', error.response?.data || error.message);
    process.exit(1);
  }
}

runE2ETests();
