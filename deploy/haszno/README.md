# OpenViking — Haszno deploy

Fork of [volcengine/OpenViking](https://github.com/volcengine/OpenViking) (AGPL-3.0) as used by
[Haszno](https://haszno.com). The only changes are in this folder:

- `Dockerfile` — the pinned upstream image (v0.5.5) plus `llama-cpp-python`, so embeddings run locally
  (`bge-small-zh-v1.5`, 512 dim) without a paid embedding API.
- `ov.conf.template` + `haszno-entrypoint.sh` — trusted auth mode (the Haszno API is the only client and
  sends `X-OpenViking-Account` / `X-OpenViking-User` with the root key), Claude Haiku via LiteLLM for
  summaries and memory extraction, session auto-commit on. Secrets come from the environment only.
- `docker-compose.yml` — Coolify service with a persistent volume and no public port.

## Run

```bash
OV_ROOT_API_KEY=$(openssl rand -hex 32) ANTHROPIC_API_KEY=… docker compose up -d --build
```

Without `ANTHROPIC_API_KEY`, search still works, but there are no L0/L1 summaries and no automatic memory
extraction from sessions.

Then, from the Haszno repo: `VIKING_URL=… VIKING_ROOT_KEY=… pnpm --filter api viking:ingest --setup`
(creates the `haszno` account, enables ACL, and loads the public docs read-only).

**Never expose this service publicly:** in trusted mode the root key plus identity headers grant any identity.
See `docs/openviking.md` in the Haszno repo for the tenancy rules.
