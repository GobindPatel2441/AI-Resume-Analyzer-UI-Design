const MockDb = require('./utils/mock_db');

try {
  const user = MockDb.createUser({ name: 'Test', email: 'test@test.com', passwordHash: 'hash' });
  console.log('Created User:', user);
  const found = MockDb.findUserByEmail('test@test.com');
  console.log('Found User:', found);
} catch (e) {
  console.error('Test Failed:', e);
}
