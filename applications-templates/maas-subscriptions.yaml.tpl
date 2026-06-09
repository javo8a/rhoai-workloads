---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: maas-subscriptions
  annotations:
    argocd.argoproj.io/sync-wave: "8"
spec:
  project: maas-workloads
  destination:
    name: in-cluster
    namespace: models-as-a-service
  source:
    repoURL: ${ARGO_WORKLOADS_GIT_URL}
    targetRevision: ${ARGO_WORKLOADS_GIT_REVISION}
    path: charts/maas-subscriptions
    helm:
      valueFiles:
        - ../../clusters/${ARGO_CLUSTER_DIR}/values/maas-subscriptions/values.yaml
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
