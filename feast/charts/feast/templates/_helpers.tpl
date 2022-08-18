{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{ end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{ else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{ else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{ end -}}
{{ end -}}
{{ end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "chart" }}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{ end -}}

{{/*
Common labels
*/}}
{{- define "labels" -}}
helm.sh/chart: {{ include "chart" . -}}
app.kubernetes.io/name: {{ include "name" . -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: feast
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ end -}}

{{- define "isLocalPath" -}}
{{- $isLocalPath := or (not (hasPrefix "gs://" .Values.global.featureStore.registry.path)) (not (hasPrefix "s3://" .Values.global.featureStore.registry.path)) }}
{{- $isLocalPath -}}
{{ end -}}

{{- define "getLocalPath" -}}
{{- $registryPath := printf "/etc/feast-registry/%s/%s" .Values.global.featureStore.project .Values.global.featureStore.registry.path }}
{{- if isAbs .Values.global.featureStore.registry.path }}
{{- $registryPath = .Values.global.featureStore.registry.path }}
{{- end }}
{{- $registryPath -}}
{{ end -}}
