# Copyright 2020-2021 Fugue, Inc.
#
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
provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "example" {
  provider = aws
  bucket_prefix = "example"
  tags = {
    Stage = "Prod"
  }
}

# aws_autoscaling_group uses a different tag format.
resource "aws_autoscaling_group" "example" {
  provider           = aws
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  tag {
    key                 = "Stage"
    value               = "Dev"
    propagate_at_launch = true
  }
}

# Dependency of the `aws_autoscaling_group`.
resource "aws_launch_template" "example" {
  provider      = aws
  name_prefix   = "example"
  image_id      = "ami-1a2b3c"
  instance_type = "t2.micro"
}

provider "google" {
}

resource "google_storage_bucket" "example" {
  provider = google
  name     = "example"
  location = "US"
  labels = {
    Stage = "Prod"
  }
}

resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
}
