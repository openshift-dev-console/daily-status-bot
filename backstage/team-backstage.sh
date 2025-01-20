set -e

echo "Generating Status Report"

head="\nBackstage GitHub Status"

PREVIOUS_DT=`date -d "7 days ago" +%F`

echo "Fetching Github datas"

url1="https://api.github.com/search/issues?q=repo%3Aredhat-developer%2Frhdh+state%3Aopen+type%3Apr+created%3A<$PREVIOUS_DT&type=Issues"
url2="https://api.github.com/search/issues?q=repo%3Ajanus-idp%2Fbackstage-plugins+state%3Aopen+type%3Apr+created%3A<$PREVIOUS_DT&type=Issues"
url3="https://api.github.com/search/issues?q=repo%3Aredhat-developer%2Frhdh-operator+state%3Aopen+type%3Apr+created%3A<$PREVIOUS_DT&type=Issues"
url4="https://api.github.com/search/issues?q=repo%3Ajanus-idp%2Fjanus-idp.github.io+state%3Aopen+type%3Apr+created%3A<$PREVIOUS_DT&type=Issues"
url5="https://api.github.com/search/issues?q=repo%3Aredhat-developer%2Fred-hat-developers-documentation-rhdh+state%3Aopen+type%3Apr+created%3A<$PREVIOUS_DT&type=Issues"

github_data_a="\n<https://github.com/search?q=repo%3Aredhat-developer%2Frhdh+state%3Aopen+type%3Apr | Total open PRs>: $(curl -s 'https://api.github.com/search/issues?q=repo%3Aredhat-developer%2Frhdh+state%3Aopen+type%3Apr' -H "Accept: application/json" | jq '.total_count // 0')"
github_data_a+="\n<https://github.com/search?q=repo%3Aredhat-developer%2Frhdh+state%3Aopen+type%3Apr+created%3A%3C$PREVIOUS_DT&type=Issues | PRs opened for more than a week>: $(curl -s $url1 -H "Accept: application/json" | jq '.total_count // 0')"

github_data_b="\n<https://github.com/search?l=&q=repo%3Ajanus-idp%2Fbackstage-plugins+state%3Aopen+type%3Apr | Total open PRs>: $(curl -s 'https://api.github.com/search/issues?q=repo%3Ajanus-idp%2Fbackstage-plugins+state%3Aopen+type%3Apr' -H "Accept: application/json" | jq '.total_count // 0')"
github_data_b+="\n<https://github.com/search?q=repo%3Ajanus-idp%2Fbackstage-plugins+state%3Aopen+type%3Apr+created%3A%3C$PREVIOUS_DT&type=Issues | PRs opened for more than a week>: $(curl -s $url2 -H "Accept: application/json" | jq '.total_count // 0')"

github_data_c="\n<https://github.com/search?l=&q=repo%3Aredhat-developer%2Frhdh-operator+state%3Aopen+type%3Apr | Total open PRs>: $(curl -s 'https://api.github.com/search/issues?q=repo%3Aredhat-developer%2Frhdh-operator+state%3Aopen+type%3Apr' -H "Accept: application/json" | jq '.total_count // 0')"
github_data_c+="\n<https://github.com/search?q=repo%3Aredhat-developer%2Frhdh-operator+state%3Aopen+type%3Apr+created%3A%3C$PREVIOUS_DT&type=Issues | PRs opened for more than a week>: $(curl -s $url3 -H "Accept: application/json" | jq '.total_count // 0')"

github_data_d="\n<https://github.com/search?l=&q=repo%3Ajanus-idp%2Fjanus-idp.github.io+state%3Aopen+type%3Apr | Total open PRs>: $(curl -s 'https://api.github.com/search/issues?q=repo%3Ajanus-idp%2Fjanus-idp.github.io+state%3Aopen+type%3Apr' -H "Accept: application/json" | jq '.total_count // 0')"
github_data_d+="\n<https://github.com/search?q=repo%3Ajanus-idp%2Fjanus-idp.github.io+state%3Aopen+type%3Apr+created%3A%3C$PREVIOUS_DT&type=Issues | PRs opened for more than a week>: $(curl -s $url4 -H "Accept: application/json" | jq '.total_count // 0')"

github_data_e="\n<https://github.com/search?l=&q=repo%3Aredhat-developer%2Fred-hat-developers-documentation-rhdh+state%3Aopen+type%3Apr | Total open PRs>: $(curl -s 'https://api.github.com/search/issues?q=repo%3Aredhat-developer%2Fred-hat-developers-documentation-rhdh+state%3Aopen+type%3Apr' -H "Accept: application/json" | jq '.total_count // 0')"
github_data_e+="\n<https://github.com/search?q=repo%3Aredhat-developer%2Fred-hat-developers-documentation-rhdh+state%3Aopen+type%3Apr+created%3A%3C$PREVIOUS_DT&type=Issues | PRs opened for more than a week>: $(curl -s $url5 -H "Accept: application/json" | jq '.total_count // 0')"

echo "Posting on slack"

data='{
  "text": "GitHub Status report",
  "blocks": [
    {
      "type": "header",
      "text": {
        "type": "plain_text",
        "text": "'$head'"
      }
    },
    {
      "type": "section",
      "fields": [
        {
          "type": "mrkdwn",
          "text": "*backstage-showcase*"
        }
      ]
    },
    {
      "type": "section",
      "fields": [
        {
          "type": "mrkdwn",
          "text": "'$github_data_a'"
        }
      ]
    },
    {
      "type": "divider"
    },
    {
      "type": "section",
      "fields": [
        {
          "type": "mrkdwn",
          "text": "*backstage-plugins*"
        }
      ]
    },
    {
      "type": "section",
      "fields": [
        {
          "type": "mrkdwn",
          "text": "'$github_data_b'"
        }
      ]
    },
    {
      "type": "divider"
    },
    {
      "type": "section",
      "fields": [
        {
          "type": "mrkdwn",
          "text": "*rhdh-operator*"
        }
      ]
    },
    {
      "type": "section",
      "fields": [
        {
          "type": "mrkdwn",
          "text": "'$github_data_c'"
        }
      ]
    },
    {
      "type": "divider"
    },
    {
      "type": "section",
      "fields": [
        {
          "type": "mrkdwn",
          "text": "*janus-idp.github.io*"
        }
      ]
    },
    {
      "type": "section",
      "fields": [
        {
          "type": "mrkdwn",
          "text": "'$github_data_d'"
        }
      ]
    },
    {
      "type": "divider"
    },
    {
      "type": "section",
      "fields": [
        {
          "type": "mrkdwn",
          "text": "*red-hat-developers-documentation-rhdh*"
        }
      ]
    },
    {
      "type": "section",
      "fields": [
        {
          "type": "mrkdwn",
          "text": "'$github_data_e'"
        }
      ]
    },
    {
      "type": "divider"
    }
  ]
}'

curl -X POST -H "Content-type:application/json" --data "$data" $1

echo "\nDone"
