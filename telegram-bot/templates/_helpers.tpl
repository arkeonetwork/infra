{{/*
Expand the name of the chart.
*/}}
{{- define "telegram-bot.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "telegram-bot.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "telegram-bot.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "telegram-bot.labels" -}}
helm.sh/chart: {{ include "telegram-bot.chart" . }}
{{ include "telegram-bot.selectorLabels" . }}
app.kubernetes.io/version: {{ include "daemon.tag" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "telegram-bot.selectorLabels" -}}
app.kubernetes.io/name: {{ include "telegram-bot.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "telegram-bot.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "telegram-bot.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Tag
*/}}
{{- define "daemon.tag" -}}
    {{ .Values.image.tag | default .Chart.AppVersion }}
{{- end -}}

{{/*
Net
*/}}
{{- define "telegram-bot.net" -}}
{{- if or (eq .Values.net "mainnet") (eq .Values.net "chaosnet") -}}
CHAOSNET
{{- else -}}
TESTNET
{{- end }}
{{- end }}

{{/*
Binance-daemon
*/}}
{{- define "telegram-bot.binanceDaemon" -}}
{{- if or (eq .Values.net "mainnet") (eq .Values.net "chaosnet") -}}
{{ .Values.binanceDaemon.mainnet }}
{{- else -}}
{{ .Values.binanceDaemon.testnet }}
{{- end }}
{{- end }}

{{/*
Bitcoin-daemon
*/}}
{{- define "telegram-bot.bitcoinDaemon" -}}
{{- if or (eq .Values.net "mainnet") (eq .Values.net "chaosnet") -}}
{{ .Values.bitcoinDaemon.mainnet }}
{{- else -}}
{{ .Values.bitcoinDaemon.testnet }}
{{- end }}
{{- end }}

{{/*
Bitcoin-Cash-daemon
*/}}
{{- define "telegram-bot.bitcoinCashDaemon" -}}
{{- if or (eq .Values.net "mainnet") (eq .Values.net "chaosnet") -}}
{{ .Values.bitcoinCashDaemon.mainnet }}
{{- else -}}
{{ .Values.bitcoinCashDaemon.testnet }}
{{- end }}
{{- end }}

{{/*
Litecoin-daemon
*/}}
{{- define "telegram-bot.litecoinDaemon" -}}
{{- if or (eq .Values.net "mainnet") (eq .Values.net "chaosnet") -}}
{{ .Values.litecoinDaemon.mainnet }}
{{- else -}}
{{ .Values.litecoinDaemon.testnet }}
{{- end }}
{{- end }}

{{/*
Seed URL
*/}}
{{- define "telegram-bot.seed" -}}
{{- if or (eq .Values.net "mainnet") (eq .Values.net "chaosnet") -}}
{{ .Values.seed.mainnet }}
{{- else -}}
{{ .Values.seed.testnet }}
{{- end }}
{{- end }}
