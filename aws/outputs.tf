output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "private_subnet_ids" {
  value = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

output "rds_endpoint" {
  value = aws_db_instance.mariadb_master.endpoint
}

output "bucket_name" {
  value = aws_s3_bucket.maybank_s3_bucket.bucket
}

output "cloudfront_distribution_domain_name" {
  value = aws_cloudfront_distribution.distribution.domain_name
}
