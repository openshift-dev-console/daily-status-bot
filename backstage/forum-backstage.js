
const SLACK_URL = ''
const JIRA_AUTH = ''

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

const getPreviousDate = () => {
  const currentDate = new Date();
  currentDate.setDate(currentDate.getDate() - 7);
  const previousDate = currentDate.toISOString().split("T")[0];

  return previousDate;
};

/* 
  FOR LOCAL DEVELOPMENT: 
     async function jira() { 
*/
export const handler = async (event) => {
  console.log("Generating Status Report");

  const head = "\nGitHub Status report";

  const previousDate = getPreviousDate();

  console.log("Fetching github data");

  /* janus-idp/backstage-showcase */
  let repoName = "janus-idp/backstage-showcase";

  let count = await fetchCount(
    `https://api.github.com/search/issues?q=repo:${repoName}+state%3Aopen+type%3Apr`,
    true
  );
  let github_data_a = `\n<https://github.com/search?l=&q=repo:${repoName}+state%3Aopen+type%3Apr | Total open PRs>:  ${count}`;

  let apiURL = `https://api.github.com/search/issues?q=repo:${repoName}+state:open+type:pr+created:<${previousDate}&type=Issues`;

  count = await fetchCount(apiURL, true);
  github_data_a =
    github_data_a +
    `\n<https://github.com/search?q=repo:${repoName}+state:open+type:pr+created%3A%3C${previousDate}&type=Issues | PRs opened for more than a week>: ${count}`;

  /* janus-idp/backstage-plugins */
  repoName = "janus-idp/backstage-plugins";

  count = await fetchCount(
    `https://api.github.com/search/issues?q=repo:${repoName}+state%3Aopen+type%3Apr`,
    true
  );
  let github_data_b = `\n<https://github.com/search?l=&q=repo:${repoName}+state%3Aopen+type%3Apr | Total open PRs>:  ${count}`;

  repoName = "janus-idp/backstage-plugins";
  apiURL = `https://api.github.com/search/issues?q=repo:${repoName}+state:open+type:pr+created:<${previousDate}&type=Issues`;

  count = await fetchCount(apiURL, true);
  github_data_b =
    github_data_b +
    `\n<https://github.com/search?q=repo:${repoName}+state:open+type:pr+created%3A%3C${previousDate}&type=Issues | PRs opened for more than a week>:  ${count}`;

  /* janus-idp/operator */
  repoName = "janus-idp/operator";

  count = await fetchCount(
    `https://api.github.com/search/issues?q=repo:${repoName}+state%3Aopen+type%3Apr`,
    true
  );
  let github_data_d = `\n<https://github.com/search?l=&q=repo:${repoName}+state%3Aopen+type%3Apr | Total open PRs>:  ${count}`;

  apiURL = `https://api.github.com/search/issues?q=repo:${repoName}+state:open+type:pr+created:<${previousDate}&type=Issues`;

  count = await fetchCount(apiURL, true);
  github_data_d =
    github_data_d +
    `\n<https://github.com/search?q=repo:${repoName}+state:open+type:pr+created%3A%3C${previousDate}&type=Issues | PRs opened for more than a week>:  ${count}`;

  /* janus-idp/janus-idp.github.io */
  repoName = "janus-idp/janus-idp.github.io";

  count = await fetchCount(
    `https://api.github.com/search/issues?q=repo:${repoName}+state%3Aopen+type%3Apr`,
    true
  );
  let github_data_c = `\n<https://github.com/search?q=repo:${repoName}+state%3Aopen+type%3Apr | Total open PRs>:  ${count}`;

  apiURL = `https://api.github.com/search/issues?q=repo:${repoName}+state:open+type:pr+created:<${previousDate}&type=Issues`;

  count = await fetchCount(apiURL, true);
  github_data_c =
    github_data_c +
    `\n<https://github.com/search?q=repo:${repoName}+state:open+type:pr+created%3A%3C${previousDate}&type=Issues | PRs opened for more than a week>:  ${count}`;

  console.log("Posting on #forum-backstage slack channel");

  const data = JSON.stringify({
    text: "GitHub Status report",
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
            text: "*backstage-showcase*",
          },
        ],
      },
      {
        type: "section",
        fields: [
          {
            type: "mrkdwn",
            text: github_data_a,
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
            text: "*backstage-plugins*",
          },
        ],
      },
      {
        type: "section",
        fields: [
          {
            type: "mrkdwn",
            text: github_data_b,
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
            text: "*janus-idp.github.io*",
          },
        ],
      },
      {
        type: "section",
        fields: [
          {
            type: "mrkdwn",
            text: github_data_c,
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
            text: "*operator*",
          },
        ],
      },
      {
        type: "section",
        fields: [
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

/* FOR LOCAL DEVELOPMENT:

jira();

*/
