data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_instance" "api" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_ids[0]
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true
  iam_instance_profile        = var.instance_profile_name

  user_data = <<-EOF
    #!/bin/bash
    set -e

    apt-get update
    apt-get install -y docker.io git postgresql-client

    systemctl enable docker
    systemctl start docker

    cd /opt

    if [ ! -d /opt/prova-primeiro-bimestre-devops ]; then
      git clone https://github.com/Pablao02/prova-primeiro-bimestre-devops.git
    fi

    cd /opt/prova-primeiro-bimestre-devops

    PGPASSWORD='${var.db_password}' psql \
      -h '${var.db_host}' \
      -U '${var.db_username}' \
      -d '${var.db_name}' \
      -c "CREATE TABLE IF NOT EXISTS reservas (id SERIAL PRIMARY KEY, cliente VARCHAR(150) NOT NULL, data TIMESTAMP NOT NULL, status VARCHAR(50) NOT NULL);"

    docker build -t reservas-api ./app

    docker rm -f reservas-api 2>/dev/null || true

    docker run -d \
      --restart unless-stopped \
      --name reservas-api \
      -p 3000:3000 \
      -e PORT=3000 \
      -e DB_HOST='${var.db_host}' \
      -e DB_PORT=5432 \
      -e DB_NAME='${var.db_name}' \
      -e DB_USER='${var.db_username}' \
      -e DB_PASSWORD='${var.db_password}' \
      reservas-api
  EOF

  tags = {
    Name = "${var.project_name}-api"
  }
}