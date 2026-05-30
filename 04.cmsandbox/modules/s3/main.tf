# ------------------------------------------------------------------------------
# Cerbos Policies Bucket
# ------------------------------------------------------------------------------
resource "aws_s3_bucket" "cerbos_policies" {
  bucket = var.cerbos_policies_bucket_name

  tags = {
    Name        = "CerbosPolicies"
    Environment = var.environment
  }

  force_destroy = true # Optional: allows deleting non-empty bucket in destroy
}

resource "aws_s3_bucket_versioning" "cerbos_policies" {
  bucket = aws_s3_bucket.cerbos_policies.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "cerbos_policies" {
  bucket = aws_s3_bucket.cerbos_policies.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cerbos_policies" {
  bucket = aws_s3_bucket.cerbos_policies.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


# ------------------------------------------------------------------------------
# Cerbos Config Bucket
# ------------------------------------------------------------------------------
resource "aws_s3_bucket" "cerbos_config" {
  bucket = var.cerbos_config_bucket_name

  tags = {
    Name        = "CerbosConfig"
    Environment = var.environment
  }

  force_destroy = true # Optional: allows deleting non-empty bucket in destroy
}

resource "aws_s3_bucket_versioning" "cerbos_config" {
  bucket = aws_s3_bucket.cerbos_config.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "cerbos_config" {
  bucket = aws_s3_bucket.cerbos_config.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cerbos_config" {
  bucket = aws_s3_bucket.cerbos_config.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ------------------------------------------------------------------------------
# Influx Config Bucket
# ------------------------------------------------------------------------------
resource "aws_s3_bucket" "influx_config" {
  bucket = var.influx_config_bucket_name

  tags = {
    Name        = "InfluxConfig"
    Environment = var.environment
  }

  force_destroy = true # Optional: allows deleting non-empty bucket in destroy
}

resource "aws_s3_bucket_versioning" "influx_config" {
  bucket = aws_s3_bucket.influx_config.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "influx_config" {
  bucket = aws_s3_bucket.influx_config.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "influx_config" {
  bucket = aws_s3_bucket.influx_config.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ------------------------------------------------------------------------------
# NATS Config Bucket
# ------------------------------------------------------------------------------
resource "aws_s3_bucket" "nats_config" {
  bucket = var.nats_config_bucket_name

  tags = {
    Name        = "NATSConfig"
    Environment = var.environment
  }

  force_destroy = true # Optional: allows deleting non-empty bucket in destroy
}

resource "aws_s3_bucket_versioning" "nats_config" {
  bucket = aws_s3_bucket.nats_config.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "nats_config" {
  bucket = aws_s3_bucket.nats_config.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "nats_config" {
  bucket = aws_s3_bucket.nats_config.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}



# ------------------------------------------------------------------------------
# Telegraf Config Bucket
# ------------------------------------------------------------------------------
resource "aws_s3_bucket" "telegraf_config" {
  bucket = var.telegraf_config_bucket_name

  tags = {
    Name        = "TelegrafConfig"
    Environment = var.environment
  }

  force_destroy = true # Optional: allows deleting non-empty bucket in destroy
}

resource "aws_s3_bucket_versioning" "telegraf_config" {
  bucket = aws_s3_bucket.telegraf_config.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "telegraf_config" {
  bucket = aws_s3_bucket.telegraf_config.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "telegraf_config" {
  bucket = aws_s3_bucket.telegraf_config.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ------------------------------------------------------------------------------
# Telegraf Certificates Bucket
# ------------------------------------------------------------------------------
resource "aws_s3_bucket" "telegraf_certificates" {
  bucket = var.telegraf_certificates_bucket_name

  tags = {
    Name        = "TelegrafCertificates"
    Environment = var.environment
  }

  force_destroy = true # Optional: allows deleting non-empty bucket in destroy
}

resource "aws_s3_bucket_versioning" "telegraf_certificates" {
  bucket = aws_s3_bucket.telegraf_certificates.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "telegraf_certificates" {
  bucket = aws_s3_bucket.telegraf_certificates.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "telegraf_certificates" {
  bucket = aws_s3_bucket.telegraf_certificates.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


# ------------------------------------------------------------------------------
# Utility Obol Schema Bucket
# ------------------------------------------------------------------------------
resource "aws_s3_bucket" "utility_obol_schema" {
  bucket = var.utility_obol_schema_bucket_name

  tags = {
    Name        = "UtilityObolSchema"
    Environment = var.environment
  }

  force_destroy = true # Optional: allows deleting non-empty bucket in destroy
}

resource "aws_s3_bucket_versioning" "utility_obol_schema" {
  bucket = aws_s3_bucket.utility_obol_schema.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "utility_obol_schema" {
  bucket = aws_s3_bucket.utility_obol_schema.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "utility_obol_schema" {
  bucket = aws_s3_bucket.utility_obol_schema.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ------------------------------------------------------------------------------
# RA Physical Configuration Bucket
# ------------------------------------------------------------------------------
resource "aws_s3_bucket" "ra_physical_config" {
  bucket = var.ra_physical_config_bucket_name

  tags = {
    Name        = "ra-physical-config"
    Environment = var.environment
  }

  force_destroy = true # Optional: allows deleting non-empty bucket in destroy
}

resource "aws_s3_bucket_versioning" "ra_physical_config_schema" {
  bucket = aws_s3_bucket.ra_physical_config.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "ra_physical_config_access_block" {
  bucket = aws_s3_bucket.ra_physical_config.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ra_physical_server_side_encryption" {
  bucket = aws_s3_bucket.ra_physical_config.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ------------------------------------------------------------------------------
# RA User Configuration Bucket
# ------------------------------------------------------------------------------
resource "aws_s3_bucket" "ra_user_config" {
  bucket = var.ra_user_config_bucket_name

  tags = {
    Name        = "ra-user-config"
    Environment = var.environment
  }

  force_destroy = true # Optional: allows deleting non-empty bucket in destroy
}

resource "aws_s3_bucket_versioning" "ra_user_config_schema" {
  bucket = aws_s3_bucket.ra_user_config.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "ra_user_config_access_block" {
  bucket = aws_s3_bucket.ra_user_config.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ra_user_server_side_encryption" {
  bucket = aws_s3_bucket.ra_user_config.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ------------------------------------------------------------------------------