{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "elasticsearch-exporter.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "elasticsearch-exporter.fullname" -}}
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
{{- define "elasticsearch-exporter.chart" -}}
{{- if .Values.fullnameOverride -}}
{{- printf "%s-%s" .Values.fullnameOverride .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define ".chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define ".chart.image" -}}
  {{ if eq ((printf "%T" .Values.image.tag )) "float64" }}
    {{- printf "%s/%s:%.f" .Values.image.registry .Chart.Name .Values.image.tag | trimSuffix "-" -}}
  {{ else }}
    {{- printf "%s/%s:%s" .Values.image.registry .Chart.Name .Values.image.tag | trimSuffix "-" -}}
  {{ end }}
{{- end -}}

{{- define ".chart.depName" -}}
    {{- if or (eq .Values.env "canary") (eq .Values.env "production") -}}
      {{- if eq ((printf "%T" .Values.git.sha )) "float64" -}}
        {{ printf "%s-%.f" .Chart.Name .Values.git.sha }}
      {{- else -}}
        {{ printf "%s-%s" .Chart.Name .Values.git.sha }}
      {{- end -}}
    {{- else -}}
        {{ .Chart.Name }}
    {{- end -}}
{{- end -}}

{{- define ".chart.dns" -}}
{{- printf "%s" .Chart.Name | replace "-" "" -}}.coralogix.com
{{- end -}}

{{- define ".chart.serviceName" -}}
{{ .Chart.Name }}-service
{{- end -}}

{{- define ".chart.servicePort" -}}
    {{- if .Values.service.port -}}
        {{- .Values.service.port -}}
    {{- else -}}
        {{- .Values.network.port -}}
    {{- end -}}
{{- end -}}

{{- define ".chart.serviceAccount.name" -}}
    {{- if .Values.serviceAccount.name -}}
        {{- .Values.serviceAccount.name -}}
    {{- else -}}
        {{- .Chart.Name -}}-service-account
    {{- end -}}
{{- end -}}

{{- define "sha" -}}
  {{ if eq ((printf "%T" .Values.git.sha )) "float64" }}
   {{- printf "%.f" .Values.git.sha -}}
  {{ else }}
   {{- printf "%s" .Values.git.sha -}}
  {{ end }}
{{- end }}

{{- define ".chart.heapSize" -}}
  {{- div .Values.resources.memoryMb .Values.resources.heapSizeRatio -}}
{{- end -}}
