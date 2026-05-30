resource "aws_efs_file_system" "this" {
  creation_token = var.creation_token
  
  tags = {
    Name        = var.name
    Environment = var.environment
  }
}

resource "aws_efs_access_point" "policies" {
  file_system_id = aws_efs_file_system.this.id

  posix_user {
    uid = 1000
    gid = 1000
  }

  root_directory {
    path = "/policies"
    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = "755"
    }
  }

  tags = {
    Name        = "${var.name}-policies-ap"
    Environment = var.environment
  }
}

resource "aws_efs_access_point" "config" {
  file_system_id = aws_efs_file_system.this.id

  posix_user {
    uid = 1000
    gid = 1000
  }

  root_directory {
    path = "/config"
    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = "755"
    }
  }

  tags = {
    Name        = "${var.name}-config-ap"
    Environment = var.environment
  }
}



# -------------------------------------------------------
# NATS Server Configuration
# -------------------------------------------------------

resource "aws_efs_access_point" "nats_config" {
  file_system_id = aws_efs_file_system.this.id

  posix_user {
    uid = 1000
    gid = 1000
  }

  root_directory {
    path = "/nats-config"
    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = "755"
    }
  }

  tags = {
    Name        = "${var.name}-nats-config-ap"
    Environment = var.environment
  }
}

resource "aws_efs_mount_target" "this" {
  for_each = {
    for idx, subnet_id in var.private_subnet_ids :
    "subnet-${idx}" => subnet_id
  }
  
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value
  security_groups = [var.efs_security_group_id]
}

# -------------------------------------------------------
# Telegraf Configuration
# -------------------------------------------------------
resource "aws_efs_access_point" "telegraf_config" {
  file_system_id = aws_efs_file_system.this.id

  posix_user {
    uid = 1000
    gid = 1000
  }

  root_directory {
    path = "/telegraf-config"
    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = "755"
    }
  }

  tags = {
    Name        = "${var.name}-telegraf-config-ap"
    Environment = var.environment
  }
}

# -------------------------------------------------------
# Telegraf Certificates
# -------------------------------------------------------
resource "aws_efs_access_point" "telegraf_certificates" {
  file_system_id = aws_efs_file_system.this.id

  posix_user {
    uid = 1000
    gid = 1000
  }

  root_directory {
    path = "/telegraf-certs"
    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = "755"
    }
  }

  tags = {
    Name        = "${var.name}-telegraf-certs-ap"
    Environment = var.environment
  }
}

# -------------------------------------------------------
# ra-physical Configuration
# -------------------------------------------------------
resource "aws_efs_access_point" "ra_physical" {
  file_system_id = aws_efs_file_system.this.id

  posix_user {
    uid = 1000
    gid = 1000
  }

  root_directory {
    path = "/ra-physical-config"
    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = "755"
    }
  }

  tags = {
    Name        = "ra-physical-config-${var.environment}-ap"
    Environment = var.environment
  }
}

# -------------------------------------------------------
# ra-user Configuration
# -------------------------------------------------------
resource "aws_efs_access_point" "ra_user" {
  file_system_id = aws_efs_file_system.this.id

  posix_user {
    uid = 1000
    gid = 1000
  }

  root_directory {
    path = "/ra-user-config"
    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = "755"
    }
  }

  tags = {
    Name        = "ra-user-config-${var.environment}-ap"
    Environment = var.environment
  }
}