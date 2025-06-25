import pulumi
from pulumi import ResourceOptions, Output
import pulumi_gcp as gcp

# Configurable inputs
config = pulumi.Config()
service_name = config.require("service_name")
repo_image = config.get("repo_image") or "us-docker.pkg.dev/cloudrun/container/hello"
region = "europe-west9"
limits = config.get_bool("limits") if config.get("limits") is not None else True
public_access = config.get_bool("public_access") if config.get("public_access") is not None else False

# Cloud Run service
service = gcp.cloudrunv2.Service(
    "default",
    name=service_name,
    location=region,
    ingress="INGRESS_TRAFFIC_ALL",
    template=gcp.cloudrunv2.ServiceTemplateArgs(
        containers=[gcp.cloudrunv2.ServiceTemplateContainerArgs(
            image=repo_image,
            resources=gcp.cloudrunv2.ServiceTemplateContainerResourceArgs(
                limits={
                    "cpu": "2",
                    "memory": "1024Mi"
                }
            ) if limits else None
        )]
    ),
    deletion_protection=False
)

# Optional IAM policy for public access
if public_access:
    noauth_binding = gcp.projects.IAMPolicy(
        "noauth-policy",
        bindings=[gcp.projects.IAMPolicyBindingArgs(
            role="roles/run.invoker",
            members=["allUsers"],
        )]
    )

    iam_policy = gcp.cloudrun.IamPolicy(
        "noauth-cloudrun-policy",
        location=region,
        service=service.name,
        policy_data=noauth_binding.policy_data
    )
