provider "google" {}

resource "google_storage_bucket" "all_users" {
  name          = "invalid-public-all-users-iam"
  force_destroy = true
}

data "google_iam_policy" "all_users" {
  binding {
    role = "roles/storage.admin"
    members = [
      "user:jason@fugue.co"
    ]
  }

  binding {
    role = "roles/storage.objectViewer"
    members = [
      "allUsers"
    ]
  }
}

resource "google_storage_bucket_iam_policy" "all_users_policy" {
  bucket      = google_storage_bucket.all_users.name
  policy_data = data.google_iam_policy.all_users.policy_data
}

resource "google_storage_bucket" "all_authenticated_users" {
  name          = "invalid-public-all-authenticated-iam"
  force_destroy = true
}

data "google_iam_policy" "all_authenticated_users" {
  binding {
    role = "roles/storage.admin"
    members = [
      "user:jason@fugue.co"
    ]
  }

  binding {
    role = "roles/storage.objectViewer"
    members = [
      "allAuthenticatedUsers"
    ]
  }
}

resource "google_storage_bucket_iam_policy" "all_authenticated_users_policy" {
  bucket      = google_storage_bucket.all_authenticated_users.name
  policy_data = data.google_iam_policy.all_authenticated_users.policy_data
}
