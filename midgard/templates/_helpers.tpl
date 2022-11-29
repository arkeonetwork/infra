{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "midgard.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "midgard.fullname" -}}
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
{{- define "midgard.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "midgard.labels" -}}
helm.sh/chart: {{ include "midgard.chart" . }}
{{ include "midgard.selectorLabels" . }}
app.kubernetes.io/version: {{ include "daemon.tag" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "midgard.selectorLabels" -}}
app.kubernetes.io/name: {{ include "midgard.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "midgard.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "midgard.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Tag
*/}}
{{- define "daemon.tag" -}}
{{ .Values.image.tag | default .Chart.AppVersion }}
{{- end -}}

{{/*
Net
*/}}
{{- define "midgard.net" -}}
{{- default .Values.net .Values.global.net -}}
{{- end -}}

{{/*
Thor daemon
*/}}
{{- define "midgard.thorDaemon" -}}
{{- if eq (include "midgard.net" .) "mainnet" -}}
    {{ .Values.thorDaemon.mainnet }}
{{- else if eq (include "midgard.net" .) "stagenet" -}}
    {{ .Values.thorDaemon.stagenet }}
{{- else -}}
    {{ .Values.thorDaemon.testnet }}
{{- end -}}
{{- end -}}
