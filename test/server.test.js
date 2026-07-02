const test = require('node:test');
const assert = require('node:assert/strict');
const { handler } = require('../src/server');

function createResponse() {
  return {
    statusCode: 0,
    headers: {},
    body: '',
    writeHead(statusCode, headers) {
      this.statusCode = statusCode;
      this.headers = headers;
    },
    end(chunk = '') {
      this.body += chunk;
    },
  };
}

function runRequest({ method, path }) {
  const req = {
    method,
    url: path,
    headers: {
      host: '127.0.0.1',
    },
  };
  const res = createResponse();

  handler(req, res);

  return res;
}

test('GET /health returns 200 and ok', () => {
  const res = runRequest({ method: 'GET', path: '/health' });

  assert.equal(res.statusCode, 200);
  assert.equal(res.body, JSON.stringify({ status: 'ok' }));
  assert.equal(res.headers['content-type'], 'application/json; charset=utf-8');
});

test('unknown routes return 404', () => {
  const res = runRequest({ method: 'GET', path: '/nope' });

  assert.equal(res.statusCode, 404);
  assert.equal(res.body, JSON.stringify({ error: 'not found' }));
  assert.equal(res.headers['content-type'], 'application/json; charset=utf-8');
});
