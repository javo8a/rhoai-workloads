# rhoai-workloads

Self-contained GitOps repository for MaaS **application workloads**: Helm charts, per-cluster values, and all Argo CD Application manifests (root app + child apps).

## Layout

```
rhoai-workloads/
├── charts/
│   ├── llmisvc/
│   └── maas-subscriptions/
├── clusters/{cluster}/values/
├── applications/clusters/{cluster}/
│   ├── maas-workloads.yaml              # root app-of-apps (apply to Argo CD)
│   └── workloads/
│       ├── llmisvc.yaml
│       └── maas-subscriptions.yaml
├── applications-templates/
└── scripts/render-applications.sh
```

## Render Applications

```bash
./scripts/render-applications.sh \
  --cluster example.cluster.opentlc.com \
  --workloads-repo https://github.com/javo8a/rhoai-workloads.git \
  --workloads-revision main \
  --argocd-namespace openshift-gitops
```

## Bootstrap (after platform sync is healthy)

Apply the root Application to the GitOps namespace:

```bash
oc apply -f applications/clusters/example.cluster.opentlc.com/maas-workloads.yaml -n openshift-gitops
```

Or create it in the Argo CD UI from the same manifest. The `maas-workloads` Application syncs `llmisvc` and `maas-subscriptions` child apps from this repo.

## Model name contract

Model keys in `llmisvc/values.yaml` (`models:`) must match names referenced in
`maas-subscriptions/values.yaml` (`modelRefs`, `subscriptions`, `authPolicies`).

## Clusters in this repo

- `example.cluster.opentlc.com` — full simulated free/premium model set
- `cluster-6bmxk.6bmxk.sandbox5237.opentlc.com` — llmisvc models; subscriptions use chart defaults
- `cluster-8h7g4.8h7g4.sandbox966.opentlc.com` — llmisvc models; subscriptions use chart defaults
