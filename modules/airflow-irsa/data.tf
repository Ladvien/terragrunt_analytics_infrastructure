data "aws_iam_policy_document" "airflow_misc" {

  // Kinesis
  statement {
    actions = [
      "kinesis:Get*",
      "kinesis:List*",
      "kinesis:Describe*"
    ]

    resources = [
      "*"
    ]
  }
}
