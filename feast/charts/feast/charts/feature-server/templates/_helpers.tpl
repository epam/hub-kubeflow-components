{{/* vim: set filetype=mustache: */}}

{{/*
Feature server labels
*/}}
{{- define "feature-server.labels" -}}
{{ include "labels" . -}}
app.kubernetes.io/component: feature-server
{{ end -}}
