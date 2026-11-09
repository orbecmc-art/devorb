#!/usr/bin/env bash
# Scenario wrapper: builds the same minimal DevOrb copy as the main case.
set -eu
EVOLVING_SCENARIO=source-failed
export EVOLVING_SCENARIO
exec bash "$(cd "$(dirname "$0")" && pwd)/../evolving-rehearsal/scaffold.sh"
