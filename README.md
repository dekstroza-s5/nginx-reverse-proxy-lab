# NGINX Reverse Proxy Lab

A local reverse proxy and load-balancing lab with two backend replicas.

Features include upstream keepalive, passive health handling, request IDs, rate limiting, timeouts, security headers and structured access logs.

```bash
docker compose up --build
curl -i http://localhost:8080/
curl -i http://localhost:8080/health
```
