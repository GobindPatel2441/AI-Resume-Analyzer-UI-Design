const express = require('express');
const router = express.Router();
const { GoogleGenerativeAI } = require('@google/generative-ai');
const authMiddleware = require('../middleware/auth');
const ResumeHistory = require('../models/ResumeHistory');
const User = require('../models/User');
const MockDb = require('../utils/mock_db');

// Initialize Gemini AI
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
const genModel = genAI.getGenerativeModel({ 
  model: 'gemini-2.5-flash',
  generationConfig: { responseMimeType: 'application/json' }
});

// POST /analyze-resume (protected)
router.post('/', authMiddleware, async (req, res) => {
  const { resumeText, jobRole, resumeName } = req.body;

  if (!resumeText || !jobRole) {
    return res.status(400).json({ error: 'resumeText and jobRole are required' });
  }

  const prompt = `You are an expert ATS resume analyzer. Analyze the following resume for the job role: "${jobRole}".

Return ONLY a valid JSON object with this exact structure:
{
  "score": <integer 0-100>,
  "summary": "<2-3 sentence professional assessment>",
  "strengths": ["<strength 1>", "<strength 2>", "<strength 3>"],
  "weaknesses": ["<weakness 1>", "<weakness 2>"],
  "suggestions": ["<actionable suggestion 1>", "<actionable suggestion 2>", "<actionable suggestion 3>"]
}

Resume Text:
${resumeText.substring(0, 4000)}`;

  try {
    const result = await genModel.generateContent(prompt);
    const content = result.response.text();
    let jsonResponse;
    try {
      // Better regex to handle potential leading/trailing text or markdown blocks
      const jsonMatch = content.match(/\{[\s\S]*\}/);
      if (!jsonMatch) {
         throw new Error('AI response did not contain a valid JSON object.');
      }
      jsonResponse = JSON.parse(jsonMatch[0]);
    } catch (e) {
      console.error('JSON Parse Error. Content was:', content);
      throw new Error(`AI response parsing failed: ${e.message}`);
    }

    const isDbConnected = global.isDbConnected;
    let history;

    const historyData = {
      userId: req.user.id,
      resumeName: resumeName || 'Untitled Resume',
      jobTitle: jobRole,
      score: jsonResponse.score || 0,
      matchPercentage: jsonResponse.score || 0,
      summary: jsonResponse.summary || '',
      strengths: jsonResponse.strengths || [],
      weaknesses: jsonResponse.weaknesses || [],
      suggestions: jsonResponse.suggestions || [],
    };

    if (isDbConnected) {
      history = new ResumeHistory(historyData);
      await history.save();
      await User.findByIdAndUpdate(req.user.id, { $inc: { totalAnalyses: 1 } });
    } else {
      history = MockDb.createHistory(historyData);
      MockDb.updateUserStats(req.user.id);
    }

    res.json({ ...jsonResponse, historyId: history._id });
  } catch (error) {
    const msg = error.response?.data?.error?.message || error.message;
    console.error('Analysis Error:', msg);
    res.status(500).json({ error: 'Failed to analyze resume', details: msg });
  }
});

// GET /user/history (protected)
router.get('/history', authMiddleware, async (req, res) => {
  try {
    const isDbConnected = global.isDbConnected;
    let history;
    if (isDbConnected) {
      history = await ResumeHistory.find({ userId: req.user.id })
        .sort({ createdAt: -1 })
        .limit(50)
        .select('-__v');
    } else {
      history = MockDb.findHistoryByUserId(req.user.id);
    }
    res.json(history);
  } catch (err) {
    console.error('History error:', err.message);
    res.status(500).json({ error: 'Failed to fetch history.' });
  }
});

// GET /user/profile (protected)
router.get('/profile', authMiddleware, async (req, res) => {
  try {
    const isDbConnected = global.isDbConnected;
    let user;
    let totalAnalyses;
    let avgScore;

    if (isDbConnected) {
      user = await User.findById(req.user.id).select('-passwordHash -__v');
      totalAnalyses = await ResumeHistory.countDocuments({ userId: req.user.id });
      const scores = await ResumeHistory.find({ userId: req.user.id }).select('score');
      avgScore = scores.length > 0 ? Math.round(scores.reduce((sum, r) => sum + r.score, 0) / scores.length) : 0;
      user = user.toObject();
    } else {
      user = MockDb.findUserById(req.user.id);
      const history = MockDb.findHistoryByUserId(req.user.id);
      totalAnalyses = history.length;
      avgScore = totalAnalyses > 0 ? Math.round(history.reduce((sum, r) => sum + r.score, 0) / totalAnalyses) : 0;
    }

    res.json({ ...user, totalAnalyses, avgScore });
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch profile.' });
  }
});

module.exports = router;
