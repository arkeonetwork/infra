Helm Charts

========

Charts to deploy Arkeo stack and tools.
It is recommended to use the Makefile commands available in this repo
to start the charts with predefined configuration for most environments.

Once you have your Arkeo Node up and running, please follow instructions [here](https://github.com/ArkeoNetwork/arkeo-protocol) for the next steps.

## Requirements

- Running Kubernetes cluster
- Kubectl configured, ready and connected to running cluster
- Helm 3 (version >=3.2, can be installed using make command below)

## Running Kubernetes cluster

To get a Kubernetes cluster running, you can use the Terraform scripts [here](https://github.com/ArkeoNetwork/infra).

## Install Helm 3

Install Helm 3 if not already available on your current machine:

```bash
make helm
```

## Install Helm plugins

Install Helm plugins needed to run all the next commands properly. This includes a "diff" plugin
used to display changes between deployments.

```bash
make helm-plugins
```

## Deploy tools

To deploy all tools needed, metrics, logs management, Kubernetes Dashboard, run the command below.
This will run commands: install-prometheus, install-loki, install-metrics, install-dashboard.

```bash
make tools
```

To destroy all those resources run the command below.

```bash
make destroy-tools
```

You can install those tools separately using the sections below.

## Deploy Arkeo Node

It is important to deploy the tools first before deploying the Arkeo Node services as
some services will have metrics configuration that would fail and stop the Arkeo Node deployment.

You have multiple choices available to deploy different configurations of Arkeo Node.
You can deploy a mainnet or testnet node.
The commands deploy the umbrella chart `arkeo-stack` in the background in the Kubernetes
namespace `arkeo` (or `arkeo-testnet` for testnet) by default.

```bash
make install
```

## Arkeo Node commands

The Makefile provide different commands to help you operate your Arkeo Node.

# help

To get information and description about all the commands available through this Makefile.

```bash
make help
```

# status

TODO

```bash
make status # non-functional yet
```

# shell

Opens a shell into your `arkeo` deployment service selected:

```bash
make shell
```

# restart

Restart a Arkeo Node deployment service selected:

```bash
make restart
```

# logs

Display stream of logs of a Arkeo Node deployment selected:

```bash
make logs
```

## Destroy Arkeo Node

To fully destroy the running node and all services, run that command:

```bash
make destroy
```

## Enable/Disable Daemons

You can choose which daemons/services you want to run and which you do not. To
do so, etc. To do so, edit the following file

```bash
vim arkeo-stack/mainnet.yaml
```

Once you have done that, run the following for your changes to take effect.
```bash
make install
```

## Deploy metrics management Prometheus / Grafana stack

It is recommended to deploy a Prometheus stack to monitor your cluster
and your running services.

The metrics management is split across 2 commands: install-prometheus, install-metrics.

You can deploy the metrics management automatically using the command below:

```bash
make install-prometheus install-metrics
```

This command will deploy the prometheus chart and the metrics server files.
It can take a while to deploy all the services, usually up to 5 minutes
depending on resources running your kubernetes cluster.

You can check the services being deployed in your kubernetes namespace `prometheus-system`.

### Access Grafana

We have created a make command to automate this task to access Grafana from your
local workstation:

```bash
make grafana
```

Open http://localhost:3000 in your browser.

Login as the `admin` user. The default password should have been displayed in the previous command (`make grafana`).

To access Grafana from a remote machine, you need to modify the grafana port-forward command to allow remote connection by adding
the option `--address 0.0.0.0` at the end of the command like this:

```bash
@kubectl -n prometheus-system port-forward service/prometheus-grafana 3000:80 --address 0.0.0.0
```

### Access Prometheus admin UI

We have created a make command to automate this task to access Prometheus from your
local workstation:

```bash
make prometheus
```

Open http://localhost:9090 in your browser.

### Configure alert manager within Prometheus

Full documentation can be found here https://prometheus.io/docs/alerting/latest/configuration.
You can see an example of a slack configuration and adding prometheus rules in the file `prometheus/values.yaml`.

Once you have updated the configuration, you can update your current metrics deployment
by running the install command again:

```bash
make install-prometheus
```

You can access the alert-manager administration dashboard by running the command below:

```bash
make alert-manager
```

This dashboard will allow you to "silence" alerts for a specific period of time.

### Destroy metrics management stack

```bash
make destroy-prometheus destroy-metrics
```

## Deploy Loki logs management stack

It is recommended to deploy a logs management ingestor stack within Kubernetes to redirect all logs
within a database to keep history over time as Kubernetes automatically rotates logs after a while
to avoid filling the disks.
The default stack used within this repository is Loki, created by Grafana and open source.
To access the logs you can then use the Grafana admin interface that was deployed through the Prometheus command.

You can deploy the log management automatically using the command below:

```bash
make install-loki
```

This command will deploy the Loki chart.
It can take a while to deploy all the services, usually up to 5 minutes
depending on resources running your kubernetes cluster.

You can check the services being deployed in your kubernetes namespace `loki-system`.

### Access Grafana

See previous section to access the Grafana admin interface through the command `make grafana`.

### Browse Logs

Within the Grafana admin interface, to access the logs, find the `Explore` view from the left menu sidebar.
Once in the `Explore` view, select Loki as the source, then select the service you want to show the logs by creating a query.
The easiest way is to open the "Log browser" menu, then select the "job" label and then as value, select the service you want.
For example you can select `arkeo/sentinel` to show the logs of the Bifrost service within the default `arkeo` namespace
when deploying a mainnet validator Arkeo Node.

### Destroy Loki logs management stack

```bash
make destroy-loki
```

## Deploy Kubernetes Dashboard

You can also deploy the Kubernetes dashboard to monitor your cluster resources.

```bash
make install-dashboard
```

This command will deploy the Kubernetes dashboard chart.
It can take a while to deploy all the services, usually up to 5 minutes
depending on resources running your kubernetes cluster.

### Access Dashboard

We have created a make command to automate this task to access the Dashboard from your
local workstation:

```bash
make dashboard
```

Open http://localhost:8000 in your browser.

### Destroy Kubernetes dashboard

```bash
make destroy-dashboard
```

### Alerts

A guide for setting up Prometheus alerts can be found in [Alerting.md](./docs/Alerting.md)

## Charts available:

### Arkeo Node full stack umbrella chart

- arkeo-stack: Umbrella chart packaging all services needed to run
  a fullnode or validator Arkeo Node.

This should be the only chart used to run Arkeo Node stack unless
you know what you are doing and want to run each chart separately (not recommended).

### Arkeo Node services:

- arkeo: Arkeo Node daemon & API
- gateway: Gateway proxy to get a single IP address for multiple deployments
- sentinel: Sentinel service

### External services:

- \*-daemon: Individual chain fullnode daemons

### Tools

- prometheus: Prometheus stack for metrics
- loki: Loki stack for logs
- kubernetes-dashboard: Kubernetes dashboard

### Development

The image used for CI of this repository is found in [ci/](./ci/).

The node daemon images used in the charts here are built from [ci/images/](./ci/images).

## Troubleshooting
TODO
