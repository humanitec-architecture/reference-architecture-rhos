resource "kubernetes_namespace_v1" "rhdh_operator" {
  metadata {
    name = "rhdh-operator"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations["openshift.io/sa.scc.mcs"],
      metadata[0].annotations["openshift.io/sa.scc.supplemental-groups"],
      metadata[0].annotations["openshift.io/sa.scc.uid-range"],
    ]
  }
}


resource "kubernetes_manifest" "rhdh_operator_group" {
  manifest = {
    apiVersion = "operators.coreos.com/v1"
    kind       = "OperatorGroup"
    metadata = {
      name      = "rhdh-operator-b7vxs"
      namespace = kubernetes_namespace_v1.rhdh_operator.metadata[0].name
      annotations = {
        "olm.providedAPIs" = "Backstage.v1alpha1.rhdh.redhat.com"
      }
    }
    spec = {
      upgradeStrategy = "Default"
    }
  }
}

resource "kubernetes_manifest" "rhdh_operator_subscription" {
  manifest = {
    apiVersion = "operators.coreos.com/v1alpha1"
    kind       = "Subscription"
    metadata = {
      name      = "rhdh"
      namespace = kubernetes_namespace_v1.rhdh_operator.metadata[0].name
      labels = {
        "operators.coreos.com/rhdh.rhdh-operator" = ""
      }
    }
    spec = {
      channel             = "fast"
      installPlanApproval = "Automatic"
      name                = "rhdh"
      source              = "redhat-operators"
      sourceNamespace     = "openshift-marketplace"
    }
  }
}
