set -e

authorization="Authorization: Bearer "$1

echo "Generating Status Report"

head='RHTAP UI' 

echo "Fetching RHTAP stories"

hac_stories='\n\n*UI Stories* :toy-story-buzz::toy-story-buzz:'
hac_stories+="\n1. <https://issues.redhat.com/issues/?filter=12396633 | Stories Done> ($(curl -s "https://issues.redhat.com/rest/api/2/search?jql=filter=12396633" -H "Accept: application/json" | jq ".total"))"
alert_check=$(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12396635' -H "Accept: application/json" | jq '.total')
hac_stories+="\n2. <https://issues.redhat.com/issues/?filter=12396635 | Stories In Review> ($alert_check)"
if [ $alert_check -ge 15 ]; then
    hac_stories+=" :fire::fire:"
fi
hac_stories+="\n3. <https://issues.redhat.com/issues/?filter=12396638 | Unassigned Stories>($(curl -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12396638' -H "Accept: application/json" | jq '.total'))" 
hac_stories+="\n4. <https://issues.redhat.com/issues/?filter=12396637 | Ready for pointing stories> ($(curl -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12396637' -H "Accept: application/json" | jq '.total'))" 

echo "Fetching RHTAP bugs"

hac_bugs="\n\n *Bugs:* :bug::bug:"
hac_bugs+="\n1. <https://issues.redhat.com/issues/?filter=12396775 | QE Review> ($(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12396775' -H "Accept: application/json" | jq '.total'))" 
alert_check=$(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12416904' -H "Accept: application/json" | jq '.total')
hac_bugs+="\n2. <https://issues.redhat.com/issues/?filter=12416904 | Open RHTAP UI bugs> ($alert_check)" 
if [ $alert_check -ge 45 ]; then
    hac_bugs+=" :fire::fire:"
fi
alert_check=$(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12416902' -H "Accept: application/json" | jq '.total')
hac_bugs+="\n3. <https://issues.redhat.com/issues/?filter=12416902 | Triaged RHTAP UI bugs> ($alert_check)" 
if [ $alert_check -ge 25 ]; then
    hac_bugs+=" :fire::fire:"
fi
alert_check=$(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12416903' -H "Accept: application/json" | jq '.total')
hac_bugs+="\n4. <https://issues.redhat.com/issues/?filter=12416903 | Needs info RHTAP UI bugs> ($alert_check)" 
if [ $alert_check -ge 25 ]; then
    hac_bugs+=" :fire::fire:"
fi
hac_bugs+="\n5. <https://issues.redhat.com/issues/?filter=12396778 | Triaged Bugs> ($(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12396778' -H "Accept: application/json" | jq '.total'))" 
hac_bugs+="\n6. <https://issues.redhat.com/issues/?filter=12426879 | Release pending bugs> ($(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12426879' -H "Accept: application/json" | jq '.total'))" 

# this is block 3
echo "Fetching RHTAP dashboard"

stonesoup_dashboard="\n\n *RHTAP Dashboard:* :clipboard::clipboard:"
stonesoup_dashboard+="\n1. <https://issues.redhat.com/issues/?filter=12405355 | Blocked> ($(curl -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12405355' -H "Accept: application/json" | jq '.total'))"
alert_check=$(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12405357' -H "Accept: application/json" | jq '.total')
stonesoup_dashboard+="\n2. <https://issues.redhat.com/issues/?filter=12405357 | Open stonesoup UI bugs> ($(curl -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12405357' -H "Accept: application/json" | jq '.total'))"  
if [ $alert_check -ge 45 ]; then
    stonesoup_dashboard+=" :fire::fire:"
fi
stonesoup_dashboard+="\n3. <https://issues.redhat.com/issues/?filter=12405358 | Stonesoup UI - Needs UX> ($(curl -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12405358' -H "Accept: application/json" | jq '.total'))" 
alert_check=$(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12405686' -H "Accept: application/json" | jq '.total')
stonesoup_dashboard+="\n4. <https://issues.redhat.com/issues/?filter=12405686 | Untriaged Stonesoup bugs> ($alert_check)" 
if [ $alert_check -ge 45 ]; then
    stonesoup_dashboard+=" :fire::fire:"
fi

echo "Fetching RHTAP bugs SLI data" 

rhtap_blockers="\n\n *RHTAP Blocker bugs:*"
rhtap_blockers+="\n1. <https://issues.redhat.com/issues/?filter=12426878 | Bloker reds :alert-siren:> ($(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12426878' -H "Accept: application/json" | jq '.total'))" 
rhtap_blockers+="\n2. <https://issues.redhat.com/issues/?filter=12426877 | Bloker yellows :large_yellow_circle: > ($(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12426877' -H "Accept: application/json" | jq '.total'))" 
rhtap_blockers+="\n3. <https://issues.redhat.com/issues/?filter=12426876 | Bloker greens :green-circle:: > ($(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12426876' -H "Accept: application/json" | jq '.total'))" 

rhtap_critical="\n\n *RHTAP Critical bugs:*"
rhtap_critical+="\n1. <https://issues.redhat.com/issues/?filter=12426873 | Critical reds :alert-siren:> ($(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12426873' -H "Accept: application/json" | jq '.total'))" 
rhtap_critical+="\n2. <https://issues.redhat.com/issues/?filter=12426874 | Critical yellows :large_yellow_circle:> ($(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12426874' -H "Accept: application/json" | jq '.total'))" 
rhtap_critical+="\n3. <https://issues.redhat.com/issues/?filter=12426875 | Critical greens :green-circle:> ($(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12426875' -H "Accept: application/json" | jq '.total'))" 

rhtap_major="\n\n"
rhtap_major+="\n\n *RHTAP Major bugs:*"
rhtap_major+="\n1. <https://issues.redhat.com/issues/?filter=12426870 | Major reds :alert-siren:> ($(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12426870' -H "Accept: application/json" | jq '.total'))" 
rhtap_major+="\n2. <https://issues.redhat.com/issues/?filter=12426871 | Major yellows :large_yellow_circle:> ($(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12426871' -H "Accept: application/json" | jq '.total'))" 
rhtap_major+="\n3. <https://issues.redhat.com/issues/?filter=12426872 | Major greens :green-circle:> ($(curl -H "$authorization" -s 'https://issues.redhat.com/rest/api/2/search?jql=filter=12426872' -H "Accept: application/json" | jq '.total'))" 

echo "Fetching Github data"

github_data="\n\n *GitHub filters:* :github: :github:"
github_data+="\n<https://github.com/search?q=repo%3Aopenshift%2Fhac-dev+state%3Aopen&type=issues | HAC open PRs>:  $(curl -s 'https://api.github.com/search/issues?q=repo%3Aopenshift%2Fhac-dev+state%3Aopen&type=issues' -H "Accept: application/json" | jq '.total_count')"
github_data+="\n<https://github.com/search?q=repo%3Aopenshift%2Fhac-dev+state%3Aopen+-label%3algtm&type=issues | HAC PRs without LGTM>:  $(curl -s 'https://api.github.com/search/issues?q=repo%3Aopenshift%2Fhac-dev+state%3Aopen+-label%3algtm&type=issues' -H "Accept: application/json" | jq '.total_count')"
github_data+="\n<https://github.com/search?q=repo%3Aopenshift%2Fhac-dev+state%3Aopen+-label%3aapproved&type=issues | HAC PRs without APPROVED>:  $(curl -s 'https://api.github.com/search/issues?q=repo%3Aopenshift%2Fhac-dev+state%3Aopen+-label%3aapproved&type=issues' -H "Accept: application/json" | jq '.total_count')"
github_data+="\n<https://github.com/search?q=repo%3Aopenshift%2Fhac-dev+repo%3Aopenshift%2Fconsole+repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+-label%3Ado-not-merge%2Fwork-in-progress+-label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Anemesis09+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+created%3A%3C2022-06-19+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=Issues&ref=advsearch&l=&l= | PRs Opened for more than 7 days>:  $(curl -s 'https://api.github.com/search/issues?q=repo%3Aopenshift%2Fhac-dev+repo%3Aopenshift%2Fconsole+repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+-label%3Ado-not-merge%2Fwork-in-progress+-label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Anemesis09+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+created%3A%3C2022-06-19+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=repositories' -H "Accept: application/json" | jq '.total_count')"

echo "Posting on slack"



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
					"text": "'$hac_stories'"
				},
				{
					"type": "mrkdwn",
					"text": "'$hac_bugs'"
				}
			]
		},
		{
			"type": "section",
			"fields": [
				{
					"type": "mrkdwn",
					"text": "*RHTAP Bugs SLI*"
				}
			]
		},
		{
			"type": "section",
			"fields": [
				{
					"type": "mrkdwn",
					"text": "'$rhtap_blockers'"
				},
				{
					"type": "mrkdwn",
					"text": "'$rhtap_critical'"
				},
				{
					"type": "mrkdwn",
					"text": "'$rhtap_major'"
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
					"text": "'$stonesoup_dashboard'"
				}
			]
		},
        {
            "type":"divider",
        },
		{
			"type": "section",
			"text": {
				"type": "mrkdwn",
				"text": "'$github_data'"
			}
		},
		        {
            "type":"divider",
        },
	]
}'

curl -X POST -H "Content-type:application/json" --data "$data" $2


echo "\nDone"