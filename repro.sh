#!/bin/sh
set -u
export EXACT_FEEDBACK=0
cd "$(dirname "$0")"; mkdir -p .exact
bun exact.mjs test web >/dev/null 2>&1 || { echo "FAIL setup: app.test.contract should pass"; exit 2; }
warns() {
  bun exact.mjs contract build "$1" --json >.exact/build.json 2>&1 || { echo "FAIL setup: $1 does not compile"; cat .exact/build.json; exit 2; }
  grep -q '"type-performance-now-persisted"' .exact/build.json
}
sed 's/banked + performanceNow() - start/banked + (performanceNow() - start)/' app.contract >.exact/control.contract
if warns .exact/control.contract; then echo "FAIL setup: the control should be clean"; exit 2; fi
if warns app.contract; then
  echo "BUG: type-performance-now-persisted fires on a duration; the control does not"; exit 1
fi
echo "FIXED: no warning on the banked duration"
