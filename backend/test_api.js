const axios = require('axios');

async function testBackend() {
  const url = 'http://localhost:5000/analyze-resume';
  const payload = {
    resumeText: "John Doe\nSoftware Engineer\nExperience: 5 years in Node.js and Flutter.",
    jobRole: "Senior Developer"
  };

  console.log('Sending request to backend...');
  try {
    const response = await axios.post(url, payload);
    console.log('Success! Backend returned:');
    console.log(JSON.stringify(response.data, null, 2));
  } catch (error) {
    console.error('Error calling backend:');
    if (error.response) {
      console.error('Status:', error.response.status);
      console.error('Data:', JSON.stringify(error.response.data, null, 2));
    } else {
      console.error('Message:', error.message);
    }
  }
}

testBackend();
