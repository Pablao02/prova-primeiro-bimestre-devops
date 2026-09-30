# Prova do Primeiro Bimestre — DevOps

**Aluno:** Pablo Augusto
**RA:** 6325076
**Disciplina:** DevOps
**Semestre:** 2026.2

## Projeto

API de Reservas desenvolvida como projeto prático da prova do primeiro bimestre de DevOps.

O projeto consiste em uma API REST desenvolvida com Node.js e Express, utilizando PostgreSQL como banco de dados. A aplicação foi executada inicialmente de forma local com Docker Compose e depois disponibilizada na AWS utilizando Terraform.

## Tecnologias utilizadas

* Node.js
* Express
* PostgreSQL
* Docker
* Docker Compose
* Terraform
* AWS EC2
* AWS RDS PostgreSQL
* Amazon S3
* Amazon DynamoDB
* Git e GitHub
* AWS Academy Learner Lab

## Funcionalidades

A API possui as seguintes rotas:

| Método | Rota            | Função                              |
| ------ | --------------- | ----------------------------------- |
| POST   | `/reservas`     | Cria uma reserva                    |
| GET    | `/reservas`     | Lista todas as reservas             |
| GET    | `/reservas/:id` | Consulta uma reserva pelo ID        |
| PUT    | `/reservas/:id` | Atualiza uma reserva                |
| DELETE | `/reservas/:id` | Exclui uma reserva                  |
| GET    | `/health`       | Verifica o status da API e do banco |

As reservas possuem os seguintes campos:

* `id`
* `cliente`
* `data`
* `status`

## Execução local

A aplicação pode ser executada utilizando Docker Compose.

O ambiente local possui dois serviços:

* API Node.js
* PostgreSQL

O Docker Compose utiliza:

* volume persistente para o PostgreSQL;
* rede bridge própria;
* healthcheck do PostgreSQL;
* dependência da API em relação à saúde do banco.

As variáveis de ambiente utilizadas localmente ficam no arquivo `.env`, que não é versionado. O arquivo `.env.example` é disponibilizado como modelo.

Para iniciar o projeto:

```bash
docker compose up -d --build
```

Para verificar os containers:

```bash
docker compose ps
```

A API fica disponível na porta `3000`.

## Docker

A API possui um Dockerfile utilizando build em múltiplos estágios e execução com usuário não-root.

Também foi criado um `.dockerignore` para evitar o envio de arquivos desnecessários para o contexto da imagem.

## Infraestrutura AWS

A infraestrutura foi criada utilizando Terraform de forma modular.

A arquitetura possui:

* VPC `10.0.0.0/16`;
* duas subnets públicas;
* duas subnets privadas;
* Internet Gateway;
* tabela de rotas pública;
* Security Group para a EC2;
* Security Group para o RDS;
* EC2 `t2.micro`;
* RDS PostgreSQL `db.t3.micro`;
* armazenamento do RDS criptografado.

A EC2 fica em uma subnet pública para disponibilizar a API externamente.

O RDS fica em subnets privadas e não possui acesso público direto.

O acesso ao PostgreSQL pela porta `5432` é permitido somente a partir do Security Group da EC2.

## Terraform

A infraestrutura foi organizada nos seguintes módulos:

```text
infra/
├── backend/
├── modules/
│   ├── vpc/
│   ├── security-group/
│   ├── ec2/
│   └── rds/
├── main.tf
├── variables.tf
├── outputs.tf
└── terraform.tfvars
```

O `terraform.tfvars` contém informações sensíveis e não é versionado.

Antes da aplicação da infraestrutura foram utilizados:

```bash
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

## Remote State

O Terraform utiliza um backend remoto no Amazon S3.

O estado possui:

* versionamento no bucket S3;
* criptografia no armazenamento;
* locking utilizando DynamoDB.

O bucket utilizado para o estado é:

```text
prova-devops-terraform-state-6325076
```

E a tabela utilizada para locking é:

```text
prova-devops-terraform-lock
```

Durante a configuração do ambiente foi necessário adaptar o gerenciamento do bucket devido a uma restrição específica do AWS Academy Learner Lab.

## AWS Academy Learner Lab

A infraestrutura foi executada utilizando o AWS Academy Learner Lab na região `us-east-1`.

Como o laboratório possui restrições para criação e gerenciamento de recursos IAM, foi utilizada a `LabRole` disponibilizada pelo ambiente e a `LabInstanceProfile` na EC2.

As credenciais utilizadas no laboratório são temporárias e precisam ser atualizadas quando expiram.

## Validação da infraestrutura

Depois do provisionamento, foram realizadas verificações da infraestrutura e da aplicação.

Foi verificado que:

* a EC2 estava em execução;
* o RDS estava disponível;
* o RDS não estava publicamente acessível;
* o Security Group do RDS permitia acesso somente pelo Security Group da EC2;
* a API estava acessível pela EC2;
* o endpoint `/health` indicava conexão com o banco;
* o CRUD de reservas funcionava utilizando o RDS.

Também foi necessário configurar SSL na conexão da aplicação com o RDS para que a comunicação com o PostgreSQL funcionasse corretamente.

## Evidências

As evidências dos testes estão disponíveis na pasta:

```text
evidencias/
```

Entre elas estão:

```text
compose-config.txt
compose-ps.txt
docker-build.txt
aws-health.txt
aws-post.txt
aws-get.txt
aws-get-id.txt
aws-put.txt
aws-delete.txt
aws-get-after-delete.txt
```

As evidências registram a execução local com Docker e os testes da API na infraestrutura AWS.

## Versionamento

O projeto foi desenvolvido utilizando Git e GitHub.

Foram utilizados commits seguindo o padrão Conventional Commits, como:

```text
chore:
feat:
fix:
docs:
```

Também foi utilizada uma branch de funcionalidade durante o desenvolvimento da API, posteriormente integrada à branch principal.

## IA como copiloto

A ferramenta de IA utilizada durante o desenvolvimento foi o ChatGPT.

A IA foi utilizada como copiloto para auxiliar na criação da estrutura do projeto, comandos, código, configuração do Docker e Terraform e principalmente na interpretação e correção de erros encontrados durante a execução.

As sugestões da IA foram sempre testadas no ambiente real antes de serem consideradas concluídas.

Os detalhes do processo de utilização da IA estão descritos no arquivo:

```text
relatorio.md
```
