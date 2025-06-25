This guide explains how to deploy your service directly to Google Cloud Run using the gcloud CLI and the --source . flag, which builds and deploys your code from your local directory.

Before deploying, make sure you have the Google Cloud SDK (gcloud) installed: https://cloud.google.com/sdk/docs/install

Authenticate to your Google Cloud account using:
gcloud auth login

Set your default project:
gcloud config set project YOUR_PROJECT_ID

Enable the Cloud Run API:
gcloud services enable run.googleapis.com


To deploy your service, run:
gcloud run deploy SERVICE_NAME \
  --source . \
  --region REGION

Replace SERVICE_NAME with the name of your Cloud Run service, and REGION with a valid region like europe-west9 or us-central1.

Example:
gcloud run deploy my-app \
  --source . \
  --region europe-west9

After deployment, gcloud will display a public URL to access your service.