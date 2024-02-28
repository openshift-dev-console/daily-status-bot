const SLACK_URL = "";
const JIRA_AUTH = "";

const fetchCount = (apiUrl, github = false) => {
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

/* 
  FOR LOCAL DEVELOPMENT: 
     async function jira() { 
*/
export const handler = async (event) => {
  console.log("Generating Status Report");

  const head = "\nRHTAP UI";

  console.log("Fetching RHTAP stories");

  let hac_stories = "\n\n*UI Stories* :toy-story-buzz::toy-story-buzz:";

  let count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12396633"
  );

  hac_stories =
    hac_stories +
    `\n1. <https://issues.redhat.com/issues/?filter=12396633 | Stories Done> (${count})`;

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12396635"
  );

  hac_stories =
    hac_stories +
    `\n2. <https://issues.redhat.com/issues/?filter=12396635 | Stories In Review> (${count})`;

  if (count >= 15) {
    hac_stories = hac_stories + " :fire::fire:";
  }

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12396638"
  );

  hac_stories =
    hac_stories +
    `\n3. <https://issues.redhat.com/issues/?filter=12396638 | Unassigned stories:> (${count})`;

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12396637"
  );

  hac_stories =
    hac_stories +
    `\n4. <https://issues.redhat.com/issues/?filter=12396637 | Ready for pointing story:> (${count})`;

  console.log("Fetching RHTAP bugs");

  let hac_bugs = "\n\n *Bugs:* :bug::bug:";

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12396775"
  );

  hac_bugs =
    hac_bugs +
    `\n1.  <https://issues.redhat.com/issues/?filter=12396775 | QE Review > (${count})`;

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12416904"
  );

  hac_bugs =
    hac_bugs +
    `\n2. <https://issues.redhat.com/issues/?filter=12416904 | Open RHTAP UI bugs> (${count})`;

  if (count >= 45) {
    hac_bugs = hac_bugs + " :fire::fire:";
  }

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12416902"
  );

  hac_bugs =
    hac_bugs +
    `\n3. <https://issues.redhat.com/issues/?filter=12416902 | Triaged RHTAP UI bugs> (${count})`;

  if (count >= 25) {
    hac_bugs = hac_bugs + " :fire::fire:";
  }

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12416903"
  );

  hac_bugs =
    hac_bugs +
    `\n4. <https://issues.redhat.com/issues/?filter=12416903 | Needs info RHTAP UI bugs> (${count})`;

  if (count >= 25) {
    hac_bugs = hac_bugs + " :fire::fire:";
  }

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12396778"
  );

  hac_bugs =
    hac_bugs +
    `\n5. <https://issues.redhat.com/issues/?filter=12396778 | Triaged Bugs> (${count})`;

  count = await fetchCount('https://issues.redhat.com/rest/api/2/search?jql=filter=12426879')

  hac_bugs = hac_bugs + `\n6. <https://issues.redhat.com/issues/?filter=12426879 | Release pending bugs> (${count})`

  console.log("Fetching RHTAP bugs SLI data");

  let rhtap_blockers = "\n\n *RHTAP Blocker bugs:*";

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12426878"
  );

  rhtap_blockers =
    rhtap_blockers +
    `\n1. <https://issues.redhat.com/issues/?filter=12426878 | Bloker reds :alert-siren:> (${count})`;

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12426877"
  );

  rhtap_blockers =
    rhtap_blockers +
    `\n2. <https://issues.redhat.com/issues/?filter=12426877 | Bloker yellows :large_yellow_circle: > (${count})`;

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12426876"
  );

  rhtap_blockers =
    rhtap_blockers +
    `\n3. <https://issues.redhat.com/issues/?filter=12426876 | Bloker greens :green-circle: > (${count})`;

  let rhtap_critical = "\n\n *RHTAP Critical bugs:*";

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12426873"
  );

  rhtap_critical =
    rhtap_critical +
    `\n1. <https://issues.redhat.com/issues/?filter=12426873 | Critical reds :alert-siren:> (${count})`;

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12426874"
  );

  rhtap_critical =
    rhtap_critical +
    `\n2. <https://issues.redhat.com/issues/?filter=12426874 | Critical yellows :large_yellow_circle:> (${count})`;

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12426875"
  );

  rhtap_critical =
    rhtap_critical +
    `\n3. <https://issues.redhat.com/issues/?filter=12426875 | Critical greens :green-circle:> (${count})`;

  let rhtap_major = "\n\n *RHTAP Major bugs:*";

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12426870"
  );

  rhtap_major =
    rhtap_major +
    `\n1. <https://issues.redhat.com/issues/?filter=12426870 | Major reds :alert-siren:> (${count})`;

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12426871"
  );

  rhtap_major =
    rhtap_major +
    `\n2. <https://issues.redhat.com/issues/?filter=12426871 | Major yellows :large_yellow_circle:> (${count})`;

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12426872"
  );

  rhtap_major =
    rhtap_major +
    `\n3. <https://issues.redhat.com/issues/?filter=12426872 | Major greens :green-circle:> (${count})`;

  console.log("Fetching RHTAP dashboard");

  let stonesoup_dashboard = "\n\n *RHTAP Dashboard:* :clipboard::clipboard:";

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12405355"
  );

  stonesoup_dashboard =
    stonesoup_dashboard +
    `\n1. <https://issues.redhat.com/issues/?filter=12405355 | Blocked> (${count})`;

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12405357"
  );

  stonesoup_dashboard =
    stonesoup_dashboard +
    `\n2. <https://issues.redhat.com/issues/?filter=12405357 | Open stonesoup UI bugs> (${count})`;

  if (count >= 45) {
    stonesoup_dashboard = stonesoup_dashboard + " :fire::fire:";
  }

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12405358"
  );

  stonesoup_dashboard =
    stonesoup_dashboard +
    `\n3. <https://issues.redhat.com/issues/?filter=12405358 | Stonesoup UI - Needs UX> (${count})`;

  count = await fetchCount(
    "https://issues.redhat.com/rest/api/2/search?jql=filter=12405686"
  );

  stonesoup_dashboard =
    stonesoup_dashboard +
    `\n4. <https://issues.redhat.com/issues/?filter=12405686 | Untriaged Stonesoup bugs> (${count})`;

  if (count >= 45) {
    stonesoup_dashboard = stonesoup_dashboard + " :fire::fire:";
  }

  console.log("Fetching Github data");

  let github_data = "\n\n *GitHub filters:* :github: :github:";

  count = await fetchCount(
    "https://api.github.com/search/issues?q=repo%3Aopenshift%2Fhac-dev+state%3Aopen&type=issues",
    true
  );

  github_data =
    github_data +
    `\n<https://github.com/search?q=repo%3Aopenshift%2Fhac-dev+state%3Aopen&type=issues | HAC open PRs>: (${count})`;

  count = await fetchCount(
    "https://api.github.com/search/issues?q=repo%3Aopenshift%2Fhac-dev+state%3Aopen+-label%3algtm&type=issues",
    true
  );

  github_data =
    github_data +
    `\n<https://github.com/search?q=repo%3Aopenshift%2Fhac-dev+state%3Aopen+-label%3algtm&type=issues | HAC PRs without LGTM>: (${count})`;

  count = await fetchCount(
    "https://api.github.com/search/issues?q=repo%3Aopenshift%2Fhac-dev+state%3Aopen+-label%3aapproved&type=issues",
    true
  );

  github_data =
    github_data +
    `\n<https://github.com/search?q=repo%3Aopenshift%2Fhac-dev+state%3Aopen+-label%3aapproved&type=issues | HAC PRs without APPROVED>: (${count})`;

  count = await fetchCount(
    "https://api.github.com/search/issues?q=repo%3Aopenshift%2Fhac-dev+repo%3Aopenshift%2Fconsole+repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+-label%3Ado-not-merge%2Fwork-in-progress+-label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Anemesis09+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+created%3A%3C2022-06-19+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=repositories",
    true
  );

  github_data =
    github_data +
    `\n<https://github.com/search?q=repo%3Aopenshift%2Fhac-dev+repo%3Aopenshift%2Fconsole+repo%3Aopenshift%2Fenhancements+repo%3Aopenshift%2Fconsole-operator+repo%3Aopenshift%2Fapi+-label%3Ado-not-merge%2Fwork-in-progress+-label%3Algtm+author%3Arohitkrai03+author%3Adebsmita1+author%3Ajeff-phillips-18+author%3AinvincibleJai+author%3Anemesis09+author%3Asahil143+author%3Avikram-raj+author%3Achristianvogt+author%3Ajerolimov+author%3AdivyanshiGupta+author%3Arottencandy+author%3Akarthikjeeyar+author%3Aabhinandan13jan+state%3Aopen+created%3A%3C2022-06-19+author%3ALucifergene+author%3Agruselhaus+author%3Alokanandaprabhu&type=Issues&ref=advsearch&l=&l= | PRs Opened for more than 7 days>: (${count})`;

  console.log("Posting on #forum-rhtap slack channel");

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
            text: hac_stories,
          },
          {
            type: "mrkdwn",
            text: hac_bugs,
          },
        ],
      },
      {
        type: "section",
        fields: [
          {
            type: "mrkdwn",
            text: "*RHTAP Bugs SLI*",
          },
        ],
      },
      {
        type: "section",
        fields: [
          {
            type: "mrkdwn",
            text: rhtap_blockers,
          },
          {
            type: "mrkdwn",
            text: rhtap_critical,
          },
          {
            type: "mrkdwn",
            text: rhtap_major,
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
            text: stonesoup_dashboard,
          },
        ],
      },
      {
        type: "divider",
      },
      {
        type: "section",
        text: {
          type: "mrkdwn",
          text: github_data,
        },
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

/* FOR LOCAL DEVELOPMENT:

jira();

*/
