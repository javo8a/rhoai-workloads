---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: llmisvc
  annotations:
    argocd.argoproj.io/sync-wave: "7"
spec:
  project: maas-workloads
  destination:
    name: in-cluster
    namespace: ai-models
  source:
    repoURL: ${ARGO_WORKLOADS_GIT_URL}
    targetRevision: ${ARGO_WORKLOADS_GIT_REVISION}
    path: charts/llmisvc
    helm:
      valueFiles:
        - ../../clusters/${ARGO_CLUSTER_DIR}/values/llmisvc/values.yaml
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
