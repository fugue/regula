# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# terraform file that generated bucketpolicy_allowlist_infra.json

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "deny_no_versioning_or_lifecycle" {
  bucket = "allow-directly-attached-versioning-or-lifecycle"
}

resource "aws_s3_bucket" "deny_no_versioning" {
  bucket = "allow-directly-attached-versioning"
}

resource "aws_s3_bucket" "deny_no_lifecycle" {
  bucket = "allow-directly-attached-lifecycle"
}

resource "aws_s3_bucket" "allow_inline_versioning_and_lifecycle" {
  bucket = "allow-directly-attached-versioning"
  versioning {
    enabled = true
  }
  lifecycle_rule {
    enabled = true

    expiration {
      days = 30
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    transition {
      days          = 180
      storage_class = "DEEP_ARCHIVE"
    }
  }
}

resource "aws_s3_bucket" "allow_attached_resource_versioning" {
  bucket = "allow-attached-resource-versioning"
}

resource "aws_s3_bucket_lifecycle_configuration" "allow_attached_resource_versioning" {
  bucket = aws_s3_bucket.allow_attached_resource_versioning.id

  rule {
    id     = "Delete seven days old"
    status = "Enabled"
    expiration {
      days = 7
    }
    noncurrent_version_expiration {
      noncurrent_days = 7
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = 1
    }
  }
  rule {
    id     = "Delete expired"
    status = "Enabled"
    expiration {
      expired_object_delete_marker = true
    }
  }
}

resource "aws_s3_bucket_versioning" "allow_attached_resource_versioning" {
  bucket = aws_s3_bucket.allow_attached_resource_versioning.id
  versioning_configuration {
    status = "Enabled"
  }
}
