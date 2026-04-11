const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');
require('dotenv').config();

const authRoutes = require('./routes/auth');
const resumeRoutes = require('./routes/resume');

const app = express();
const PORT = process.env.PORT || 5000;

// ── Middleware ──────────────────────────────────────────────
app.use(cors());
app.use(express.json({ limit: '5mb' }));

app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
  next();
});

// ── Database ────────────────────────────────────────────────
global.isDbConnected = false;
const mongoURI = process.env.MONGO_URI || 'mongodb://localhost:27017/ai_resume_analyzer';

mongoose
  .connect(mongoURI, {
    serverSelectionTimeoutMS: 5000, 
  })
  .then(() => {
    console.log('✅ MongoDB connected successfully');
    global.isDbConnected = true;
  })
  .catch((err) => {
    console.error('❌ MongoDB connection error:', err.message);
    console.warn('ℹ️  FALLBACK: Using local JSON storage for this session.');
    global.isDbConnected = false;
  });

// ── Routes ──────────────────────────────────────────────────
app.get('/health', (req, res) => res.json({ status: 'ok', timestamp: new Date() }));
app.use('/auth', authRoutes);
app.use('/analyze-resume', resumeRoutes);

// Legacy unauthenticated analyze-resume for backward compat (no DB save)
// Disabled: all requests now go through /analyze-resume with JWT

// ── Start ───────────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`\n🚀 Backend server running on http://localhost:${PORT}`);
  console.log(`   POST /auth/signup       — Create account`);
  console.log(`   POST /auth/login        — Get JWT token`);
  console.log(`   POST /analyze-resume    — Analyze resume (JWT required)`);
  console.log(`   GET  /analyze-resume/history   — Get history (JWT required)`);
  console.log(`   GET  /analyze-resume/profile   — Get profile (JWT required)\n`);
});
