provider "google" {}

resource "google_sql_database_instance" "default" {
  name                = "all-valid-flags-pg-instance"
  database_version    = "POSTGRES_11"
  region              = "us-east1"
  deletion_protection = false

  settings {
    tier = "db-f1-micro"

    database_flags {
      name  = "log_checkpoints"
      value = "on"
    }

    database_flags {
      name  = "log_connections"
      value = "on"
    }

    database_flags {
      name  = "log_disconnections"
      value = "on"
    }

    database_flags {
      name  = "log_lock_waits"
      value = "on"
    }

    database_flags {
      name  = "log_min_error_statement"
      value = "error"
    }

    database_flags {
      name  = "log_min_messages"
      value = "error"
    }

    database_flags {
      name  = "log_temp_files"
      value = "0"
    }

    database_flags {
      name  = "log_min_duration_statement"
      value = "-1"
    }
  }
}
