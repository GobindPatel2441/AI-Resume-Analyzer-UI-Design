const fs = require('fs');
const path = require('path');

const DB_PATH = path.join(__dirname, '../mock_db.json');

const loadDb = () => {
  try {
    if (!fs.existsSync(DB_PATH)) {
      console.log('MockDb: DB file not found, creating new one.');
      return { users: [], histories: [] };
    }
    const data = fs.readFileSync(DB_PATH, 'utf8');
    if (!data.trim()) return { users: [], histories: [] };
    return JSON.parse(data);
  } catch (e) {
    console.error('MockDb: Load error:', e.message);
    return { users: [], histories: [] };
  }
};

const saveDb = (data) => {
  try {
    fs.writeFileSync(DB_PATH, JSON.stringify(data, null, 2));
    console.log('MockDb: DB saved successfully.');
  } catch (e) {
    console.error('MockDb: Save error:', e.message);
  }
};

const MockDb = {
  // User operations
  findUserByEmail: (email) => {
    const db = loadDb();
    return db.users.find(u => u.email === email);
  },
  findUserById: (id) => {
    const db = loadDb();
    return db.users.find(u => u._id === id);
  },
  createUser: (userData) => {
    const db = loadDb();
    const newUser = { ...userData, _id: Date.now().toString(), createdAt: new Date().toISOString() };
    db.users.push(newUser);
    saveDb(db);
    return newUser;
  },
  updateUserStats: (id) => {
    const db = loadDb();
    const user = db.users.find(u => u._id === id);
    if (user) {
      user.totalAnalyses = (user.totalAnalyses || 0) + 1;
      saveDb(db);
    }
  },

  // History operations
  findHistoryByUserId: (userId) => {
    const db = loadDb();
    return db.histories.filter(h => h.userId === userId).sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
  },
  createHistory: (historyData) => {
    const db = loadDb();
    const newHistory = { ...historyData, _id: Date.now().toString(), createdAt: new Date().toISOString() };
    db.histories.push(newHistory);
    saveDb(db);
    return newHistory;
  },
  deleteHistory: (historyId, userId) => {
    const db = loadDb();
    const initialLength = db.histories.length;
    db.histories = db.histories.filter(h => !(h._id === historyId && h.userId === userId));
    if (db.histories.length < initialLength) {
      saveDb(db);
      return true;
    }
    return false;
  }
};

module.exports = MockDb;
