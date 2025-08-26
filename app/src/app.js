const express = require('express')

const app = express()

app.get('/health', (_req, res) => {
  res.status(200).json({ status: 'ok' })
})

module.exports = app
