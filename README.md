# Example Terraform Project

[![infracost](https://img.shields.io/endpoint?url=https://dashboard.api.infracost.io/shields/json/ff15881f-1875-469d-9e09-b9a9227ac666/repos/97ba57c7-0e4a-40cc-8b52-a398cafdc659/branch/6ed2d281-fbcd-45b6-905a-83a1ecde900c)](https://dashboard.infracost.io/org/infracost/repos/97ba57c7-0e4a-40cc-8b52-a398cafdc659)

Use our [Get Started](https://www.infracost.io/docs) guide and the example Terraform projects in this repo to see how Infracost works. The AWS Terraform project contains an EC2 instance and a Lambda function.
There is also an Azure and Google example.

## Terraform Cloud (single workspace, GCP-first)

Use **`infra/`** as the **Terraform Working Directory**.

| Cloud | What runs | Notes |
|-------|-----------|--------|
| **Google** | `e2-medium` VM in `var.gcp_zone` | Set workspace var `gcp_project` (and GCP credentials in TFC). |
| **AWS** | One S3 bucket | Mock AWS keys in `providers.tf` suit many plan/cost runs. |
| **Azure** | Optional resource group | Default **off** (`enable_azure = false`). Set `enable_azure = true` and add `ARM_*` env vars in TFC when you need a third cloud. |

Legacy per-cloud Infracost usage files remain under `infra/aws`, `infra/azure`, and `infra/google`.
