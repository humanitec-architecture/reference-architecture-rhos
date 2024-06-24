# RHOS reference architecture

# Current AWS Account ID
data "aws_caller_identity" "current" {}

# User for Humanitec to access the EKS cluster


resource "humanitec_resource_definition" "k8s_namespace" {
  driver_type = "humanitec/echo"
  id          = "default-namespace"
  name        = "default-namespace"
  type        = "k8s-namespace"

  driver_inputs = {
    values_string = jsonencode({
      "namespace" = "hum-$${context.app.id}-$${context.env.id}"
    })
  }
}

resource "humanitec_resource_definition_criteria" "k8s_namespace" {
  resource_definition_id = humanitec_resource_definition.k8s_namespace.id

  force_delete = true
}

resource "humanitec_resource_definition" "rhos_dns" {
  driver_type = "humanitec/template"
  id          = "rhos-dns"
  name        = "rhos-dns"
  type        = "dns"

  driver_inputs = {
    values_string = jsonencode({
      templates = {
        outputs = <<EOL
host: $${context.app.id}-$${context.env.id}.${var.basedomain}
EOL
      }
    })
  }

  provision = {
    ingress = {
      match_dependents = false
      is_dependent     = false
    }
  }
}

resource "humanitec_resource_definition_criteria" "rhos_dns" {
  resource_definition_id = humanitec_resource_definition.rhos_dns.id
  env_type               = var.environment

  force_delete = true
}

# We need this ingress over the HT default because RHOS will only create
# the route if the ingress class is openshift_default
resource "humanitec_resource_definition" "rhos_ingress" {
  driver_type = "humanitec/ingress"
  id          = "rhos-ingress"
  name        = "rhos-ingress"
  type        = "ingress"

  driver_inputs = {
    values_string = jsonencode({
      "class"  = "openshift-default"
      "no_tls" = true
      "annotations" = {
        "route.openshift.io/termination" = "edge"
      }
    })
  }
}

resource "humanitec_resource_definition_criteria" "rhos_ingress" {
  resource_definition_id = humanitec_resource_definition.rhos_ingress.id
  env_type               = var.environment

  force_delete = true
}
