terraform {
  backend "s3" {
    bucket = "tf-task-salman-ebiz"
    key    = "task1/tf-backend"
    region = "us-east-1"
  }
}
