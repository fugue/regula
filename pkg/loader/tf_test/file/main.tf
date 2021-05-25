resource "aws_s3_bucket" "trail_bucket" {
  force_destroy = true
  tags = {
    file1 = file("tf_test/file/hello.txt")
    file2 = file("${path.module}/hello.txt")
  }
}
