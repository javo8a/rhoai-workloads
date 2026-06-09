#!/usr/bin/env bash
# Render workload Argo CD Application manifests for a cluster.
#
# Usage:
#   ./scripts/render-applications.sh \
#     --cluster example.cluster.opentlc.com \
#     --workloads-repo https://github.com/javo8a/rhoai-workloads.git \
#     --workloads-revision main \
#     --argocd-namespace openshift-gitops
#
# Outputs:
#   applications/clusters/{cluster}/maas-workloads.yaml
#   applications/clusters/{cluster}/workloads/

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

ARGO_CLUSTER_DIR=""
ARGO_WORKLOADS_GIT_URL=""
ARGO_WORKLOADS_GIT_REVISION="main"
ARGOCD_NAMESPACE="openshift-gitops"

usage() {
  sed -n '2,12p' "$0"
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --cluster) ARGO_CLUSTER_DIR="$2"; shift 2 ;;
    --workloads-repo) ARGO_WORKLOADS_GIT_URL="$2"; shift 2 ;;
    --workloads-revision) ARGO_WORKLOADS_GIT_REVISION="$2"; shift 2 ;;
    --argocd-namespace) ARGOCD_NAMESPACE="$2"; shift 2 ;;
    -h|--help) usage ;;
    *) echo "Unknown option: $1" >&2; usage ;;
  esac
done

if [[ -z "${ARGO_CLUSTER_DIR}" || -z "${ARGO_WORKLOADS_GIT_URL}" ]]; then
  echo "Error: --cluster and --workloads-repo are required." >&2
  usage
fi

if [[ ! -d "${REPO_ROOT}/clusters/${ARGO_CLUSTER_DIR}/values" ]]; then
  echo "Error: cluster values not found: clusters/${ARGO_CLUSTER_DIR}/values" >&2
  exit 1
fi

render_template() {
  local src="$1"
  local dest="$2"
  sed \
    -e "s|\${ARGO_CLUSTER_DIR}|${ARGO_CLUSTER_DIR}|g" \
    -e "s|\${ARGO_WORKLOADS_GIT_URL}|${ARGO_WORKLOADS_GIT_URL}|g" \
    -e "s|\${ARGO_WORKLOADS_GIT_REVISION}|${ARGO_WORKLOADS_GIT_REVISION}|g" \
    -e "s|\${ARGOCD_NAMESPACE}|${ARGOCD_NAMESPACE}|g" \
    "${src}" > "${dest}"
}

CLUSTER_OUT="${REPO_ROOT}/applications/clusters/${ARGO_CLUSTER_DIR}"
WORKLOADS_OUT="${CLUSTER_OUT}/workloads"
mkdir -p "${WORKLOADS_OUT}"

for tpl in "${REPO_ROOT}"/applications-templates/llmisvc.yaml.tpl \
           "${REPO_ROOT}"/applications-templates/maas-subscriptions.yaml.tpl; do
  base="$(basename "${tpl}" .tpl)"
  render_template "${tpl}" "${WORKLOADS_OUT}/${base}"
done

render_template "${REPO_ROOT}/applications-templates/maas-workloads.yaml.tpl" \
  "${CLUSTER_OUT}/maas-workloads.yaml"

echo "Rendered workload Applications for cluster: ${ARGO_CLUSTER_DIR}"
echo "  Root app-of-apps:     applications/clusters/${ARGO_CLUSTER_DIR}/maas-workloads.yaml"
echo "  Child apps:           applications/clusters/${ARGO_CLUSTER_DIR}/workloads/"
