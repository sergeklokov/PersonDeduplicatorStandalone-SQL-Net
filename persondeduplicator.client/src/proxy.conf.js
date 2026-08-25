const { env } = require('process');

// Resolve the ASP.NET Core backend URL used by the dev server proxy.
// Prefer ASPNETCORE_URLS (can contain http or https), then the HTTPS port, then a sensible http fallback.
let target;
if (env.ASPNETCORE_URLS) {
  target = env.ASPNETCORE_URLS.split(';')[0];
} else if (env.ASPNETCORE_HTTPS_PORT) {
  target = `https://localhost:${env.ASPNETCORE_HTTPS_PORT}`;
} else {
  target = 'http://localhost:5146';
}

const PROXY_CONFIG = [
  {
    context: [
      "/weatherforecast",
    ],
    target,
    secure: false,
    changeOrigin: true,
    logLevel: 'info'
  }
]

module.exports = PROXY_CONFIG;
