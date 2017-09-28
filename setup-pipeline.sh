#!/bin/bash
set -eo pipefail
org="$1"
repo="$2"
echo "~~~ Creating pipeline"
curl --fail -s -H "Authorization: Bearer $BUILDKITE_TOKEN" -XPOST \
	"https://api.buildkite.com/v2/organizations/$org/pipelines" \
	-d @<(sed -e "s/\$org/$org/g" -e "s/\$repo/$repo/g" pipeline.json)

# YEAS, THIS IS CRAP BUT YEAH WATF
curl --fail -s -H "Authorization: Bearer $BUILDKITE_TOKEN" -XPATCH \
	"https://api.buildkite.com/v2/organizations/{org.slug}/pipelines/{slug}" \
	-d @<(sed -e "s/\$org/$org/g" -e "s/\$repo/$repo/g" pipeline.json)

echo "~~~ Setting up webhooks"
url="$(
	curl -s -H "Authorization: Bearer $BUILDKITE_TOKEN" \
		"https://api.buildkite.com/v2/organizations/$org/pipelines/$repo" |
		jq -r '.provider.webhook_url'
)"
curl --fail -s -H "Authorization: token $GITHUB_TOKEN" -XPOST \
	"https://api.github.com/repos/$org/$repo/hooks" \
	-d @<(sed "s#\$url#$url#" webhook.json)
