
resource "aws_s3_bucket" "maybank_s3_bucket" {
  bucket =  "maybank-s3-bucket"

  tags = {
    Name = "Maybank S3 Bucket"
    Description = "Maybank S3 Bucket"
    CreatedBy = "Terraform"
  }
  lifecycle {
     prevent_destroy = true
  }
}


resource "aws_s3_bucket_policy" "maybank_s3_bucket_policy" {
  bucket = aws_s3_bucket.maybank_s3_bucket.id
  policy = data.aws_iam_policy_document.maybank_s3_bucket_policy_document.json

  lifecycle {
    prevent_destroy = true
  }
}

data "aws_iam_policy_document" "maybank_s3_bucket_policy_document" {
  version = "2012-10-17"
  statement {
    sid = "IdentificationOACAccess"
    principals {
      type        = "AWS"
      identifiers = [  "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.origin_access_identity.id}"]
    }
    effect = "Allow"

    actions = [
      "s3:PutObject",

    ]

    resources = [
      "${aws_s3_bucket.maybank_s3_bucket.arn}/*",
    ]
  }
 


}


