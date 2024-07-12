<!-- BEGIN_TF_DOCS -->
## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apply"></a> [apply](#input\_apply) | n/a | <pre>object({<br>    enabled   = bool<br>    role_name = optional(string)<br>    branch    = optional(string, "")<br>  })</pre> | <pre>{<br>  "enabled": false<br>}</pre> | no |
| <a name="input_plan"></a> [plan](#input\_plan) | n/a | <pre>object({<br>    enabled             = bool<br>    role_name           = optional(string)<br>    additional_policies = optional(list(any), [])<br>  })</pre> | <pre>{<br>  "enabled": false<br>}</pre> | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Github repository name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_apply_role"></a> [apply\_role](#output\_apply\_role) | n/a |
| <a name="output_plan_role"></a> [plan\_role](#output\_plan\_role) | n/a |
<!-- END_TF_DOCS -->
