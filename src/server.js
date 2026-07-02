const http = require('node:http');

const port = Number.parseInt(process.env.PORT || '3000', 10);
const host = process.env.HOST || '0.0.0.0';

function handler(req, res) {
  const pathname = new URL(req.url, `http://${req.headers.host || 'localhost'}`).pathname;

  if (req.method === 'GET' && pathname === '/health') {
    res.writeHead(200, { 'content-type': 'application/json; charset=utf-8' });
    res.end(JSON.stringify({ status: 'ok' }));
    return;
  }

  res.writeHead(404, { 'content-type': 'application/json; charset=utf-8' });
  res.end(JSON.stringify({ error: 'not found' }));
}

if (require.main === module) {
  http.createServer(handler).listen(port, host, () => {
    console.log(`Server listening on http://${host}:${port}`);
  });
}

module.exports = { handler };
