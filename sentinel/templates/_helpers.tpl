{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "sentinel.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sentinel.fullname" -}}
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
{{- define "sentinel.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "sentinel.labels" -}}
helm.sh/chart: {{ include "sentinel.chart" . }}
{{ include "sentinel.selectorLabels" . }}
app.kubernetes.io/version: {{ include "sentinel.tag" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "sentinel.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sentinel.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "sentinel.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "sentinel.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Net
*/}}
{{- define "sentinel.net" -}}
{{- default .Values.net .Values.global.net -}}
{{- end -}}

{{/*
Tag
*/}}
{{- define "sentinel.tag" -}}
{{- coalesce  .Values.global.tag .Values.image.tag .Chart.AppVersion -}}
{{- end -}}

{{/*
Image
*/}}
{{- define "sentinel.image" -}}
{{- if or (eq (include "sentinel.net" .) "mocknet") (eq (include "sentinel.net" .) "testnet") -}}
{{- .Values.image.repository -}}:{{ include "sentinel.tag" . }}
{{- else -}}
{{- .Values.image.repository -}}:{{ include "sentinel.tag" . }}@sha256:{{ coalesce .Values.global.hash .Values.image.hash }}
{{- end -}}
{{- end -}}

{{/*
Arkeo daemon
*/}}
{{- define "sentinel.arkeoDaemon" -}}
{{- if eq (include "sentinel.net" .) "mainnet" -}}
    {{ .Values.arkeoDaemon.mainnet }}
{{- else if eq (include "sentinel.net" .) "stagenet" -}}
    {{ .Values.arkeoDaemon.stagenet }}
{{- else -}}
    {{ .Values.arkeoDaemon.testnet }}
{{- end -}}
{{- end -}}

{{/*
chainID
*/}}
{{- define "sentinel.chainID" -}}
{{- if eq (include "sentinel.net" .) "mainnet" -}}
    {{ .Values.chainID.mainnet }}
{{- else if eq (include "sentinel.net" .) "stagenet" -}}
    {{ .Values.chainID.stagenet }}
{{- else -}}
    {{ .Values.chainID.testnet }}
{{- end -}}
{{- end -}}
