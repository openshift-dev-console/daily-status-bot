set -e

authorization="Authorization: Bearer "$1

echo "Generating Status Report"

head="\nODC Sprint Status"

echo "Fetching ODC stories"

odc_stories="\n*UI Stories*"

# Stories Done
odc_stories+="\n1. <https://issues.redhat.com/issues/?filter=12435231 | Stories Done: > $(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12435231' -H "Accept: application/json" | jq '.total')"


# Stories in Review
odc_stories+="\n2. <https://issues.redhat.com/issues/?filter=12435230 | Stories In Review: > $(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12435230' -H "Accept: application/json" | jq '.total')"


# Unassigned Stories
odc_stories+="\n3. <https://issues.redhat.com/issues/?filter=12435229 | Unassigned Stories: > $(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12435229' -H "Accept: application/json" | jq '.total')"


# Ready for pointing
odc_stories+="\n4. <https://issues.redhat.com/issues/?filter=12435232 | Ready to Point Stories: > $(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12435232' -H "Accept: application/json" | jq '.total')"

echo "Fetching ODC bugs"

odc_bugs="\n*Bugs:*"

# Bugs in Code Review
bugs=$(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12435233' -H "Accept: application/json" | jq '.total')
odc_bugs+="\n1. <https://issues.redhat.com/issues/?filter=12435233 | Bugs In Code Review: > $bugs"
if [ $bugs -ge 20 ]; then
    odc_bugs+=" :fire::fire:"
fi

# Bugs in QE Review
qe_bugs=$(curl -H  "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12435234' -H "Accept: application/json" | jq '.total')
odc_bugs+="\n2. <https://issues.redhat.com/issues/?filter=12435234 | Bugs In QE Review: > $qe_bugs"
if [ $qe_bugs -ge 10 ]; then
    odc_bugs+=" :fire::fire:"
fi

# Unresolved Blocker Bugs
odc_bugs+="\n3. <https://issues.redhat.com/issues/?filter=12435235 | Bugs with unresolved blockers: > $(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12435235' -H "Accept: application/json" | jq '.total')"

# Triaged Bugs
triaged_bugs=$(curl -H  "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12435236' -H "Accept: application/json" | jq '.total')
odc_bugs+="\n4. <https://issues.redhat.com/issues/?filter=12435236 | Triaged bugs: > $triaged_bugs"
if [ $triaged_bugs -ge 30 ]; then
    odc_bugs+=" :fire::fire:"
fi


open_bugs=$(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12435237' -H "Accept: application/json" | jq '.total')
odc_bugs+="\n5. <https://issues.redhat.com/issues/?filter=12435237 | Open Bug count: > $(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12435237' -H "Accept: application/json" | jq '.total')"
if [ $open_bugs -ge 40 ]; then
    odc_bugs+=" :fire::fire:"
fi

# Total Open Bugs Including Blocked, Untriaged
odc_bugs+="\n6. <https://issues.redhat.com/issues/?filter=12435238 | Total Open Bugs: > $(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12435238' -H "Accept: application/json" | jq '.total')"



echo "Fetching Github data"

# PRs Opened for more than 7 days
URL="https://github.com/search?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+repo%3Aopenshift-pipelines%2Fconsole-plugin++-label%3Ado-not-merge%2Fwork-in-progress+-label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=pullrequests&ref=advsearch&created:"
URL+="$(date -d "7 days ago" +%F)"

github_data="\n<$URL | PRs Opened for more than 7 days >:  $(curl -s 'https://api.github.com/search/issues?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+repo%3Aopenshift-pipelines%2Fconsole-plugin++-label%3Ado-not-merge%2Fwork-in-progress+-label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=pullrequests&ref=advsearch&created:<\'${seven_days_ago}'\' -H "Accept: application/json" | jq '.total_count')"


# PRs with No LGTM
github_data+="\n<https://github.com/search?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift-pipelines%2Fconsole-plugin++repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+-label%3Ado-not-merge%2Fwork-in-progress+-label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+author%3Ayozaam+state%3Aopen+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=pullrequests&ref=advsearch | PRs with No LGTM >: $(curl -s 'https://api.github.com/search/issues?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift-pipelines%2Fconsole-plugin++repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+-label%3Ado-not-merge%2Fwork-in-progress+-label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+author%3Ayozaam+state%3Aopen+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=pullrequests&ref=advsearch' -H "Accept: application/json" | jq '.total_count')"

# PRs with LGTM without Approval
github_data_b="\n<https://github.com/search?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift-pipelines%2Fconsole-plugin++repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+-label%3Aapproved+label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3Ayozaam+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=pullrequests&ref=advsearch | PRs without Approval >: $(curl -s 'https://api.github.com/search/issues?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift-pipelines%2Fconsole-plugin++repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+-label%3Aapproved+label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3Ayozaam+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=pullrequests&ref=advsearch' | jq '.total_count')"

#PRs waiting on cherry-pick-approved
github_data_b+="\n<https://github.com/search?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift-pipelines%2Fconsole-plugin+++-label%3Acherry-pick-approved+label%3Abackport-risk-assessed+label%3Aapproved+label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Ajerolimov+author%3AdivyanshiGupta+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+author%3ALucifergene+author%3Aopenshift-cherrypick-robot+assignee%3Arohitkrai03+assignee%3Adebsmita1+assignee%3AinvincibleJai+assignee%3Asahil143+assignee%3Avikram-raj+assignee%3Ajerolimov+assignee%3AdivyanshiGupta+assignee%3Akarthikjeeyar+assignee%3Aabhinandan13jan+assignee%3ALucifergene+author%3Alokanandaprabhu+assignee%3Alokanandaprabhu+assignee%3Asanketpathak++-assignee%3Arhamilto++-assignee%3Asg00dwin+-assignee%3Ajhadvig+-assignee%3Astlaz&type=pullrequests&ref=advsearch | PRs waiting on cherry-pick-approved >: $(curl -s 'https://api.github.com/search/issues?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift-pipelines%2Fconsole-plugin+++-label%3Acherry-pick-approved+label%3Abackport-risk-assessed+label%3Aapproved+label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Ajerolimov+author%3AdivyanshiGupta+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+author%3ALucifergene+author%3Aopenshift-cherrypick-robot+assignee%3Arohitkrai03+assignee%3Adebsmita1+assignee%3AinvincibleJai+assignee%3Asahil143+assignee%3Avikram-raj+assignee%3Ajerolimov+assignee%3AdivyanshiGupta+assignee%3Akarthikjeeyar+assignee%3Aabhinandan13jan+assignee%3ALucifergene+author%3Alokanandaprabhu+assignee%3Alokanandaprabhu+assignee%3Asanketpathak++-assignee%3Arhamilto++-assignee%3Asg00dwin+-assignee%3Ajhadvig+-assignee%3Astlaz&type=pullrequests&ref=advsearch' -H "Accept: application/json" | jq '.total_count' )"

#PRs without LGTM but has Approval
github_data_c="\n<https://github.com/search?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift-pipelines%2Fconsole-plugin++repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+-label%3Algtm+label%3Aapproved+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3Ayozaam+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=pullrequests&ref=advsearch | PRs without LGTM but has Approval >:  $(curl -s 'https://api.github.com/search/issues?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift-pipelines%2Fconsole-plugin++repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+-label%3Algtm+label%3Aapproved+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3Ayozaam+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=pullrequests&ref=advsearch' -H "Accept: application/json" | jq '.total_count' )"


#PRs without QE-Approval
github_data_c+="\n<https://github.com/search?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift-pipelines%2Fconsole-plugin++repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+label%3Algtm+label%3Aapproved+-label%3Ajira%2Fvalid-bug+-label%3Aqe-approved+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3Ayozaam+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=pullrequests&ref=advsearch | PRs without QE-Approval >:  $(curl -s 'https://api.github.com/search/issues?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift-pipelines%2Fconsole-plugin++repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+label%3Algtm+label%3Aapproved+-label%3Ajira%2Fvalid-bug+-label%3Aqe-approved+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3Ayozaam+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=pullrequests&ref=advsearch' -H "Accept: application/json" | jq '.total_count' )"

#PRs with jira/invalid label
github_data_d="\n<https://github.com/search?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift-pipelines%2Fconsole-plugin+label%3Ajira%2Finvalid-bug++author%3Arohitkrai03+author%3Adebsmita1+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Ajerolimov+author%3AdivyanshiGupta+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+author%3ALucifergene+author%3Aopenshift-cherrypick-robot+assignee%3Arohitkrai03+assignee%3Adebsmita1+assignee%3AinvincibleJai+assignee%3Asahil143+assignee%3Avikram-raj+assignee%3Ajerolimov+assignee%3AdivyanshiGupta+assignee%3Akarthikjeeyar+assignee%3Aabhinandan13jan+assignee%3ALucifergene+author%3Alokanandaprabhu+assignee%3Alokanandaprabhu+assignee%3Asanketpathak++-assignee%3Arhamilto++-assignee%3Asg00dwin+-assignee%3Ajhadvig+-assignee%3Astlaz&type=pullrequests&ref=advsearch | PRs with Jira invalid bug label >: $(curl -s 'https://api.github.com/search/issues?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift-pipelines%2Fconsole-plugin+label%3Ajira%2Finvalid-bug++author%3Arohitkrai03+author%3Adebsmita1+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Ajerolimov+author%3AdivyanshiGupta+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+author%3ALucifergene+author%3Aopenshift-cherrypick-robot+assignee%3Arohitkrai03+assignee%3Adebsmita1+assignee%3AinvincibleJai+assignee%3Asahil143+assignee%3Avikram-raj+assignee%3Ajerolimov+assignee%3AdivyanshiGupta+assignee%3Akarthikjeeyar+assignee%3Aabhinandan13jan+assignee%3ALucifergene+author%3Alokanandaprabhu+assignee%3Alokanandaprabhu+assignee%3Asanketpathak++-assignee%3Arhamilto++-assignee%3Asg00dwin+-assignee%3Ajhadvig+-assignee%3Astlaz&type=pullrequests&ref=advsearch' -H "Accept: application/json" | jq '.total_count' )"


echo "Posting on #forum-devconsole slack channel"

data='{
  "text": "Status report",
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
					"text": "*Current sprint status*"
				}
			]
		},
        {
            "type":"divider",
        },
		{
			"type": "section",
			"fields": [
				{
					"type": "mrkdwn",
					"text": "'$odc_stories'"
				},
				{
					"type": "mrkdwn",
					"text": "'$odc_bugs'"
				}
			]
		},
        {
            "type":"divider",
        },
        {
			"type": "section",
			"fields": [
				{
					"type": "mrkdwn",
					"text": "*Github status*"
				}
			]
		},
		{
			"type": "section",
			"fields": [
				{
					"type": "mrkdwn",
					"text": "'$github_data'"
				},
				{
					"type": "mrkdwn",
					"text": "'$github_data_b'"
				},
                {
					"type": "mrkdwn",
					"text": "'$github_data_c'"
				},
				                {
					"type": "mrkdwn",
					"text": "'$github_data_d'"
				},
			]
		},
		{
            "type":"divider",
        },
	]
}'

curl -X POST -H "Content-type:application/json" --data "$data" $2


echo "\nDone"
