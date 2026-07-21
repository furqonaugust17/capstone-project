'use strict';
const gameSessionService = require('./gamesession.service');
const { createSessionSchema } = require('./gamesession.validation');
const { successResponse } = require('../../utils/response');

const index = async (req, res) => {
  const userId = req.user.userId;
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 10;
  const result = await gameSessionService.getMySessions(userId, page, limit);
  res.status(200).json(successResponse(result, 200, 'Game sessions fetched successfully'));
};

const getAll = async (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 10;
  const userId = req.query.userId || undefined;
  
  const result = await gameSessionService.getAllSessions(page, limit, userId);
  res.status(200).json(successResponse(result, 200, 'All game sessions fetched successfully'));
};

const show = async (req, res) => {
  const user = req.user;
  const session = await gameSessionService.getSessionById(req.params.id, user);
  res.status(200).json(successResponse(session, 200, 'Game session fetched successfully'));
};

const store = async (req, res) => {
  const userId = req.user.userId;
  const data = createSessionSchema.parse(req.body);
  const session = await gameSessionService.createSession(userId, data, req.file);
  res.status(201).json(successResponse(session, 201, 'Game session created successfully'));
};

const exportCSV = async (req, res) => {
  try {
    const userId = req.query.userId || undefined;
    const result = await gameSessionService.getSessionsForExport(userId);
    
    if (!result || result.length === 0) {
      return res.status(404).json(successResponse(null, 404, 'No game sessions found to export'));
    }

    const escapeCSV = (val) => {
      if (val === null || val === undefined) return '';
      const str = String(val);
      if (str.includes(',') || str.includes('"') || str.includes('\n')) {
        return `"${str.replace(/"/g, '""')}"`;
      }
      return str;
    };

    const fields = [
      'id', 'username', 'email', 'animal_name', 'model_name', 'model_version', 
      'predictionLabel', 'confidenceScore', 'gameScore', 'focusScore', 
      'drawingDuration', 'startedAt', 'createdAt'
    ];

    const csvRows = [];
    csvRows.push(fields.join(','));

    for (const session of result) {
      const row = [
        session.id,
        session.user?.username,
        session.user?.email,
        session.animal?.name,
        session.model?.name,
        session.model?.version,
        session.predictionLabel,
        session.confidenceScore,
        session.gameScore,
        session.focusScore,
        session.drawingDuration,
        session.startedAt ? session.startedAt.toISOString() : '',
        session.createdAt ? session.createdAt.toISOString() : ''
      ].map(escapeCSV);
      csvRows.push(row.join(','));
    }

    const csvString = csvRows.join('\n');
    
    res.setHeader('Content-Type', 'text/csv');
    res.setHeader('Content-Disposition', 'attachment; filename=game_sessions.csv');
    res.status(200).send(csvString);
  } catch (error) {
    res.status(500).json({ success: false, message: 'Failed to export CSV', error: error.message });
  }
};

module.exports = {
  index,
  getAll,
  show,
  store,
  exportCSV,
};
