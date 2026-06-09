# rhoai-workloads

Self-contained GitOps repository for MaaS **application workloads** (Argo CD sync waves 7–8): Helm charts, per-cluster values, and Argo CD Application manifests.

Platform repo ([javo8a/rhoai-platform](https://github.com/javo8a/rhoai-platform)) bootstraps a root `maas-workloads` Application that points here; all workload sync uses **this repo only**.

## Layout

```
rhoai-workloads/
├── charts/
│   ├── llmisvc/
│   └── maas-subscriptions/
├── clusters/{cluster}/values/
│   ├── llmisvc/values.yaml
│   └── maas-subscriptions/values.yaml
├── applications-templates/
├── applications/clusters/{cluster}/workloads/   # rendered
└── scripts/render-applications.sh
```

## Render Applications

After editing values for a cluster:

```bash
./scripts/render-applications.sh \
  --cluster example.cluster.opentlc.com \
  --workloads-repo https://github.com/javo8a/rhoai-workloads.git \
  --workloads-revision main
```

Commit the rendered files under `applications/clusters/{cluster}/workloads/`.

## Model name contract

Model keys in `llmisvc/values.yaml` (`models:`) must match names referenced in
`maas-subscriptions/values.yaml` (`modelRefs`, `subscriptions`, `authPolicies`).

## Clusters in this repo

- `example.cluster.opentlc.com` — full simulated free/premium model set
- `cluster-6bmxk.6bmxk.sandbox5237.opentlc.com` — llmisvc models; subscriptions use chart defaults
