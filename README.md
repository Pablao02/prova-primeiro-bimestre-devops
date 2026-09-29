# Prova do Primeiro Bimestre — DevOps

**Aluno:** Pablo Augusto  
**RA:** 6325076  
**Disciplina:** DevOps  
**Semestre:** 2026.2

## Projeto

API de Reservas da TechNova, desenvolvida como projeto prático da prova do primeiro bimestre de DevOps.

A aplicação utiliza:

- Node.js
- Express
- PostgreSQL
- Docker
- Docker Compose
- Terraform
- AWS Academy Learner Lab

## Funcionalidades

A API implementará o CRUD completo de reservas:

- POST /reservas
- GET /reservas
- GET /reservas/:id
- PUT /reservas/:id
- DELETE /reservas/:id
- GET /health

## Infraestrutura

A infraestrutura AWS será provisionada utilizando Terraform modularizado, incluindo:

- VPC
- Subnets públicas e privadas
- Security Groups
- EC2
- RDS PostgreSQL
- Remote State com S3
- Locking com DynamoDB

## IA como copiloto

Ferramenta utilizada: ChatGPT.

A IA será utilizada como copiloto durante o desenvolvimento, com validação e revisão das soluções pelo aluno.
