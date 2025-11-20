set -euo pipefail

authorization="Authorization: Bearer "$1

echo "Generating Status Report"

head="RHDH UI Sprint Status:"

echo "Fetching RHDH UI stories"

rhdh_ui_stories="*UI Stories:*"

rhdh_ui_stories+=$'\n1. <https://issues.redhat.com/issues/?filter=12483583|Stories Done:> '$(curl -fSs -H "$authorization" 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483583' -H "Accept: application/json" | jq '.total')
rhdh_ui_stories+=$'\n2. <https://issues.redhat.com/issues/?filter=12483584|Stories In Review:> '$(curl -fSs -H "$authorization" 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483584' -H "Accept: application/json" | jq '.total')
rhdh_ui_stories+=$'\n3. <https://issues.redhat.com/issues/?filter=12483586|Unassigned Stories:> '$(curl -fSs -H "$authorization" 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483586' -H "Accept: application/json" | jq '.total')
rhdh_ui_stories+=$'\n4. <https://issues.redhat.com/issues/?filter=12483587|Unpointed Stories:> '$(curl -fSs -H "$authorization" 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483587' -H "Accept: application/json" | jq '.total')

echo "Fetching RHDH bugs"

rhdh_bugs="*Bugs:*"

# RHDHBUGS stories In Review
rhdhbugs_review=$(curl -fSs -H "$authorization" 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483589' -H "Accept: application/json"|jq '.total')
rhdh_bugs+=$'\n1. <https://issues.redhat.com/issues/?filter=12483589|RHDHBUGS stories In Review:> '"$rhdhbugs_review"

# RHDHSUPP stories In Review
rhdhsupp_review=$(curl -fSs -H "$authorization" 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483590' -H "Accept: application/json"|jq '.total')
rhdh_bugs+=$'\n2. <https://issues.redhat.com/issues/?filter=12483590|RHDHSUPP stories In Review:> '"$rhdhsupp_review"

# Unassigned RHDHBUGS stories
rhdhbugs_unassigned=$(curl -fSs -H "$authorization" 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483592' -H "Accept: application/json"|jq '.total')
rhdh_bugs+=$'\n3. <https://issues.redhat.com/issues/?filter=12483592|Unassigned RHDHBUGS stories:> '"$rhdhbugs_unassigned"

# Unassigned RHDHSUPP stories
rhdhsupp_unassigned=$(curl -fSs -H "$authorization" 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483591' -H "Accept: application/json"|jq '.total')
rhdh_bugs+=$'\n4. <https://issues.redhat.com/issues/?filter=12483591|Unassigned RHDHSUPP stories:> '"$rhdhsupp_unassigned"

# Open Bug count
open_bugs=$(curl -fSs -H "$authorization" 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483593' -H "Accept: application/json"|jq '.total')
rhdh_bugs+=$'\n5. <https://issues.redhat.com/issues/?filter=12483593|Open Bug count:> '"$open_bugs"



echo "Fetching Github data"

# Base query parameters for rhdh-ui team
# Repos: redhat-developer/rhdh, redhat-developer/rhdh-plugins, backstage/backstage, backstage/community-plugins
# Authors: ciiay, debsmita1, its-mitesh-kumar, christoph-jerolimov, jrichter1, invincibleJai, rohitkrai03, karthikjeeyar, sanketpathak, divyanshiGupta, teknaS47, Lucifergene, lokanandaprabhu, HusneShabbir, Eswaraiahsapram
base_repos="repo%3Aredhat-developer%2Frhdh+repo%3Aredhat-developer%2Frhdh-plugins+repo%3Abackstage%2Fbackstage+repo%3Abackstage%2Fcommunity-plugins"
base_authors="author%3Aciiay+author%3Adebsmita1+author%3Aits-mitesh-kumar+author%3Achristoph-jerolimov+author%3Ajrichter1+author%3AinvincibleJai+author%3Arohitkrai03+author%3Akarthikjeeyar+author%3Asanketpathak+author%3AdivyanshiGupta+author%3AteknaS47+author%3ALucifergene+author%3Alokanandaprabhu+author%3AHusneShabbir+author%3AEswaraiahsapram"
base_params="$base_repos+-draft%3Atrue+-label%3Ado-not-merge%2Fwork-in-progress+$base_authors+state%3Aopen"

# PRs Opened for more than 3 days
three_days_ago=$(date -v-3d +%Y-%m-%d 2>/dev/null || date -d "3 days ago" +%Y-%m-%d)
count_gt3=$(curl -fSs -S "https://api.github.com/search/issues?q=$base_params+created%3A<$three_days_ago&type=pullrequests" -H "Accept: application/json"|jq '.total_count')
no_lgtm_count=$(curl -fSs -S "https://api.github.com/search/issues?q=$base_params+-label%3Algtm&type=pullrequests" -H "Accept: application/json"|jq '.total_count')
no_approval_count=$(curl -fSs -S "https://api.github.com/search/issues?q=$base_params+-label%3Aapproved&type=pullrequests" -H "Accept: application/json"|jq '.total_count')
cherrypick_params="$base_repos+-label%3Acherry-pick-approved+label%3Abackport-risk-assessed+label%3Aapproved+label%3Algtm+$base_authors+state%3Aopen"
cherrypick_count=$(curl -fSs -S "https://api.github.com/search/issues?q=$cherrypick_params&type=pullrequests" -H "Accept: application/json"|jq '.total_count')
no_lgtm_approved_count=$(curl -fSs -S "https://api.github.com/search/issues?q=$base_params+-label%3Algtm+label%3Aapproved&type=pullrequests" -H "Accept: application/json"|jq '.total_count')
open_prs_count=$(curl -fSs -S "https://api.github.com/search/issues?q=$base_params&type=pullrequests" -H "Accept: application/json"|jq '.total_count')

gh1="1. <https://github.com/search?q=$base_params+created%3A%3C$three_days_ago&type=pullrequests|PRs >3 days:> $count_gt3"
gh2="2. <https://github.com/search?q=$base_params+-label%3Algtm&type=pullrequests|No LGTM:> $no_lgtm_count"
gh3="3. <https://github.com/search?q=$base_params+-label%3Aapproved&type=pullrequests|No Approval:> $no_approval_count"
gh4="4. <https://github.com/search?q=$base_params+-label%3Algtm+label%3Aapproved&type=pullrequests|Approved, no LGTM:> $no_lgtm_approved_count"
gh5="5. <https://github.com/search?q=$cherrypick_params&type=pullrequests|Waiting cherry-pick-approved:> $cherrypick_count"
gh6="6. <https://github.com/search?q=$base_params&type=pullrequests|Open PRs (team):> $open_prs_count"

echo "Posting on #rhdh-ux-ui slack channel"

head="RHDH UI Sprint Status:"

data=$(jq -n \
  --arg head "$head" \
  --arg stories "$rhdh_ui_stories" \
  --arg bugs "$rhdh_bugs" \
  --arg gh1 "$gh1" --arg gh2 "$gh2" --arg gh3 "$gh3" \
  --arg gh4 "$gh4" --arg gh5 "$gh5" --arg gh6 "$gh6" '
{
  text: "Status report",
  blocks: [
    { type: "header", text: { type: "plain_text", text: $head } },
    { type: "section", fields: [ { type: "mrkdwn", text: "*Current sprint status*" } ] },
    { type: "divider" },
    { type: "section", fields: [ { type: "mrkdwn", text: $stories }, { type: "mrkdwn", text: $bugs } ] },
    { type: "divider" },
    { type: "section", fields: [ { type: "mrkdwn", text: "*Github status*" } ] },
    { type: "section", fields: [
        { type: "mrkdwn", text: $gh1 }, { type: "mrkdwn", text: $gh2 },
        { type: "mrkdwn", text: $gh3 }, { type: "mrkdwn", text: $gh4 },
        { type: "mrkdwn", text: $gh5 }, { type: "mrkdwn", text: $gh6 }
    ]},
    { type: "divider" }
  ]
}')

# Save payload for debugging in CI
if [ -n "$GITHUB_ACTIONS" ] || [ -n "$CI" ]; then
    echo "$data" > /tmp/slack_payload.json 2>/dev/null || true
    echo "Debug: Payload saved to /tmp/slack_payload.json"
    echo "Debug: Payload size: $(echo "$data" | wc -c) bytes"
    echo "Debug: Number of blocks: $(echo "$data" | jq '.blocks | length')"
    echo "Debug: First 500 chars of payload:"
    echo "$data" | head -c 500
    echo ""
fi

# --- Send to Slack ---
if [ -z "${2-}" ]; then
  echo "ERROR: Missing Slack webhook URL as second arg"
  exit 2
fi

response=$(curl -fSs -w "\n%{http_code}" \
  -X POST \
  -H "Content-type: application/json; charset=utf-8" \
  --data "$data" \
  "$2")

http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | sed '$d')

if [ "$http_code" != "200" ]; then
  echo "ERROR: Slack returned HTTP $http_code"
  echo "Body: $body"
  exit 1
fi

# For incoming webhooks Slack returns plain "ok"
# For chat.postMessage it returns JSON with {"ok": true}
if echo "$body" | grep -qx "ok"; then
  echo "Posted to Slack: ok"
elif echo "$body" | jq -e '.ok == true' >/dev/null 2>&1; then
  echo "Posted to Slack: $(echo "$body" | jq -r '.ts // "ok"')"
else
  echo "WARNING: Unexpected Slack response:"
  echo "$body"
fi

echo "\nDone"