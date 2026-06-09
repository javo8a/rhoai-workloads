# rhoai-workloads

GitOps repository for MaaS **application workloads** (Argo CD sync waves 7–8): `LLMInferenceService` models and MaaS subscriptions/auth policies.

Charts live in the platform repo ([javo8a/rhoai-platform](https://github.com/javo8a/rhoai-platform)). Workload Argo CD Applications use multi-source sync: chart from platform, values from this repo via `$workloads/...` refs.

## Layout

```
clusters/{cluster}/
└── values/
    ├── llmisvc/values.yaml
    └── maas-subscriptions/values.yaml
```

## Model name contract

Model keys in `llmisvc/values.yaml` (`models:`) must match names referenced in
`maas-subscriptions/values.yaml` (`modelRefs`, `subscriptions`, `authPolicies`).

## Clusters in this repo

- `example.cluster.opentlc.com` — full simulated free/premium model set
- `cluster-6bmxk.6bmxk.sandbox5237.opentlc.com` — llmisvc models; subscriptions use chart defaults
