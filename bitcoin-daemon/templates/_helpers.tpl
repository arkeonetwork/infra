{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "bitcoin-daemon.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bitcoin-daemon.fullname" -}}
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
{{- define "bitcoin-daemon.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "bitcoin-daemon.labels" -}}
helm.sh/chart: {{ include "bitcoin-daemon.chart" . }}
{{ include "bitcoin-daemon.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "bitcoin-daemon.selectorLabels" -}}
app.kubernetes.io/name: {{ include "bitcoin-daemon.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "bitcoin-daemon.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "bitcoin-daemon.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Net
*/}}
{{- define "bitcoin-daemon.net" -}}
{{- default .Values.net .Values.global.net -}}
{{- end -}}

{{/*
RPC Port
*/}}
{{- define "bitcoin-daemon.rpc" -}}
{{- if eq (include "bitcoin-daemon.net" .) "mainnet" -}}
    {{ .Values.service.port.mainnet.rpc}}
{{- else if eq (include "bitcoin-daemon.net" .) "stagenet" -}}
    {{ .Values.service.port.stagenet.rpc}}
{{- else -}}
    {{ .Values.service.port.testnet.rpc }}
{{- end -}}
{{- end -}}

{{/*
P2P Port
*/}}
{{- define "bitcoin-daemon.p2p" -}}
{{- if eq (include "bitcoin-daemon.net" .) "mainnet" -}}
    {{ .Values.service.port.mainnet.p2p}}
{{- else if eq (include "bitcoin-daemon.net" .) "stagenet" -}}
    {{ .Values.service.port.stagenet.p2p}}
{{- else -}}
    {{ .Values.service.port.testnet.p2p }}
{{- end -}}
{{- end -}}
