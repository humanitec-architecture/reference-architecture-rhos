# Configures the argocd-operator: https://github.com/argoproj-labs/argocd-operator

resource "kubernetes_namespace_v1" "argocd_operator" {
  metadata {
    name = "argocd-operator"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations["openshift.io/sa.scc.mcs"],
      metadata[0].annotations["openshift.io/sa.scc.supplemental-groups"],
      metadata[0].annotations["openshift.io/sa.scc.uid-range"],
    ]
  }
}


resource "kubernetes_manifest" "argocd_operator_group" {
  manifest = {
    apiVersion = "operators.coreos.com/v1"
    kind       = "OperatorGroup"
    metadata = {
      name      = "argocd-operator-54549"
      namespace = kubernetes_namespace_v1.argocd_operator.metadata[0].name
      annotations = {
        "olm.providedAPIs" = "AppProject.v1alpha1.argoproj.io,Application.v1alpha1.argoproj.io,ApplicationSet.v1alpha1.argoproj.io,ArgoCD.v1alpha1.argoproj.io,ArgoCD.v1beta1.argoproj.io,ArgoCDExport.v1alpha1.argoproj.io,NotificationsConfiguration.v1alpha1.argoproj.io"
      }
    }
    spec = {
      upgradeStrategy = "Default"
    }
  }
}

resource "kubernetes_manifest" "argocd_operator_subscription" {
  manifest = {
    apiVersion = "operators.coreos.com/v1alpha1"
    kind       = "Subscription"
    metadata = {
      name      = "argocd-operator"
      namespace = kubernetes_namespace_v1.argocd_operator.metadata[0].name
      labels = {
        "operators.coreos.com/argocd-operator.argocd-operator" = ""
      }
    }
    spec = {
      config = {
        env = [{
          name  = "ARGOCD_CLUSTER_CONFIG_NAMESPACES"
          value = "*"
        }]
      }
      channel             = "alpha"
      installPlanApproval = "Automatic"
      name                = "argocd-operator"
      source              = "community-operators"
      sourceNamespace     = "openshift-marketplace"
      startingCSV         = "argocd-operator.v0.10.0"
    }
  }
}
