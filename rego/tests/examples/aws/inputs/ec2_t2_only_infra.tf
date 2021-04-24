# Copyright 2020 Fugue, Inc.
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

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "invalid" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.nano"
}

resource "aws_instance" "valid_micro" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
}

resource "aws_instance" "valid_small" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.small"
}

resource "aws_instance" "valid_medium" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"
}

resource "aws_instance" "valid_large" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.large"
}

resource "aws_instance" "valid_xlarge" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.xlarge"
}

resource "aws_instance" "valid_2xlarge" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.2xlarge"
}
