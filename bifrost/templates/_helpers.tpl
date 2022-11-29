{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "bifrost.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bifrost.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "bifrost.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "bifrost.labels" -}}
helm.sh/chart: {{ include "bifrost.chart" . }}
{{ include "bifrost.selectorLabels" . }}
app.kubernetes.io/version: {{ include "bifrost.tag" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "bifrost.selectorLabels" -}}
app.kubernetes.io/name: {{ include "bifrost.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "bifrost.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "bifrost.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Net
*/}}
{{- define "bifrost.net" -}}
{{- default .Values.net .Values.global.net -}}
{{- end -}}

{{/*
Tag
*/}}
{{- define "bifrost.tag" -}}
{{- coalesce  .Values.global.tag .Values.image.tag .Chart.AppVersion -}}
{{- end -}}

{{/*
Image
*/}}
{{- define "bifrost.image" -}}
{{- if or (eq (include "bifrost.net" .) "mocknet") (eq (include "bifrost.net" .) "testnet") -}}
{{- .Values.image.repository -}}:{{ include "bifrost.tag" . }}
{{- else -}}
{{- .Values.image.repository -}}:{{ include "bifrost.tag" . }}@sha256:{{ coalesce .Values.global.hash .Values.image.hash }}
{{- end -}}
{{- end -}}

{{/*
Thor daemon
*/}}
{{- define "bifrost.thorDaemon" -}}
{{- if eq (include "bifrost.net" .) "mainnet" -}}
    {{ .Values.thorDaemon.mainnet }}
{{- else if eq (include "bifrost.net" .) "stagenet" -}}
    {{ .Values.thorDaemon.stagenet }}
{{- else -}}
    {{ .Values.thorDaemon.testnet }}
{{- end -}}
{{- end -}}

{{/*
Binance daemon
*/}}
{{- define "bifrost.binanceDaemon" -}}
{{- if eq (include "bifrost.net" .) "mainnet" -}}
    {{ .Values.binanceDaemon.mainnet }}
{{- else if eq (include "bifrost.net" .) "stagenet" -}}
    {{ .Values.binanceDaemon.stagenet }}
{{- else -}}
    {{ default .Values.binanceDaemon.testnet .Values.global.binanceDaemon }}
{{- end -}}
{{- end -}}

{{/*
Bitcoin
*/}}
{{- define "bifrost.bitcoinDaemon" -}}
{{- if eq (include "bifrost.net" .) "mainnet" -}}
    {{ .Values.bitcoinDaemon.mainnet }}
{{- else if eq (include "bifrost.net" .) "stagenet" -}}
    {{ .Values.bitcoinDaemon.stagenet }}
{{- else if eq (include "bifrost.net" .) "testnet" -}}
    {{ .Values.bitcoinDaemon.testnet }}
{{- else -}}
    {{ .Values.bitcoinDaemon.mocknet }}
{{- end -}}
{{- end -}}

{{/*
Bitcoin Cash
*/}}
{{- define "bifrost.bitcoinCashDaemon" -}}
{{- if eq (include "bifrost.net" .) "mainnet" -}}
    {{ .Values.bitcoinCashDaemon.mainnet }}
{{- else if eq (include "bifrost.net" .) "stagenet" -}}
    {{ .Values.bitcoinCashDaemon.stagenet }}
{{- else if eq (include "bifrost.net" .) "testnet" -}}
    {{ .Values.bitcoinCashDaemon.testnet }}
{{- else -}}
    {{ .Values.bitcoinCashDaemon.mocknet }}
{{- end -}}
{{- end -}}

{{/*
Litecoin
*/}}
{{- define "bifrost.litecoinDaemon" -}}
{{- if eq (include "bifrost.net" .) "mainnet" -}}
    {{ .Values.litecoinDaemon.mainnet }}
{{- else if eq (include "bifrost.net" .) "stagenet" -}}
    {{ .Values.litecoinDaemon.stagenet }}
{{- else if eq (include "bifrost.net" .) "testnet" -}}
    {{ .Values.litecoinDaemon.testnet }}
{{- else -}}
    {{ .Values.litecoinDaemon.mocknet }}
{{- end -}}
{{- end -}}

{{/*
Dogecoin
*/}}
{{- define "bifrost.dogecoinDaemon" -}}
{{- if eq (include "bifrost.net" .) "mainnet" -}}
    {{ .Values.dogecoinDaemon.mainnet }}
{{- else if eq (include "bifrost.net" .) "stagenet" -}}
    {{ .Values.dogecoinDaemon.stagenet }}
{{- else if eq (include "bifrost.net" .) "testnet" -}}
    {{ .Values.dogecoinDaemon.testnet }}
{{- else -}}
    {{ .Values.dogecoinDaemon.mocknet }}
{{- end -}}
{{- end -}}

{{/*
Terra
*/}}
{{- define "bifrost.terraDaemon" -}}
{{- if eq (include "bifrost.net" .) "mainnet" -}}
    {{ .Values.terraDaemon.mainnet }}
{{- else if eq (include "bifrost.net" .) "stagenet" -}}
    {{ .Values.terraDaemon.stagenet }}
{{- else if eq (include "bifrost.net" .) "testnet" -}}
    {{ .Values.terraDaemon.testnet }}
{{- else -}}
    {{ .Values.terraDaemon.mocknet }}
{{- end -}}
{{- end -}}

{{/*
Gaia
*/}}
{{- define "bifrost.gaiaDaemon" -}}
{{- index (index .Values.gaiaDaemon (include "bifrost.net" .)) "rpc" -}}
{{- end -}}
{{- define "bifrost.gaiaDaemonGRPC" -}}
{{- index (index .Values.gaiaDaemon (include "bifrost.net" .)) "grpc" -}}
{{- end -}}
{{- define "bifrost.gaiaDaemonGRPCTLS" -}}
{{- index (index .Values.gaiaDaemon (include "bifrost.net" .)) "grpcTLS" -}}
{{- end -}}

{{/*
Ethereum
*/}}
{{- define "bifrost.ethereumDaemon" -}}
{{ index .Values.ethereumDaemon (include "bifrost.net" .) }}
{{- end -}}

{{/*
Avalanche
*/}}
{{- define "bifrost.avaxDaemon" -}}
{{ index .Values.avaxDaemon (include "bifrost.net" .) }}
{{- end -}}

{{/*
chainID
*/}}
{{- define "bifrost.chainID" -}}
{{- if eq (include "bifrost.net" .) "mainnet" -}}
    {{ .Values.chainID.mainnet }}
{{- else if eq (include "bifrost.net" .) "stagenet" -}}
    {{ .Values.chainID.stagenet }}
{{- else -}}
    {{ .Values.chainID.testnet }}
{{- end -}}
{{- end -}}
