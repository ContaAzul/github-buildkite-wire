#!/bin/bash
set -eo pipefail
org="$1"
repo="$2"

sed -e "s/\$org/$org/g" -e "s/\$repo/$repo/g" pipeline.json

echo "~~~ Creating pipeline"
curl --fail -i -H "Authorization: Bearer $BUILDKITE_TOKEN" \
        -H 'Content-Type: application/json' -XPOST \
	"https://api.buildkite.com/v2/organizations/$org/pipelines" \
	-d @<(sed -e "s/\$org/$org/g" -e "s/\$repo/$repo/g" pipeline.json)

echo "~~~ Setting up webhooks"
url="$(
	curl -s -H "Authorization: Bearer $BUILDKITE_TOKEN" \
		"https://api.buildkite.com/v2/organizations/$org/pipelines/$repo" |
		jq -r '.provider.webhook_url'
)"

curl --fail -iv -H "Authorization: token $GITHUB_TOKEN" -XPOST \
	"https://api.github.com/repos/$org/$repo/hooks" \
	-d @<(sed "s#\$url#$url#" webhook.json)
