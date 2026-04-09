const mongoose = require('mongoose');

const resumeHistorySchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    resumeName: { type: String, default: 'Untitled' },
    jobTitle: { type: String, required: true },
    score: { type: Number, required: true },
    matchPercentage: { type: Number, default: 0 },
    summary: { type: String, default: '' },
    strengths: [{ type: String }],
    weaknesses: [{ type: String }],
    suggestions: [{ type: String }],
  },
  { timestamps: true }
);

module.exports = mongoose.model('ResumeHistory', resumeHistorySchema);
