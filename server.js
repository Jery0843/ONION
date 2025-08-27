const http = require("http");
const httpProxy = require("http-proxy");

// Change this to your Vercel deployed URL
const target = "https://0x-jerry-s-lab.vercel.app/";

const proxy = httpProxy.createProxyServer({
  target,
  changeOrigin: true,
  secure: false
});

http.createServer((req, res) => {
  proxy.web(req, res, (err) => {
    console.error("Proxy error:", err);
    res.writeHead(500);
    res.end("Something went wrong.");
  });
}).listen(80, () => {
  console.log("Reverse proxy running, forwarding traffic to Vercel:", target);
});
