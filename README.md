# Daily Status Bot for Slack

This bot helps to fetch data from Jira and GitHub and post it on Slack daily at a certain time for various projects.

For each project, there are separate directories created. In each directory, there is a Bash Script, which is executed as a cron job using GitHub Actions. You can refer the respective Actions workflow in the `.github/workflows` directory.

**To add this bot in a new channel/project:**
1. Create a new directory
2. Place the Bash script inside the directory
3. Add the Slack Webhook & Jira PAT in the Actions Repository Secret
4. Create an Actions workflow file for the new project/channel and reference the secrets. 

Note: The Actions Workflow remain same for all bots. Only the names, secret_refs and directories have to be updated.

### Projects currently monitored:
- Openshift Developer Console
- Konflux
- Backstage

### Installed Slack Channels

- #forum-devconsole
- #team-backstage 
- #forum-konflux-ui 




