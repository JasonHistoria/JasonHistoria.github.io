#!/usr/bin/env bash
# Local preview -> http://localhost:4000
#
# Ruby comes from a conda env rather than the system, because the system Ruby on
# this machine is 3.0.2 (too old for bundler 4.x) and has no dev headers. Docker
# would also work, but the current user is not in the `docker` group.
#
# One-time setup, if the env is missing:
#   mamba create -n jekyll -c conda-forge -y ruby=3.3 compilers make pkg-config nodejs imagemagick
#   conda activate jekyll && gem install --no-document bundler -v '~> 4.0'
#   bundle config set --local path vendor/bundle && bundle install
set -euo pipefail
cd "$(dirname "$0")"
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate jekyll
exec bundle exec jekyll serve --livereload "$@"
