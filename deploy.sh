#!/usr/bin/env bash
#
if [[ -z "$1" ]]; then
    echo "missing cloudfront distribution id"
    exit 1
fi

rm -rf public
hugo

aws s3 sync public/ s3://blockscope.dev/prod/public
--delete
--exclude "*"  # exclude followed by include is required to "filter" the filetypes
--include "*.html"


# sync the non-HTML files separately and add cache headers
aws s3 sync public/ s3://blockscope.dev/prod/public
--delete
--exclude "*"  # exclude followed by include is required to "filter" the filetypes
--include "*.js"
--include "*.css"
--include "*.png"
--include "*.jpg"
--include "*.svg"
--cache-control "max-age=604800" # set cache-control for non-HTML files

# The CloudFront cache must be invalidated for the changes to be fully deployed.
aws cloudfront create-invalidation --distribution-id $1 --paths "/*"
