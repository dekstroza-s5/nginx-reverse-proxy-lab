# NGINX Reverse Proxy Lab

Runnable reverse proxy and load-balancing lab with two backend replicas.

## Architecture

```text
client :8080 -> NGINX -> least-connections upstream
                         ├── backend-a:8080
                         └── backend-b:8080
```

The proxy adds request IDs, uses upstream keepalive, applies passive failure handling, rate limiting, timeouts, retry rules, security headers and JSON access logs.

## Start and verify

```bash
docker compose config
docker compose up -d
docker compose ps
bash scripts/smoke-test.sh
```

Inspect balancing:

```bash
for i in $(seq 1 10); do curl -s http://localhost:8080/ | grep -E 'INSTANCE|hostname'; done
docker compose logs -f nginx
```

## Failure test

```bash
docker compose stop backend-a
for i in $(seq 1 5); do curl --fail http://localhost:8080/; done
docker compose start backend-a
```

Requests should continue through the second backend. This is passive failure handling, not an external active health checker.

## Rate-limit test

```bash
seq 1 100 | xargs -P30 -I{} curl -s -o /dev/null -w '%{http_code}\n' http://localhost:8080/
```

A burst beyond the configured zone should produce some 503 responses. Tune rate and burst based on real traffic rather than copying the lab values.

## Troubleshooting

- 502: verify backend container state and upstream port;
- 504: inspect backend latency and proxy timeouts;
- no balancing: confirm both upstreams are healthy;
- all requests limited: inspect client address visibility behind another proxy;
- missing request ID: check the JSON log format and forwarded headers.

Before internet exposure, add TLS, trusted proxy configuration, restricted management access and centralized log shipping.
