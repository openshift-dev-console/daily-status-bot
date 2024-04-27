set -e

echo "Generating Status Report"

head="\nBackstage GitHub Status"

PREVIOUS_DT=`date -v -7d "+%F"`

echo "Fetching Github data"

url1="https://api.github.com/search/issues?q=repo%3Ajanus-idp%2Fbackstage-showcase+state%3Aopen+type%3Apr+created%3A<$PREVIOUS_DT&type=Issues"
url2="https://api.github.com/search/issues?q=repo%3Ajanus-idp%2Fbackstage-plugins+state%3Aopen+type%3Apr+created%3A<$PREVIOUS_DT&type=Issues"
url3="https://api.github.com/search/issues?q=repo%3Ajanus-idp%2Fjanus-idp.github.io+state%3Aopen+type%3Apr+created%3A<$PREVIOUS_DT&type=Issues"

showcase_github_data="\n<https://github.com/search?l=&q=repo%3Ajanus-idp%2Fbackstage-showcase+state%3Aopen+type%3Apr | Total open PRs>: $(curl -s 'https://api.github.com/search/issues?q=repo%3Ajanus-idp%2Fbackstage-showcase+state%3Aopen+type%3Apr' -H "Accept: application/json" | jq '.total_count // 0')"
showcase_github_data+="\n<https://github.com/search?q=repo%3Ajanus-idp%2Fbackstage-showcase+state%3Aopen+type%3Apr+created%3A%3C$PREVIOUS_DT&type=Issues | PRs opened for more than a week>: $(curl -s $url1 -H "Accept: application/json" | jq '.total_count // 0')"

plugins_github_data="\n<https://github.com/search?l=&q=repo%3Ajanus-idp%2Fbackstage-plugins+state%3Aopen+type%3Apr | Total open PRs>: $(curl -s 'https://api.github.com/search/issues?q=repo%3Ajanus-idp%2Fbackstage-plugins+state%3Aopen+type%3Apr' -H "Accept: application/json" | jq '.total_count // 0')"
plugins_github_data+="\n<https://github.com/search?q=repo%3Ajanus-idp%2Fbackstage-plugins+state%3Aopen+type%3Apr+created%3A%3C$PREVIOUS_DT&type=Issues | PRs opened for more than a week>: $(curl -s $url2 -H "Accept: application/json" | jq '.total_count // 0')"

janusidp_github_data="\n<https://github.com/search?l=&q=repo%3Ajanus-idp%2Fjanus-idp.github.io+state%3Aopen+type%3Apr | Total open PRs>: $(curl -s 'https://api.github.com/search/issues?q=repo%3Ajanus-idp%2Fjanus-idp.github.io+state%3Aopen+type%3Apr' -H "Accept: application/json" | jq '.total_count // 0')"
janusidp_github_data+="\n<https://github.com/search?q=repo%3Ajanus-idp%2Fjanus-idp.github.io+state%3Aopen+type%3Apr+created%3A%3C$PREVIOUS_DT&type=Issues | PRs opened for more than a week>: $(curl -s $url3 -H "Accept: application/json" | jq '.total_count // 0')"

echo "Posting on slack"

data='{
    text: 'GitHub Status report',
    blocks: [
        {
            "type": 'header',
            text: {
                "type": 'plain_text',
                text: head
            }
        },
        {
            "type": 'section',
            fields: [
                {
                    "type": 'mrkdwn',
                    text: '*backstage-showcase*'
                }
            ]
        },
        {
            "type": 'section',
            fields: [
                {
                    "type": 'mrkdwn',
                    text: github_data_a
                },
            ]
        },
        {
            "type": 'divider'
        },
        {
            "type": 'section',
            fields: [
                {
                    "type": 'mrkdwn',
                    text: '*backstage-plugins*'
                }
            ]
        },
        {
            "type": 'section',
            fields: [
                {
                    "type": 'mrkdwn',
                    text: github_data_b
                },
            ]
        },
        {
            "type": 'divider'
        },
        {
            "type": 'section',
            fields: [
                {
                    "type": 'mrkdwn',
                    text: '*janus-idp.github.io*'
                }
            ]
        },
        {
            "type": 'section',
            fields: [
                {
                    "type": 'mrkdwn',
                    text: github_data_c
                },
            ]
        },
        {
            "type": 'divider'
        },
        {
            "type": 'section',
            fields: [
                {
                    "type": 'mrkdwn',
                    text: '*operator*'
                }
            ]
        },
        {
            "type": 'section',
            fields: [
                {
                    "type": 'mrkdwn',
                    text: github_data_d
                },
            ]
        },
        {
            "type": 'divider'
        },
            {
    "type": "section",
    fields: [
        {
        "type": "mrkdwn",
        text: "*red-hat-developers-documentation-rhdh*",
        },
    ],
    },
    {
    "type": "section",
    fields: [
        {
        "type": "mrkdwn",
        text: github_data_e,
        },
    ],
    },
    {
    "type": "divider",
    },
    ]
}'

curl -X POST -H "Content-type:application/json" --data "$data" $1

echo "\nDone"