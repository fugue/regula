#!/usr/bin/env bash

set -o errexit
set -o nounset

scripts_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
project_root="${scripts_dir}/../.."

if [[ ! -v DOCS_S3_BUCKET ]]; then
    echo "Required variable DOCS_S3_BUCKET not set"
    exit 1
fi

if [[ ! -v DOCS_CF_DISTRIBUTION ]]; then
    echo "Required variable DOCS_CF_DISTRIBUTION not set"
    exit 1
fi

# Make sure we're in the right directory
cd "${project_root}"

# install python reqs
pip install -r docs/requirements.txt
pip install awscli==1.19.95

# configure awscli if we're in CI
if [[ -v CI && ${CI} == "true" ]]; then
    # using a non-default profile here to avoid clobbering the
    # default profile during development.
    ci_profile="docs-ci"

    aws configure --profile ${ci_profile} \
        set aws_access_key_id "${DOCS_ACCESS_KEY_ID}"
    aws configure --profile ${ci_profile} \
        set aws_secret_access_key "${DOCS_SECRET_ACCESS_KEY}"
    export AWS_PROFILE="${ci_profile}"
    export AWS_DEFAULT_REGION="us-east-1"
fi

# build
mkdocs build

# deploy
aws s3 sync ./site/ s3://${DOCS_S3_BUCKET}/ \
    --only-show-errors \
    --exclude "assets/*" \
    --exclude "img/*" \
    --cache-control "public, max-age=60" \
    --delete
aws s3 sync ./site/ s3://${DOCS_S3_BUCKET}/ \
    --only-show-errors \
    --exclude "*" \
    --include "assets/*" \
    --include "img/*" \
    --cache-control "public, max-age=86400" \
    --delete
aws cloudfront create-invalidation \
    --distribution-id ${DOCS_CF_DISTRIBUTION} \
    --paths "/*"
