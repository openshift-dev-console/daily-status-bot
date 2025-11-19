set -e

authorization="Authorization: Bearer "$1

echo "Generating Status Report"

head="\nRHDH UI Sprint Status:"

echo "Fetching RHDH UI stories"

rhdh_ui_stories="\n*UI Stories*"

# Stories Done
rhdh_ui_stories+="\n1. <https://issues.redhat.com/issues/?filter=12483583 | Stories Done: > $(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483583' -H "Accept: application/json" | jq '.total')"

# Stories in Review
rhdh_ui_stories+="\n2. <https://issues.redhat.com/issues/?filter=12483584 | Stories In Review: > $(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483584' -H "Accept: application/json" | jq '.total')"

# Unassigned Stories
rhdh_ui_stories+="\n3. <https://issues.redhat.com/issues/?filter=12483586 | Unassigned Stories: > $(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483586' -H "Accept: application/json" | jq '.total')"

# Unpointed Stories
rhdh_ui_stories+="\n4. <https://issues.redhat.com/issues/?filter=12483587 | Unpointed Stories: > $(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483587' -H "Accept: application/json" | jq '.total')"

echo "Fetching RHDH bugs"

rhdh_bugs="\n*Bugs:*"

# RHDHBUGS stories In Review
rhdhbugs_review=$(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483589' -H "Accept: application/json" | jq '.total')
rhdh_bugs+="\n1. <https://issues.redhat.com/issues/?filter=12483589 | RHDHBUGS stories In Review: > $rhdhbugs_review"

# RHDHSUPP stories In Review
rhdhsupp_review=$(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483590' -H "Accept: application/json" | jq '.total')
rhdh_bugs+="\n2. <https://issues.redhat.com/issues/?filter=12483590 | RHDHSUPP stories In Review: > $rhdhsupp_review"

# Unassigned RHDHBUGS stories
rhdhbugs_unassigned=$(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483592' -H "Accept: application/json" | jq '.total')
rhdh_bugs+="\n3. <https://issues.redhat.com/issues/?filter=12483592 | Unassigned RHDHBUGS stories: > $rhdhbugs_unassigned"

# Unassigned RHDHSUPP stories
rhdhsupp_unassigned=$(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483591' -H "Accept: application/json" | jq '.total')
rhdh_bugs+="\n4. <https://issues.redhat.com/issues/?filter=12483591 | Unassigned RHDHSUPP stories: > $rhdhsupp_unassigned"

# Open Bug count
open_bugs=$(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483593' -H "Accept: application/json" | jq '.total')
rhdh_bugs+="\n5. <https://issues.redhat.com/issues/?filter=12483593 | Open Bug count: > $open_bugs"



echo "Fetching Github data"

# Base query parameters for rhdh-ui team
# Repos: redhat-developer/rhdh, redhat-developer/rhdh-plugins, backstage/backstage, backstage/community-plugins
# Authors: ciiay, debsmita1, its-mitesh-kumar, christoph-jerolimov, jrichter1, invincibleJai, rohitkrai03, karthikjeeyar, sanketpathak, divyanshiGupta, teknaS47, Lucifergene, lokanandaprabhu, HusneShabbir, Eswaraiahsapram
base_repos="repo%3Aredhat-developer%2Frhdh+repo%3Aredhat-developer%2Frhdh-plugins+repo%3Abackstage%2Fbackstage+repo%3Abackstage%2Fcommunity-plugins"
base_authors="author%3Aciiay+author%3Adebsmita1+author%3Aits-mitesh-kumar+author%3Achristoph-jerolimov+author%3Ajrichter1+author%3AinvincibleJai+author%3Arohitkrai03+author%3Akarthikjeeyar+author%3Asanketpathak+author%3AdivyanshiGupta+author%3AteknaS47+author%3ALucifergene+author%3Alokanandaprabhu+author%3AHusneShabbir+author%3AEswaraiahsapram"
base_params="$base_repos+-draft%3Atrue+-label%3Ado-not-merge%2Fwork-in-progress+$base_authors+state%3Aopen"

# PRs Opened for more than 3 days
three_days_ago=$(date -v-3d +%Y-%m-%d 2>/dev/null || date -d "3 days ago" +%Y-%m-%d)
github_data="\n*Github status*"
github_data+="\n1. <https://github.com/search?q=$base_params+created%3A<$three_days_ago&type=pullrequests | PRs Opened for more than 3 days: > $(curl -s "https://api.github.com/search/issues?q=$base_params+created%3A<$three_days_ago&type=pullrequests" -H "Accept: application/json" | jq '.total_count')"

# PRs with No LGTM and without Approval (on same line)
no_lgtm_count=$(curl -s "https://api.github.com/search/issues?q=$base_params+-label%3Algtm&type=pullrequests" -H "Accept: application/json" | jq '.total_count')
no_approval_count=$(curl -s "https://api.github.com/search/issues?q=$base_params+-label%3Aapproved&type=pullrequests" -H "Accept: application/json" | jq '.total_count')
github_data+="\n2. <https://github.com/search?q=$base_params+-label%3Algtm&type=pullrequests | PRs with No LGTM: > $no_lgtm_count <https://github.com/search?q=$base_params+-label%3Aapproved&type=pullrequests | PRs without Approval: > $no_approval_count"

# PRs waiting on cherry-pick-approved
cherrypick_params="$base_repos+-label%3Acherry-pick-approved+label%3Abackport-risk-assessed+label%3Aapproved+label%3Algtm+$base_authors+state%3Aopen"
cherrypick_count=$(curl -s "https://api.github.com/search/issues?q=$cherrypick_params&type=pullrequests" -H "Accept: application/json" | jq '.total_count')
github_data+="\n3. <https://github.com/search?q=$cherrypick_params&type=pullrequests | PRs waiting on cherry-pick-approved: > $cherrypick_count"

# PRs without LGTM but has Approval
no_lgtm_approved_count=$(curl -s "https://api.github.com/search/issues?q=$base_params+-label%3Algtm+label%3Aapproved&type=pullrequests" -H "Accept: application/json" | jq '.total_count')
github_data+="\n4. <https://github.com/search?q=$base_params+-label%3Algtm+label%3Aapproved&type=pullrequests | PRs without LGTM but has Approval: > $no_lgtm_approved_count"

# Open PRs raised by rhdh-ui team
open_prs_count=$(curl -s "https://api.github.com/search/issues?q=$base_params&type=pullrequests" -H "Accept: application/json" | jq '.total_count')
github_data+="\n5. <https://github.com/search?q=$base_params&type=pullrequests | Open PRs raised by rhdh-ui team: > $open_prs_count"


echo "Posting on #rhdh-ux-ui slack channel"

# Build JSON using jq to ensure proper escaping and valid structure
data=$(jq -n \
  --arg head "$head" \
  --arg stories "$rhdh_ui_stories" \
  --arg bugs "$rhdh_bugs" \
  --arg github "$github_data" \
  '{
    text: "Status report",
    blocks: [
      {
        type: "header",
        text: {
          type: "plain_text",
          text: $head
        }
      },
      {
        type: "section",
        fields: [
          {
            type: "mrkdwn",
            text: "*Current sprint status*"
          }
        ]
      },
      {
        type: "divider"
      },
      {
        type: "section",
        fields: [
          {
            type: "mrkdwn",
            text: $stories
          },
          {
            type: "mrkdwn",
            text: $bugs
          }
        ]
      },
      {
        type: "divider"
      },
      {
        type: "section",
        fields: [
          {
            type: "mrkdwn",
            text: "*Github status*"
          }
        ]
      },
      {
        type: "section",
        fields: [
          {
            type: "mrkdwn",
            text: $github
          }
        ]
      },
      {
        type: "divider"
      }
    ]
  }')

# Validate JSON before sending
if ! echo "$data" | jq empty 2>/dev/null; then
    echo "ERROR: Invalid JSON generated!"
    echo "$data" | jq . 2>&1 || echo "$data"
    exit 1
fi

# Check for empty or null values that might cause issues
if echo "$data" | jq -e '.blocks[] | select(.type == "section") | .fields[]? | select(.text == null or .text == "")' > /dev/null 2>&1; then
    echo "WARNING: Found empty text fields in blocks"
fi

# Save payload for debugging (only in CI, won't affect production)
if [ -n "$GITHUB_ACTIONS" ] || [ -n "$CI" ]; then
    echo "$data" > /tmp/slack_payload.json 2>/dev/null || true
    echo "Debug: Payload saved to /tmp/slack_payload.json"
    echo "Debug: Payload size: $(echo "$data" | wc -c) bytes"
    echo "Debug: Number of blocks: $(echo "$data" | jq '.blocks | length')"
fi

# Send to Slack and capture response
response=$(curl -s -w "\n%{http_code}" -X POST -H "Content-type:application/json" --data "$data" $2)
http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | sed '$d')

# Check response
if [ "$http_code" != "200" ]; then
    echo "ERROR: Slack API returned HTTP $http_code"
    echo "Response body: $body"
    if [ -n "$GITHUB_ACTIONS" ] || [ -n "$CI" ]; then
        echo "Debug: Full payload saved to /tmp/slack_payload.json"
        echo "Debug: Payload preview (first 500 chars):"
        echo "$data" | head -c 500
        echo ""
    fi
    exit 1
fi

# Check for error in response body
if echo "$body" | jq -e '.ok == false' > /dev/null 2>&1; then
    error=$(echo "$body" | jq -r '.error // "unknown error"')
    echo "ERROR: Slack API error: $error"
    if echo "$body" | jq -e '.response_metadata' > /dev/null 2>&1; then
        echo "Response metadata:"
        echo "$body" | jq '.response_metadata'
    fi
    exit 1
fi


echo "\nDone"
