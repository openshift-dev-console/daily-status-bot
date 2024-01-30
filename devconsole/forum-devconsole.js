const SLACK_URL = "";
const JIRA_AUTH = "";

export const fetchCount = (apiUrl, github = false) => {
  return fetch(apiUrl, {
    headers: {
      ...(!github ? { Authorization: JIRA_AUTH } : {}),
      Accept: "application/json",
    },
  })
    .then((response) => response.json())
    .then((data) => {
      const totalCount = github ? data.total_count : data.total;
      return totalCount;
    })
    .catch((error) => {
      console.error("Error retrieving data:", error);
      return error;
    });
};

export const handler = async (event) => {
  console.log("Generating Status Report");

  const head = "\nODC Sprint Status";

  console.log("Fetching ODC stories");

  let odc_stories = "\n*UI Stories*";

  let count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=project%20%3D%20ODC%20AND%20type%20%3D%20Story%20AND%20Sprint%20in%20openSprints()%20and%20status%3DClosed"
  );

  odc_stories =
    odc_stories +
    `\n1. <https://issues.redhat.com/browse/ODC-7335?jql=project%20%3D%20ODC%20AND%20type%20%3D%20Story%20AND%20Sprint%20in%20openSprints()%20and%20status%3DClosed | Stories Done> (${count})`;

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=project%20%3D%20ODC%20AND%20type%20%3D%20Story%20AND%20Sprint%20in%20openSprints()%20and%20status%20in%20(%22Code%20Review%22%2C%20Review)"
  );

  odc_stories =
    odc_stories +
    `\n2. ${count}  <https://issues.redhat.com/browse/ODC-7310?jql=project%20%3D%20ODC%20AND%20type%20%3D%20Story%20AND%20Sprint%20in%20openSprints()%20and%20status%20in%20(%22Code%20Review%22%2C%20Review) | Stories In Review>`;

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=project%20%3D%20%22Openshift%20Dev%20Console%22%20AND%20type%20%3D%20Story%20AND%20%22Story%20Points%22%20!%3D%20EMPTY%20AND%20assignee%20%3D%20EMPTY%20AND%20status%20!%3D%20obsolete%20AND%20status%20!%3D%20Closed%20AND%20status%20!%3D%20Done%20AND%20fixVersion%20in%20(%22OpenShift%204.14%22%2C%204.14.0%2C%204.14%2C%20openshift-4.14)"
  );

  odc_stories =
    odc_stories +
    `\n3. <https://issues.redhat.com/issues/?filter=12413608&jql=project%20%3D%20%22Openshift%20Dev%20Console%22%20AND%20type%20%3D%20Story%20AND%20%22Story%20Points%22%20!%3D%20EMPTY%20AND%20assignee%20%3D%20EMPTY%20AND%20status%20!%3D%20obsolete%20AND%20status%20!%3D%20Closed%20AND%20status%20!%3D%20Done%20AND%20fixVersion%20in%20(%22OpenShift%204.14%22%2C%204.14.0%2C%204.14%2C%20openshift-4.14) | Unassigned stories:> (${count})`;

  count = await fetchCount(
    'https://issues.redhat.com/rest/api/2/search?jql=project%20%3D%20"Openshift%20Dev%20Console"%20AND%20type%20%3D%20Story%20AND%20"Story%20Points"%20%3D%20EMPTY%20AND%20status%20!%3D%20obsolete%20AND%20status%20!%3D%20Closed%20AND%20status%20!%3D%20Done%20AND%20fixVersion%20in%20("OpenShift%204.14"%2C%204.14.0%2C%204.14%2C%20openshift-4.14)'
  );

  odc_stories =
    odc_stories +
    `\n4. ${count} <https://issues.redhat.com/browse/ODC-6514?filter=12390129&jql=project%20%3D%20%22Openshift%20Dev%20Console%22%20AND%20type%20%3D%20Story%20AND%20%22Story%20Points%22%20%3D%20EMPTY%20AND%20status%20!%3D%20obsolete%20AND%20status%20!%3D%20Closed%20AND%20status%20!%3D%20Done%20AND%20fixVersion%20in%20(%22OpenShift%204.14%22%2C%204.14.0%2C%204.14%2C%20openshift-4.14) | Ready for pointing story>`;

  console.log("Fetching ODC bugs");

  let odc_bugs = "\n*UI Bugs*";

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12399207"
  );

  odc_bugs =
    odc_bugs +
    `\n1.  <https://issues.redhat.com/issues/?filter=12399207 | Bugs In Review > (${count})`;

  if (count >= 20) {
    odc_bugs = odc_bugs + " :fire::fire:";
  }

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12399473"
  );

  odc_bugs =
    odc_bugs +
    `\n   [ ${count} for <https://issues.redhat.com/issues/?filter=12399473  | 4.12> &`;

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12399474"
  );

  odc_bugs =
    odc_bugs +
    ` ${count} for <https://issues.redhat.com/issues/?filter=12399474  | z-stream> ]`;

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12399206"
  );

  odc_bugs =
    odc_bugs +
    `\n2. <https://issues.redhat.com/issues/?filter=12399206 | Bugs In QE Review >(${count})`;

  if (count >= 20) {
    odc_bugs = odc_bugs + " :fire::fire:";
  }

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12399208"
  );

  odc_bugs =
    odc_bugs +
    `\n3. <https://issues.redhat.com/issues/?filter=12399208 | Unresolved blockers> (${count})`;

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12411105"
  );

  odc_bugs =
    odc_bugs +
    `\n4. <https://issues.redhat.com/issues/?filter=12411105 | Triaged bugs> (${count})`;

  if (count >= 40) {
    odc_bugs = odc_bugs + " :fire::fire:";
  }

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=(project%20in%20(%22OpenShift%20Dev%20Console%22%2C%20%22OCP%20Bugs%20Mirroring%22%2C%20%22OpenShift%20Bugs%22)%20AND%20component%20in%20(UI%2C%20%22Dev%20Console%22)%20AND%20type%20%3D%20Bug%20AND%20status%20in%20(New%2C%22To%20Do%22%2C%20%22In%20Progress%22%2C%20%22In%20Review%22%20%2C%20POST)%20AND%20labels%20in%20(%22triaged%22)%20AND%20labels%20not%20in%20(%22needs-ux%22%2C%20%22needs-more-info%22)%20AND%20Blocked%20in%20(EMPTY%2C%20%22False%22)%20AND%20reporter%20!%3D%20%27openshift-bugzilla-robot%40redhat.com%27)"
  );

  odc_bugs =
    odc_bugs +
    `\n5. <https://issues.redhat.com/browse/ODC-6640?jql=project%20in%20(%22OpenShift%20Dev%20Console%22%2C%20%22OCP%20Bugs%20Mirroring%22%2C%20%22OpenShift%20Bugs%22)%20AND%20component%20in%20(UI%2C%20%22Dev%20Console%22)%20AND%20type%20%3D%20Bug%20AND%20status%20in%20(New%2C%22To%20Do%22%2C%20%22In%20Progress%22%2C%20%22In%20Review%22%20%2C%20POST)%20AND%20labels%20in%20(%22triaged%22)%20AND%20labels%20not%20in%20(%22needs-ux%22%2C%20%22needs-more-info%22)%20AND%20Blocked%20in%20(EMPTY%2C%20%22False%22)%20AND%20reporter%20!%3D%20%27openshift-bugzilla-robot%40redhat.com%27 | Open Bug count:> (${count})`;

  if (count >= 40) {
    odc_bugs = odc_bugs + " :fire::fire:";
  }

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=(project%20in%20(%22OpenShift%20Dev%20Console%22%2C%20%22OCP%20Bugs%20Mirroring%22%2C%20%22OpenShift%20Bugs%22)%20AND%20component%20in%20(UI%2C%20%22Dev%20Console%22)%20AND%20type%20%3D%20Bug%20AND%20status%20in%20(New%2C%22To%20Do%22%2C%20%22In%20Progress%22%2C%20%22In%20Review%22%20%2C%20POST)%20AND%20reporter%20!%3D%20%27openshift-bugzilla-robot%40redhat.com%27)"
  );

  odc_bugs =
    odc_bugs +
    `\n6. <https://issues.redhat.com/browse/OCPBUGS-3228?jql=project%20in%20(%22OpenShift%20Dev%20Console%22%2C%20%22OCP%20Bugs%20Mirroring%22%2C%20%22OpenShift%20Bugs%22)%20AND%20component%20in%20(UI%2C%20%22Dev%20Console%22)%20AND%20type%20%3D%20Bug%20AND%20status%20in%20(New%2C%22To%20Do%22%2C%20%22In%20Progress%22%2C%20%22In%20Review%22%20%2C%20POST)%20AND%20reporter%20!%3D%20%27openshift-bugzilla-robot%40redhat.com%27 | Total open bugs (incl. untriaged, blocked):> (${count})`;

  console.log("Fetching github data");

  count = await fetchCount(
    "https://api.github.com/search/issues?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+-label%3Ado-not-merge%2Fwork-in-progress+-label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+created%3A%3C2022-08-15+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=pullrequests&ref=advsearch&l=&l=",
    true
  );

  let github_data = `\n<https://github.com/search?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+-label%3Ado-not-merge%2Fwork-in-progress+-label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+created%3A%3C2022-08-15+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=pullrequests&ref=advsearch&l=&l= | PRs Opened for more than 7 days>:  ${count}`;

  count = await fetchCount(
    "https://api.github.com/search/issues?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+-label%3Ado-not-merge%2Fwork-in-progress+-label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+author%3Ayozaam+state%3Aopen+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=pullrequests&ref=advsearch&l=&l=",
    true
  );

  github_data =
    github_data +
    `\n<https://github.com/search?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+-label%3Ado-not-merge%2Fwork-in-progress+-label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+author%3Ayozaam+state%3Aopen+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=pullrequests&ref=advsearch&l=&l= | PRs with No LGTM>: ${count}`;

  count = await fetchCount(
    "https://api.github.com/search/issues?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+-label%3Aapproved+label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3Ayozaam+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=pullrequests&ref=advsearch&ref=advsearch&l=&l=",
    true
  );

  let github_data_b = `\n<https://github.com/search?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+-label%3Aapproved+label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3Ayozaam+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=pullrequests&ref=advsearch&l=&l= | PRs without Approval>: ${count}`;

  count = await fetchCount(
    "https://api.github.com/search/issues?q=repo%3Aopenshift%2Fconsole++-label%3Acherry-pick-approved+label%3Abackport-risk-assessed+label%3Aapproved+label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Ajerolimov+author%3AdivyanshiGupta+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+author%3ALucifergene+author%3Aopenshift-cherrypick-robot+assignee%3Arohitkrai03+assignee%3Adebsmita1+assignee%3AinvincibleJai+assignee%3Asahil143+assignee%3Avikram-raj+assignee%3Ajerolimov+assignee%3AdivyanshiGupta+assignee%3Akarthikjeeyar+assignee%3Aabhinandan13jan+assignee%3ALucifergene+author%3Alokanandaprabhu+assignee%3Alokanandaprabhu+assignee%3Asanketpathak++-assignee%3Arhamilto++-assignee%3Asg00dwin+-assignee%3Ajhadvig+-assignee%3Astlaz&type=pullrequests&ref=advsearch",
    true
  );

  github_data_b =
    github_data_b +
    `\n<https://github.com/search?q=repo%3Aopenshift%2Fconsole++-label%3Acherry-pick-approved+label%3Abackport-risk-assessed+label%3Aapproved+label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Ajerolimov+author%3AdivyanshiGupta+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+author%3ALucifergene+author%3Aopenshift-cherrypick-robot+assignee%3Arohitkrai03+assignee%3Adebsmita1+assignee%3AinvincibleJai+assignee%3Asahil143+assignee%3Avikram-raj+assignee%3Ajerolimov+assignee%3AdivyanshiGupta+assignee%3Akarthikjeeyar+assignee%3Aabhinandan13jan+assignee%3ALucifergene+author%3Alokanandaprabhu+assignee%3Alokanandaprabhu+assignee%3Asanketpathak++-assignee%3Arhamilto++-assignee%3Asg00dwin+-assignee%3Ajhadvig+-assignee%3Astlaz&type=pullrequests&ref=advsearch | PRs waiting on cherry-pick-approved>: ${count}`;

  count = await fetchCount(
    "https://api.github.com/search/issues?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+-label%3Algtm+label%3Aapproved+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3Ayozaam+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=pullrequests&ref=advsearch",
    true
  );

  let github_data_c = `\n<https://github.com/search?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+-label%3Algtm+label%3Aapproved+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3Ayozaam+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=pullrequests&ref=advsearch | PRs without LGTM but has Approval>: ${count}`;

  count = await fetchCount(
    "https://api.github.com/search/issues?q=https://api.github.com/search/issues?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+label%3Algtm+label%3Aapproved+-label%3Ajira%2Fvalid-bug+-label%3Aqe-approved+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3Ayozaam+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=pullrequests&ref=advsearch",
    true
  );

  let github_data_d = `\n<https://github.com/search?q=repo%3Aopenshift%2Fconsole+repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+label%3Algtm+label%3Aapproved+-label%3Ajira%2Fvalid-bug+-label%3Aqe-approved+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3Ayozaam+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=pullrequests&ref=advsearch | Story PRs without QE-Approval but has LGTM & Approval>: ${count}`;

  console.log("Posting on #forum-devconsole slack channel");

  const data = JSON.stringify({
    text: "Status report",
    blocks: [
      {
        type: "header",
        text: {
          type: "plain_text",
          text: head,
        },
      },
      {
        type: "section",
        fields: [
          {
            type: "mrkdwn",
            text: "*Current sprint status*",
          },
        ],
      },
      {
        type: "divider",
      },
      {
        type: "section",
        fields: [
          {
            type: "mrkdwn",
            text: odc_stories,
          },
          {
            type: "mrkdwn",
            text: odc_bugs,
          },
        ],
      },
      {
        type: "divider",
      },
      {
        type: "section",
        fields: [
          {
            type: "mrkdwn",
            text: "*Github status*",
          },
        ],
      },
      {
        type: "section",
        fields: [
          {
            type: "mrkdwn",
            text: github_data,
          },
          {
            type: "mrkdwn",
            text: github_data_b,
          },
          {
            type: "mrkdwn",
            text: github_data_c,
          },
          {
            type: "mrkdwn",
            text: github_data_d,
          },
        ],
      },
      {
        type: "divider",
      },
    ],
  });

  let response;
  try {
    response = await fetch(SLACK_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: data,
    });
  } catch (error) {
    console.error("Error sending requests:", error);
  }

  if (response?.ok) {
    console.log("Request sent successfully");
    return {
      statusCode: 200,
      body: "Done",
    };
  } else {
    console.error("Error sending requests:", response?.statusText);
    return {
      statusCode: response?.status,
      body: "Error",
    };
  }
};
