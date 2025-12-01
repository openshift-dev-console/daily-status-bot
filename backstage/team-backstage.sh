set -e

authorization="Authorization: Bearer "$1

echo "Generating Status Report"

head="\nBackstage GitHub Status"

PREVIOUS_DT=`date -d "7 days ago" +%F`

echo "Fetching Github data"

url1="https://api.github.com/search/issues?q=repo%3Aredhat-developer%2Frhdh+state%3Aopen+type%3Apr+created%3A<$PREVIOUS_DT&type=Issues"
url2="https://api.github.com/search/issues?q=repo%3Aredhat-developer%2Frhdh-operator+state%3Aopen+type%3Apr+created%3A<$PREVIOUS_DT&type=Issues"
url3="https://api.github.com/search/issues?q=repo%3Aredhat-developer%2Frhdh-plugins+state%3Aopen+type%3Apr+created%3A<$PREVIOUS_DT&type=Issues"
url4="https://api.github.com/search/issues?q=repo%3Aredhat-developer%2Fred-hat-developers-documentation-rhdh+state%3Aopen+type%3Apr+created%3A<$PREVIOUS_DT&type=Issues"
url5="https://api.github.com/search/issues?q=repo%3Aredhat-developer%2Frhdh-chart+state%3Aopen+type%3Apr+created%3A<$PREVIOUS_DT&type=Issues"
url6="https://api.github.com/search/issues?q=repo%3Aredhat-developer%2Frhdh-local+state%3Aopen+type%3Apr+created%3A<$PREVIOUS_DT&type=Issues"
url7="https://api.github.com/search/issues?q=repo%3Aredhat-developer%2Frhdh-must-gather+state%3Aopen+type%3Apr+created%3A<$PREVIOUS_DT&type=Issues"

github_data_a="\n<https://github.com/search?q=repo%3Aredhat-developer%2Frhdh+state%3Aopen+type%3Apr | Total open PRs>: $(curl -s 'https://api.github.com/search/issues?q=repo%3Aredhat-developer%2Frhdh+state%3Aopen+type%3Apr' -H "Accept: application/json" -H "$authorization" | jq '.total_count // 0')"
github_data_a+="\n<https://github.com/search?q=repo%3Aredhat-developer%2Frhdh+state%3Aopen+type%3Apr+created%3A%3C$PREVIOUS_DT&type=Issues | PRs opened for more than a week>: $(curl -s $url1 -H "Accept: application/json" -H "$authorization" | jq '.total_count // 0')"

github_data_c="\n<https://github.com/search?l=&q=repo%3Aredhat-developer%2Frhdh-operator+state%3Aopen+type%3Apr | Total open PRs>: $(curl -s 'https://api.github.com/search/issues?q=repo%3Aredhat-developer%2Frhdh-operator+state%3Aopen+type%3Apr' -H "Accept: application/json" -H "$authorization" | jq '.total_count // 0')"
github_data_c+="\n<https://github.com/search?q=repo%3Aredhat-developer%2Frhdh-operator+state%3Aopen+type%3Apr+created%3A%3C$PREVIOUS_DT&type=Issues | PRs opened for more than a week>: $(curl -s $url2 -H "Accept: application/json" -H "$authorization" | jq '.total_count // 0')"

github_data_d="\n<https://github.com/search?l=&q=repo%3Aredhat-developer%2Frhdh-plugins+state%3Aopen+type%3Apr | Total open PRs>: $(curl -s 'https://api.github.com/search/issues?q=repo%3Aredhat-developer%2Frhdh-plugins+state%3Aopen+type%3Apr' -H "Accept: application/json" -H "$authorization" | jq '.total_count // 0')"
github_data_d+="\n<https://github.com/search?q=repo%3Aredhat-developer%2Frhdh-plugins+state%3Aopen+type%3Apr+created%3A%3C$PREVIOUS_DT&type=Issues | PRs opened for more than a week>: $(curl -s $url3 -H "Accept: application/json" -H "$authorization" | jq '.total_count // 0')"

github_data_e="\n<https://github.com/search?l=&q=repo%3Aredhat-developer%2Fred-hat-developers-documentation-rhdh+state%3Aopen+type%3Apr | Total open PRs>: $(curl -s 'https://api.github.com/search/issues?q=repo%3Aredhat-developer%2Fred-hat-developers-documentation-rhdh+state%3Aopen+type%3Apr' -H "Accept: application/json" -H "$authorization" | jq '.total_count // 0')"
github_data_e+="\n<https://github.com/search?q=repo%3Aredhat-developer%2Fred-hat-developers-documentation-rhdh+state%3Aopen+type%3Apr+created%3A%3C$PREVIOUS_DT&type=Issues | PRs opened for more than a week>: $(curl -s $url4 -H "Accept: application/json" -H "$authorization" | jq '.total_count // 0')"

github_data_f="\n<https://github.com/search?l=&q=repo%3Aredhat-developer%2Frhdh-chart+state%3Aopen+type%3Apr | Total open PRs>: $(curl -s 'https://api.github.com/search/issues?q=repo%3Aredhat-developer%2Frhdh-chart+state%3Aopen+type%3Apr' -H "Accept: application/json" -H "$authorization" | jq '.total_count // 0')"
github_data_f+="\n<https://github.com/search?q=repo%3Aredhat-developer%2Frhdh-chart+state%3Aopen+type%3Apr+created%3A%3C$PREVIOUS_DT&type=Issues | PRs opened for more than a week>: $(curl -s $url5 -H "Accept: application/json" -H "$authorization" | jq '.total_count // 0')"

github_data_g="\n<https://github.com/search?l=&q=repo%3Aredhat-developer%2Frhdh-local+state%3Aopen+type%3Apr | Total open PRs>: $(curl -s 'https://api.github.com/search/issues?q=repo%3Aredhat-developer%2Frhdh-local+state%3Aopen+type%3Apr' -H "Accept: application/json" -H "$authorization" | jq '.total_count // 0')"
github_data_g+="\n<https://github.com/search?q=repo%3Aredhat-developer%2Frhdh-local+state%3Aopen+type%3Apr+created%3A%3C$PREVIOUS_DT&type=Issues | PRs opened for more than a week>: $(curl -s $url6 -H "Accept: application/json" -H "$authorization" | jq '.total_count // 0')"

github_data_h="\n<https://github.com/search?l=&q=repo%3Aredhat-developer%2Frhdh-must-gather+state%3Aopen+type%3Apr | Total open PRs>: $(curl -s 'https://api.github.com/search/issues?q=repo%3Aredhat-developer%2Frhdh-must-gather+state%3Aopen+type%3Apr' -H "Accept: application/json" -H "$authorization" | jq '.total_count // 0')"
github_data_h+="\n<https://github.com/search?q=repo%3Aredhat-developer%2Frhdh-must-gather+state%3Aopen+type%3Apr+created%3A%3C$PREVIOUS_DT&type=Issues | PRs opened for more than a week>: $(curl -s $url7 -H "Accept: application/json" -H "$authorization" | jq '.total_count // 0')"

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
          "text": "*rhdh*"
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
          "text": "*rhdh-plugins*"
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
    },
    {
      "type": "section",
      "fields": [
        {
          "type": "mrkdwn",
          "text": "*rhdh-chart*"
        }
      ]
    },
    {
      "type": "section",
      "fields": [
        {
          "type": "mrkdwn",
          "text": "'$github_data_f'"
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
          "text": "*rhdh-local*"
        }
      ]
    },
    {
      "type": "section",
      "fields": [
        {
          "type": "mrkdwn",
          "text": "'$github_data_g'"
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
          "text": "*rhdh-must-gather*"
        }
      ]
    },
    {
      "type": "section",
      "fields": [
        {
          "type": "mrkdwn",
          "text": "'$github_data_h'"
        }
      ]
    },
    {
      "type": "divider"
    }
  ]
}'

# Display the data in a readable format
# echo -e "\n=========================================="
# echo -e "GitHub Status Report Preview"
# echo -e "==========================================\n"
# echo -e "rhdh:$github_data_a"
# echo -e "\nrhdh-operator:$github_data_c"
# echo -e "\nrhdh-plugins:$github_data_d"
# echo -e "\nred-hat-developers-documentation-rhdh:$github_data_e"
# echo -e "\nrhdh-chart:$github_data_f"
# echo -e "\nrhdh-local:$github_data_g"
# echo -e "\nrhdh-must-gather:$github_data_h"
# echo -e "\n==========================================\n"

curl -X POST -H "Content-type:application/json" --data "$data" $2

echo -e "\nDone"
