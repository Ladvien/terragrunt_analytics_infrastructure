module "iam_assumable_role_airflow" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> v2.6.0"
  create_role                   = true
  role_name                     = "${var.cluster_name}-airflow"
  provider_url                  = replace(module.eks_cluster.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.airflow_misc.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.airflow_namespace}:${var.airflow_sa_name}"]
}

resource "aws_iam_policy" "airflow_misc" {
  path        = "/airflow/"
  name        = "MiscelaneousAccess"
  description = "EKS airflow policy for cluster ${var.cluster_name}"
  policy      = data.aws_iam_policy_document.airflow_misc.json
}
