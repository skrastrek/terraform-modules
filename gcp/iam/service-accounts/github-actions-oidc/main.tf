resource "google_service_account" "this" {
  provider = google-beta

  account_id  = var.account_id
  description = var.description
}

resource "google_project_iam_member" "role" {
  provider = google-beta

  for_each = toset(var.iam_member_roles)

  project = var.project_id
  role    = "roles/${each.value}"
  member  = "serviceAccount:${google_service_account.this.email}"
}

resource "google_service_account_iam_member" "github_repository_workload_identity" {
  provider = google-beta

  service_account_id = google_service_account.this.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${var.github_iam_workload_identity_pool_name}/attribute.repository/${var.github_repository}"
}
