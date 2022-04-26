#!/bin/sh

set -euo pipefail

grep -rho "assets/images/[^\"']*" lib | sort | uniq
