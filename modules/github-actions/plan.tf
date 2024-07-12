locals {
  plan_role_name = var.plan.role_name != null ? var.plan.role_name : "${split("/", var.repository)[1]}-plan"
}

resource "aws_iam_role" "plan" {
  count              = var.plan.enabled ? 1 : 0
  name               = local.plan_role_name
  assume_role_policy = jsonencode(local.plan_assume_role_policy)
}

resource "aws_iam_role_policy_attachment" "plan" {
  count      = var.plan.enabled ? 1 : 0
  role       = aws_iam_role.plan[0].name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role_policy" "plan" {
  count  = var.plan.enabled ? 1 : 0
  name   = local.plan_role_name
  policy = jsonencode(local.plan_policy)
  role   = aws_iam_role.plan[0].id
}

locals {
  plan_assume_role_policy = {
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Principal : {
          Federated : "arn:aws:iam::${local.account_id}:oidc-provider/token.actions.githubusercontent.com"
        },
        Action : "sts:AssumeRoleWithWebIdentity",
        Condition : {
          StringEquals : {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          },
          StringLike : {
            "token.actions.githubusercontent.com:sub" : "repo:${var.repository}:*"
          }
        }
      }
    ]
  }

  plan_policy = {
    Version : "2012-10-17",
    Statement : concat([
      {
        Effect : "Allow",
        Action : [
          "kms:Decrypt",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "cur:Describe*",
          "sts:Assume*",
          "sts:TagSession"
        ],
        Resource : [
          "*"
        ]
      }
    ], var.plan.additional_policies)
  }
}

output "plan_role" {
  value = try({
    name = aws_iam_role.plan[0].name
    arn  = aws_iam_role.plan[0].arn
  }, null)
}
