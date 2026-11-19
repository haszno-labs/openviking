#!/bin/sh
# Renders ov.conf from the environment (secrets never baked into the image), then starts the stock entrypoint.
set -eu
: "${OV_ROOT_API_KEY:?OV_ROOT_API_KEY is required}"
mkdir -p /app/.openviking
python3 - <<'PY'
import json, os
conf = json.load(open('/app/ov.conf.template'))
conf['server']['root_api_key'] = os.environ['OV_ROOT_API_KEY']
key = os.environ.get('ANTHROPIC_API_KEY', '').strip()
if key:
    conf['vlm']['api_key'] = key
    conf['vlm']['model'] = os.environ.get('OV_VLM_MODEL', conf['vlm']['model'])
else:
    conf.pop('vlm')  # search still works; no summaries and no automatic memory extraction
json.dump(conf, open('/app/.openviking/ov.conf', 'w'), indent=2)
PY
exec openviking-entrypoint "$@"
