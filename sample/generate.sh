#!/usr/bin/env bash
# Regenerate the sample/ showcase files with random fake data.
# A stub `ssh` replays input.json, so the real ../fleet renders table.txt
# and output.json end to end. Seeded RNG: output is stable.
set -euo pipefail
cd "$(dirname "$0")"

python3 - <<'EOF' > input.json
import json, random
from datetime import datetime, timedelta, timezone
random.seed(20260909)
names = ['web-01', 'db-01', 'nas-02', 'pi-04', 'laptop-02']
base = datetime(2026, 9, 9, 12, 0, 0, tzinfo=timezone.utc)
rows = []
for i, name in enumerate(names):
    stats = {
        'cpu': round(random.uniform(1, 60), 2),
        'm': round(random.uniform(5, 80), 2),
        'mu': round(random.uniform(0.5, 16), 2),
        'dp': round(random.uniform(5, 90), 2),
        'du': round(random.uniform(1, 200), 2),
        'la': [round(random.uniform(0, 4), 2) for _ in range(3)],
    }
    updated = (base - timedelta(seconds=random.randint(5, 120))).strftime('%Y-%m-%d %H:%M:%S.') + '%03dZ' % random.randint(0, 999)
    rows.append({'name': name, 'status': 'up', 'host': '192.0.2.%d' % (10 + i),
                 'updated': updated, 'stats': json.dumps(stats)})
# one host that never reported stats
rows.append({'name': 'pi-05', 'status': 'paused', 'host': '192.0.2.16',
             'updated': None, 'stats': None})
print(json.dumps(rows, indent=1))
EOF

BIN="$(mktemp -d)"
trap 'rm -rf "$BIN"' EXIT
printf '#!/bin/sh\ncat "$SAMPLE_INPUT"\n' > "$BIN/ssh"
chmod +x "$BIN/ssh"

SAMPLE_INPUT="$PWD/input.json" PATH="$BIN:$PATH" ../fleet > table.txt
SAMPLE_INPUT="$PWD/input.json" PATH="$BIN:$PATH" ../fleet --json > output.json
echo "wrote input.json table.txt output.json"
