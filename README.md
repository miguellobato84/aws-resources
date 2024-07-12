# Modeling Infra
This repo contains the terragrunt modules for the models.

## Models
- For every [use case](https://github.com/new-work/slam-modelserving-infra/blob/main/environments/preview/eu-west-1/ecs/terragrunt.hcl) it is configured a list of models which are deployed in an ECS instance.

### Endpoints
* http://preview.ai-models.nwse.io/rest/jobs-search/embedder-e5-ft-v1/docs
* https://preview.ai-models.nwse.io/rest/jobs-search/x-encoder-minilm/docs
* https://preview.ai-models.nwse.io/rest/skills-extraction/flan-t5l-ft-v1/docs



## Metrics
Prometheus is deployed in its own ecs fargate instance.
Url: https://prometheus.preview.ai-models.nwse.io/
