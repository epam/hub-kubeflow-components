{{/* vim: set filetype=mustache: */}}
{{/*
Transformation service labels
*/}}
{{- define "transformation-service.labels" -}}
{{ include "labels" . -}}
app.kubernetes.io/component: transformation-service
{{ end -}}

