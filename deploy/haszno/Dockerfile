# Haszno build of OpenViking: the pinned upstream image + local embeddings (llama-cpp-python), so the server
# indexes and searches without a paid embedding API. Verified 2026-11-19 against v0.5.5.
FROM ghcr.io/volcengine/openviking@sha256:d0d6d5c2dad366b81d970caf420ce186723e539ffc781b80620298675ea5accc

RUN pip --python /app/.venv/bin/python3 install --no-cache-dir --only-binary=:all: \
      --extra-index-url https://abetlen.github.io/llama-cpp-python/whl/cpu \
      llama-cpp-python==0.3.36 \
 && /app/.venv/bin/python3 -c "import llama_cpp"

# The Haszno API talks to the HTTP server only; VikingBot is not used.
ENV OPENVIKING_WITH_BOT=0
COPY ov.conf.template /app/ov.conf.template
COPY haszno-entrypoint.sh /usr/local/bin/haszno-entrypoint
RUN chmod +x /usr/local/bin/haszno-entrypoint
ENTRYPOINT ["haszno-entrypoint"]
