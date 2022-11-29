# Alerting

Here is a (brief) walkthrough for setting up Prometheus alerts.

## Create Service Accounts

We're going to be using three different services:

    (1) PagerDuty
    (2) DeadMan'sSnitch
    (3) Slack

PagerDuty can be used to coordinate any response to alerts, DeadMan'sSnitch will be used to monitor the Prometheus Watchdog, and Slack will be used to log everything.

### Slack

Set up a Slack account.

1. Go to https://slack.com
2. "Try For Free" in the upper-right-hand corner.
3. "Create a Slack Workspace"
4. Enter your email.
5. Enter the code they just sent to your email.
6. Enter a name for your Slack workspace (team name or whatever.)
7. Enter something describing what your team is working on (it will be the channel name, e.g., "monitoring".)
8. Send other team members an invite if you want.

Next, you need to create a simple "app."

9. Open another window, go to https://api.slack.com
10. "Start Building"
11. Give your app a name associated with the cluster name. (E.g., "nodemon3")
12. Select your "Development Slack Workspace" to be the Slack workspace you just created in steps 3 -- 8.
13. Select Add features and functionality "Incoming Webhooks."
14. Activate Incoming Webhooks (set to On.)
15. "Add New Webhook to Workspace"
16. Select the channel you created in step 7. Click "Allow."
17. Copy the Webhook URL just created, you'll need this later.

### PagerDuty

1. Go to https://pagerduty.com.
2. Select "Get Started" in the upper-right-hand corner.
3. Give them a name, email, password and organization name. (Mobile number is optional, although you'll probably give them one eventually. You'll also probably start paying them after your free trial, so you may as well give them your real name.) Select "Get Started."
4. "Welcome to PagerDuty!" Select "Begin Setup."
5. Name the service we're getting alerts from; associate it with the cluster name.
6. We'll add Prometheus on the "Add integrations" page. Select the "All" tab, search for "Prometheus," select "Prometheus" and then "Continue."
7. Go ahead and try out an incident. Add your mobile number if you want to be called and texted with alerts. You can also connect a Slack channel here so that alerts are sent to the channel you configure. Go ahead and connect the Slack channel we created above.
8. Select "Services" -> "Service Directory" from the top menu.
9. Select the service we named in step 5.
10. Select "Integrations" from the menu.
11. Copy the "Integration Key" for Prometheus.

### DeadMan'sSnitch

Set up a DeadMan'sSnitch account.

1. Go to https://deadmanssnitch.com
2. "Sign Up" in upper-right-hand corner.
3. Enter in your info, "Create Account." You're probably going to be paying them, so go ahead and give them real information.
4. "Choose a plan for your new Case." You're going to want to at least select the plan with 3 snitches. You can have one snitch on the free plan, but you won't get the PagerDuty integration and you can't use the shorter timeouts, so you should probably just pay for a plan.
5. Enter card information and "Complete Setup."
6. Create a New Snitch. Give it a name associated with the cluster name, leave the Alert Type as Basic, and select "15 Minute" Intervals. "Save." ("Hour" Intervals if you are on the free plan.)
7. Copy the Unique Snitch URL, you'll need this later.

Go to your main page (click your case in the upper left-hand corner.) Select "Integrations." Add the PagerDuty integration. (Basically login to PagerDuty and authorize it.)

## Configure Prometheus

### Edit prometheus/values.yaml

If you are only using PagerDuty and DeadMan's Snitch you can use the optional convenience target to update the configuration:

```bash
make set-monitoring
```

Alternatively, you man manually perform the following:

- Remove the "# " from the start of lines 100 - 149.
- On line 104, replace "XXX Insert Slack API here XXX" with the Slack Webhook URL from the Slack setup step 17.
- On line 119, replace "XXX Insert Dead Man's Snitch URL here XXX" with the Unique Snitch URL from the DeadMan'sSnitch setup step 7.
- On line 122, replace "XXX Insert PagerDuty Integration Key here XXX" with the PagerDuty Integration Key for Prometheus, from step 11 in the PagerDuty setp.
- On line 125, replace "XXX Insert Slack Channel here XXX" with the Slack channel name, step 7 in the Slack setup.

### Install prometheus/values.yaml

```bash
make install-prometheus
```

Check the logs and make sure there were no errors.

```bash
kubectl -n prometheus-system logs statefulset/alertmanager-prometheus-kube-prometheus-alertmanager
```
