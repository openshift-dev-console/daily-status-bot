set -euo pipefail

authorization="Authorization: Bearer "$1

echo "Generating Status Report"

head="RHDH UI Sprint Status:"

echo "Fetching RHDH UI stories"

rhdh_ui_stories="\n*UI Stories*"

# Stories Done
rhdh_ui_stories+="\n1. <https://issues.redhat.com/issues/?filter=12483583|Stories Done:> $(curl -fSs -H "$authorization" 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483583' -H "Accept: application/json"|jq '.total')"

# Stories in Review
rhdh_ui_stories+="\n2. <https://issues.redhat.com/issues/?filter=12483584|Stories In Review:> $(curl -fSs -H "$authorization" 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483584' -H "Accept: application/json"|jq '.total')"

# Unassigned Stories
rhdh_ui_stories+="\n3. <https://issues.redhat.com/issues/?filter=12483586|Unassigned Stories:> $(curl -fSs -H "$authorization" 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483586' -H "Accept: application/json"|jq '.total')"

# Unpointed Stories
rhdh_ui_stories+="\n4. <https://issues.redhat.com/issues/?filter=12483587|Unpointed Stories:> $(curl -fSs -H "$authorization" 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483587' -H "Accept: application/json"|jq '.total')"

echo "Fetching RHDH bugs"

rhdh_bugs="\n*Bugs:*"

# RHDHBUGS stories In Review
rhdhbugs_review=$(curl -fSs -H "$authorization" 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483589' -H "Accept: application/json"|jq '.total')
rhdh_bugs+="\n1. <https://issues.redhat.com/issues/?filter=12483589|RHDHBUGS stories In Review:> $rhdhbugs_review"

# RHDHSUPP stories In Review
rhdhsupp_review=$(curl -fSs -H "$authorization" 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483590' -H "Accept: application/json"|jq '.total')
rhdh_bugs+="\n2. <https://issues.redhat.com/issues/?filter=12483590|RHDHSUPP stories In Review:> $rhdhsupp_review"

# Unassigned RHDHBUGS stories
rhdhbugs_unassigned=$(curl -fSs -H "$authorization" 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483592' -H "Accept: application/json"|jq '.total')
rhdh_bugs+="\n3. <https://issues.redhat.com/issues/?filter=12483592|Unassigned RHDHBUGS stories:> $rhdhbugs_unassigned"

# Unassigned RHDHSUPP stories
rhdhsupp_unassigned=$(curl -fSs -H "$authorization" 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483591' -H "Accept: application/json"|jq '.total')
rhdh_bugs+="\n4. <https://issues.redhat.com/issues/?filter=12483591|Unassigned RHDHSUPP stories:> $rhdhsupp_unassigned"

# Open Bug count
open_bugs=$(curl -fSs -H "$authorization" 'https://issues.redhat.com/rest/api/2/search?jql=filter=12483593' -H "Accept: application/json"|jq '.total')
rhdh_bugs+="\n5. <https://issues.redhat.com/issues/?filter=12483593|Open Bug count:> $open_bugs"



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

# 六条短字段（注意 <url|text> 无空格）
gh1="1. <https://github.com/search?q=$base_params+created%3A<$three_days_ago&type=pullrequests|PRs >3 days:> $count_gt3"
gh2="2. <https://github.com/search?q=$base_params+-label%3Algtm&type=pullrequests|No LGTM:> $no_lgtm_count"
gh3="3. <https://github.com/search?q=$base_params+-label%3Aapproved&type=pullrequests|No Approval:> $no_approval_count"
gh4="4. <https://github.com/search?q=$base_params+-label%3Algtm+label%3Aapproved&type=pullrequests|Approved, no LGTM:> $no_lgtm_approved_count"
gh5="5. <https://github.com/search?q=$cherrypick_params&type=pullrequests|Waiting cherry-pick-approved:> $cherrypick_count"
gh6="6. <https://github.com/search?q=$base_params&type=pullrequests|Open PRs (team):> $open_prs_count"

echo "Posting on #rhdh-ux-ui slack channel"

# Debug: Check variable lengths and content
echo "Debug: Variable checks"
echo "  head length: ${#head}"
echo "  rhdh_ui_stories length: ${#rhdh_ui_stories}"
echo "  rhdh_bugs length: ${#rhdh_bugs}"

# Check for empty or null values
if [ -z "$rhdh_ui_stories" ] || [ "$rhdh_ui_stories" = "null" ]; then
    echo "WARNING: rhdh_ui_stories is empty or null"
    rhdh_ui_stories="\n*UI Stories*\n(No data available)"
fi

if [ -z "$rhdh_bugs" ] || [ "$rhdh_bugs" = "null" ]; then
    echo "WARNING: rhdh_bugs is empty or null"
    rhdh_bugs="\n*Bugs:*\n(No data available)"
fi

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

# Validate JSON before sending
echo "Debug: Validating JSON structure"
if ! echo "$data"|jq empty 2>/dev/null; then
    echo "ERROR: Invalid JSON generated!"
    echo "JSON validation error:"
    echo "$data" | jq . 2>&1 | head -20
    exit 1
fi

# Check field text lengths (Slack limit is 2000 chars per field)
echo "Debug: Checking field text lengths"
stories_text=$(echo "$data" | jq -r '.blocks[3].fields[0].text')
bugs_text=$(echo "$data" | jq -r '.blocks[3].fields[1].text')

stories_len=$(echo -n "$data" | jq -r '.blocks[3].fields[0].text' | wc -c)
bugs_len=$(echo -n "$data" | jq -r '.blocks[3].fields[1].text' | wc -c)
github_len_sum=$(echo -n "$data" | jq -r '.blocks[6].fields | map(.text) | join("\n")' | wc -c)

echo "  Stories field: $stories_len chars (limit: 2000)"
echo "  Bugs field: $bugs_len chars (limit: 2000)"
echo "  Github fields total (for info): $github_len_sum chars"

if [ "$stories_len" -gt 2000 ] || [ "$bugs_len" -gt 2000 ]; then
  echo "ERROR: A section field exceeds Slack 2000-char limit"
  exit 1
fi

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

# Send to Slack and capture response
echo "Debug: Sending to Slack..."
response=$(curl -fSs -S -w "\n%{http_code}" -X POST -H "Content-type:application/json" --data "$data" $2)
http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | sed '$d')

# Check HTTP response code
if [ "$http_code" != "200" ]; then
    echo "ERROR: Slack API returned HTTP $http_code"
    echo "Response body: $body"
    
    # Try to parse error details
    if echo "$body" | jq -e '.error' > /dev/null 2>&1; then
        error=$(echo "$body" | jq -r '.error')
        echo "Slack error: $error"
        
        if echo "$body" | jq -e '.response_metadata' > /dev/null 2>&1; then
            echo "Response metadata:"
            echo "$body" | jq '.response_metadata'
        fi
    fi
    
    if [ -n "$GITHUB_ACTIONS" ] || [ -n "$CI" ]; then
        echo "Debug: Full payload available at /tmp/slack_payload.json"
        echo "Debug: Analyzing each block for issues..."
        
        # Check each block individually
        block_count=$(echo "$data" | jq '.blocks | length')
        for i in $(seq 0 $((block_count - 1))); do
            block_type=$(echo "$data" | jq -r ".blocks[$i].type")
            echo "  Block $i: type=$block_type"
            
            if [ "$block_type" = "section" ]; then
                if echo "$data" | jq -e ".blocks[$i].fields" > /dev/null 2>&1; then
                    field_count=$(echo "$data" | jq ".blocks[$i].fields | length")
                    for j in $(seq 0 $((field_count - 1))); do
                        field_text=$(echo "$data" | jq -r ".blocks[$i].fields[$j].text")
                        text_len=$(echo -n "$field_text" | wc -c)
                        echo "    Field $j: $text_len chars"
                        
                        # Check for problematic characters
                        if echo "$field_text" | grep -q '[[:cntrl:]]' && ! echo "$field_text" | grep -q $'\n'; then
                            echo "      WARNING: Contains control characters"
                        fi
                        
                        # Check for unescaped quotes
                        if echo "$field_text" | grep -q '["'\'']'; then
                            echo "      WARNING: Contains quotes that might break JSON"
                        fi
                    done
                fi
            fi
        done
        
        echo ""
        echo "Debug: Problematic fields preview:"
        echo "Stories field (first 200 chars):"
        echo "$stories_text" | head -c 200
        echo ""
        echo "Bugs field (first 200 chars):"
        echo "$bugs_text" | head -c 200
        echo ""
    fi
    
    exit 1
fi

# Check for error in response body (even with 200 status)
if echo "$body" | jq -e '.ok == false' > /dev/null 2>&1; then
    error=$(echo "$body" | jq -r '.error // "unknown error"')
    echo "ERROR: Slack API returned error: $error"
    if echo "$body" | jq -e '.response_metadata' > /dev/null 2>&1; then
        echo "Response metadata:"
        echo "$body" | jq '.response_metadata'
    fi
    exit 1
fi

echo "Debug: Successfully posted to Slack"


echo "\nDone"