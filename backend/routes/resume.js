const express = require('express');
const router = express.Router();
const axios = require('axios');
const authMiddleware = require('../middleware/auth');
const ResumeHistory = require('../models/ResumeHistory');
const User = require('../models/User');

// POST /analyze-resume (protected)
router.post('/', authMiddleware, async (req, res) => {
  const { resumeText, jobRole, resumeName } = req.body;

  if (!resumeText || !jobRole) {
    return res.status(400).json({ error: 'resumeText and jobRole are required' });
  }

  const prompt = `You are an expert ATS resume analyzer. Analyze the following resume for the job role: "${jobRole}".

Return ONLY a valid JSON object (no markdown, no backticks) with this exact structure:
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
    const response = await axios.post(
      'https://api.openai.com/v1/chat/completions',
      {
        model: 'gpt-3.5-turbo',
        messages: [
          {
            role: 'system',
            content: 'You are an ATS Expert Resume Analyzer. Respond ONLY with valid JSON, no markdown.',
          },
          { role: 'user', content: prompt },
        ],
        temperature: 0.5,
        max_tokens: 800,
      },
      {
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${process.env.OPENAI_API_KEY}`,
        },
        timeout: 30000,
      }
    );

    const content = response.data.choices[0].message.content;
    let jsonResponse;
    try {
      const cleaned = content.match(/\{[\s\S]*\}/)?.[0] || content;
      jsonResponse = JSON.parse(cleaned);
    } catch {
      throw new Error('AI returned invalid JSON. Please try again.');
    }

    // Save to DB
    const history = new ResumeHistory({
      userId: req.user.id,
      resumeName: resumeName || 'Untitled Resume',
      jobTitle: jobRole,
      score: jsonResponse.score || 0,
      matchPercentage: jsonResponse.score || 0,
      summary: jsonResponse.summary || '',
      strengths: jsonResponse.strengths || [],
      weaknesses: jsonResponse.weaknesses || [],
      suggestions: jsonResponse.suggestions || [],
    });
    await history.save();

    // Update user stats
    await User.findByIdAndUpdate(req.user.id, {
      $inc: { totalAnalyses: 1 },
    });

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
    const history = await ResumeHistory.find({ userId: req.user.id })
      .sort({ createdAt: -1 })
      .limit(50)
      .select('-__v');
    res.json(history);
  } catch (err) {
    console.error('History error:', err.message);
    res.status(500).json({ error: 'Failed to fetch history.' });
  }
});

// GET /user/profile (protected)
router.get('/profile', authMiddleware, async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select('-passwordHash -__v');
    const totalAnalyses = await ResumeHistory.countDocuments({ userId: req.user.id });
    const scores = await ResumeHistory.find({ userId: req.user.id }).select('score');
    const avgScore =
      scores.length > 0
        ? Math.round(scores.reduce((sum, r) => sum + r.score, 0) / scores.length)
        : 0;

    res.json({ ...user.toObject(), totalAnalyses, avgScore });
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch profile.' });
  }
});

module.exports = router;
