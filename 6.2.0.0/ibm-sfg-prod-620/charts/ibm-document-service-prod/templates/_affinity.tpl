# (C) Copyright 2023 Syncsort Incorporated. All rights reserved.

{{- define "documentSvc.nodeaffinity.onlyArch" }}
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
    {{- include "documentSvc.nodeAffinityRequiredDuringScheduling" . }}
{{- end }}

{{- define "documentSvc.nodeAffinityRequiredDuringScheduling" }}
      nodeSelectorTerms:
      - matchExpressions:
      {{- include "documentSvc.nodeAffinityArchRequired.matchExpressions" . | indent 8}}
{{- end }}



/*
  Apply the architecture nodeAffinity matchExpression to each of the matchExpressions provided in values.yaml.
*/
{{- define "documentSvc.nodeAffinity" }}
{{- $rootCtx := index . 0 }}
{{- $currNodeAffinity := index . 1 }}
{{- $archRequiredMatchExpressions := include "documentSvc.nodeAffinityArchRequired.matchExpressions" $rootCtx }}
nodeAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
    nodeSelectorTerms:
    {{- if and ( $currNodeAffinity ) ( $currNodeAffinity.requiredDuringSchedulingIgnoredDuringExecution) }}
      {{- $nodeSelectorTerms := $currNodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms | default list }}
      {{- if gt (len $nodeSelectorTerms) 0  }}
        {{- range $nodeSelectorTerms }}
          {{- $nodeSelectorTerm := . }}
    - matchExpressions:
          {{- $archRequiredMatchExpressions | indent 6 }}
          {{- $matchExpressions := $nodeSelectorTerm.matchExpressions | default list }}
          {{- if gt (len $matchExpressions) 0 }}
{{ toYaml $nodeSelectorTerm.matchExpressions | indent 6 }}
          {{- end }}
        {{- end }}
      {{- else }}
    - matchExpressions:
      {{- $archRequiredMatchExpressions | indent 6 }}
      {{- end }}
    {{- else }}
    - matchExpressions:
      {{- $archRequiredMatchExpressions | indent 6 }}
    {{- end }}
  preferredDuringSchedulingIgnoredDuringExecution:
  {{- $preferDuringSchIgnoreDuringExec := $currNodeAffinity.preferredDuringSchedulingIgnoredDuringExecution | default list }}
  {{- if gt ( len $preferDuringSchIgnoreDuringExec ) 0 }}
{{ toYaml $preferDuringSchIgnoreDuringExec | indent 2 }}
  {{- end }}
{{- end }}


/*
 matchExpression for nodeAffinity based on architecture
*/
{{- define "documentSvc.nodeAffinityArchRequired.matchExpressions" }}
- key: kubernetes.io/arch
  operator: In
  values:
{{- range $key, $val := .Values.arch }}
  {{- if gt ($val | trunc 1 | int) 0 }}
  - {{ $key }}
  {{- end }}
{{- end }}
{{- end }}

/* Architecture Affinity
*/
{{- define "documentSvc.architectureAffinity" }}
nodeAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
    nodeSelectorTerms:
    - matchExpressions:
    {{- include "documentSvc.nodeAffinityArchRequired.matchExpressions" . | indent 8}}
{{- end }}


/*
  Pod affinity
*/
{{- define "documentSvc.podAffinity" }}
{{- $rootCtx := index . 0 }}
{{- $currpodAffinity := index . 1 }}
podAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
  {{- $requiredDuringSchedulingIgnoredDuringExecution := $currpodAffinity.requiredDuringSchedulingIgnoredDuringExecution | default list }}
  {{- if gt ( len $requiredDuringSchedulingIgnoredDuringExecution ) 0 }}
{{ toYaml $requiredDuringSchedulingIgnoredDuringExecution | indent 2 }}
  {{- end }}  
  preferredDuringSchedulingIgnoredDuringExecution:
  {{- $preferDuringSchIgnoreDuringExec := $currpodAffinity.preferredDuringSchedulingIgnoredDuringExecution | default list }}
  {{- if gt ( len $preferDuringSchIgnoreDuringExec ) 0 }}
{{ toYaml $preferDuringSchIgnoreDuringExec | indent 2 }}
  {{- end }}
{{- end }}


/* Pod Anti Affinity

*/
{{- define "documentSvc.podAntiAffinity" }}
{{- $rootCtx := index . 0 }}
{{- $currpodAntiAffinity := index . 1 }}
podAntiAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
  {{- $requiredDuringSchedulingIgnoredDuringExecution := $currpodAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution | default list }}
  {{- if gt ( len $requiredDuringSchedulingIgnoredDuringExecution ) 0 }}
{{ toYaml $requiredDuringSchedulingIgnoredDuringExecution | indent 2 }}
  {{- end }}  
  preferredDuringSchedulingIgnoredDuringExecution:
  {{- $preferDuringSchIgnoreDuringExec := $currpodAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution | default list }}
  {{- if gt ( len $preferDuringSchIgnoreDuringExec ) 0 }}
{{ toYaml $preferDuringSchIgnoreDuringExec | indent 2 }}
  {{- end }}
{{- end }}







