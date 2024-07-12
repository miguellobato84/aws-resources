locals {
  apply_role_name = var.apply.role_name != null ? var.apply.role_name : "${split("/", var.repository)[1]}-apply"
}

resource "aws_iam_role" "apply" {
  count              = var.apply.enabled ? 1 : 0
  name               = local.apply_role_name
  assume_role_policy = jsonencode(local.apply_assume_role_policy)
}

resource "aws_iam_role_policy_attachment" "apply" {
  count      = var.apply.enabled ? 1 : 0
  role       = aws_iam_role.apply[0].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

locals {
  apply_assume_role_policy = {
    Version : "2012-10-17",
    Statement : [
      {
        Sid : "",
        Effect : "Allow",
        Principal : {
          "Federated" : "arn:aws:iam::${local.account_id}:oidc-provider/token.actions.githubusercontent.com"
        },
        Action : "sts:AssumeRoleWithWebIdentity",
        Condition : {
          StringEquals : {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com",
            "token.actions.githubusercontent.com:sub" : "repo:${var.repository}:ref:refs/heads/${var.apply.branch}"
          }
        }
      }
    ]
  }
}

output "apply_role" {
  value = try({
    name = aws_iam_role.apply[0].name
    arn  = aws_iam_role.apply[0].arn
  }, null)
}
