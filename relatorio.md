# Relatório — Prova do Primeiro Bimestre de DevOps

**Aluno:** Pablo Augusto  
**RA:** 6325076  
**Disciplina:** DevOps  
**Semestre:** 2026.2  

## Questão 1 — A Jornada Completa (Aulas 01 a 07)

Para fazer a prova, fui juntando o que aprendi durante as aulas em um único projeto. Comecei criando a API de Reservas usando Node.js, Express e PostgreSQL, com as rotas de cadastro, consulta, alteração e exclusão das reservas.  
Desde o começo usei Git para controlar as alterações do projeto e fui fazendo commits conforme cada parte ficava pronta. Isso ajudou bastante porque eu conseguia saber o que tinha sido alterado e voltar para versões anteriores se fosse necessário.  
Depois passei a trabalhar com Docker. Criei o Dockerfile da API e o Docker Compose para subir a aplicação junto com o PostgreSQL. Também configurei o volume do banco, a rede entre os containers e o healthcheck para garantir que a API só subisse depois que o banco estivesse funcionando.  
Depois de testar tudo localmente, comecei a parte da AWS usando Terraform.  
Separei o Terraform em módulos para não deixar tudo em um único arquivo. Criei módulos para VPC, Security Groups, EC2 e RDS.  
Na VPC coloquei subnets públicas e privadas em duas Availability Zones. A EC2 ficou na parte pública para conseguir disponibilizar a API, enquanto o RDS ficou na parte privada.  
Também configurei o remote state usando S3 e o locking usando DynamoDB, como foi pedido na prova.  
Durante essa parte encontrei alguns problemas do próprio AWS Academy. Um deles foi uma restrição relacionada ao bucket S3, então precisei adaptar a configuração do Terraform para conseguir continuar usando o remote state.  
Também tive problema com o usuário do RDS, porque inicialmente tentei usar `admin` e o RDS não aceitou esse nome. Troquei para `reservas_user` e consegui continuar.  
Depois que a infraestrutura foi criada, ainda apareceu um problema na conexão da API com o RDS. A API estava funcionando, mas o banco aparecia como desconectado. Analisando os logs, descobri que o RDS estava exigindo conexão com SSL. Ajustei a aplicação, reconstruí a imagem e fiz o teste novamente.  
Depois disso o `/health` passou a mostrar que o banco estava conectado e consegui testar o CRUD completo da API diretamente pela EC2.  
Então, no final, as aulas foram se encaixando: Git para versionamento, Docker para os containers, Terraform para infraestrutura, módulos para organização e AWS para colocar a aplicação funcionando na nuvem.

## Questão 2 — O Processo com IA como Copiloto

Durante o projeto usei o ChatGPT como meu principal copiloto de IA. Eu não deixei a IA fazer tudo sozinha; normalmente eu passava o que precisava fazer, mostrava os erros que apareciam no PowerShell ou na AWS e usava as respostas para entender e corrigir o projeto.  
No começo, usei a IA principalmente para ajudar a montar a estrutura da API em Node.js e Express, incluindo as rotas de reservas, conexão com PostgreSQL e o endpoint `/health`.  
Também pedi ajuda para montar o Dockerfile e o `docker-compose.yml`, principalmente para configurar corretamente a comunicação entre a API e o PostgreSQL.  
Na parte do Terraform, a IA ajudou bastante na criação da estrutura dos módulos de VPC, Security Group, EC2 e RDS.  
Um dos pontos que mais ajudou foi quando começaram a aparecer erros durante o desenvolvimento. Eu copiava o erro que aparecia no terminal e explicava o que tinha acabado de fazer, e a partir disso conseguia descobrir o que precisava mudar.  
Por exemplo, quando o RDS não aceitou o usuário `admin`, consegui entender o problema e trocar o usuário para `reservas_user`.  
Outro problema foi quando a API estava funcionando na EC2, mas o `/health` mostrava que o banco estava desconectado. Pelos logs descobrimos que o RDS estava recusando a conexão sem criptografia. Então ajustei o código do PostgreSQL para usar SSL em produção.  
Depois disso precisei reconstruir a imagem Docker na EC2 e recriar o container para testar a alteração.  
Eu não usei Kiro Spec nesse projeto. O processo foi feito diretamente com o ChatGPT, seguindo os requisitos da prova e usando os resultados reais dos comandos para ir corrigindo as coisas.  
Comparando com fazer tudo manualmente, a IA economizou bastante tempo principalmente para montar estruturas iniciais, explicar comandos e ajudar a entender os erros.  
Por outro lado, percebi que não dava para simplesmente copiar e colar tudo que a IA sugeria. Algumas coisas precisaram ser adaptadas porque o AWS Academy tem restrições que não existem necessariamente em uma conta AWS comum.  
Então, para mim, a IA funcionou melhor como um copiloto: ela ajudava a encontrar o caminho e escrever partes do código, mas eu precisava executar, testar e conferir se realmente funcionava.

## Questão 3 — Infraestrutura, Segurança e o Learner Lab

Na AWS montei uma VPC para separar a infraestrutura do projeto. Dentro dela criei subnets públicas e privadas distribuídas em duas Availability Zones.  
A EC2 ficou em uma subnet pública porque precisava receber acesso externo para disponibilizar a API de Reservas. Já o RDS ficou nas subnets privadas porque não precisava ficar exposto diretamente à internet.  
Para controlar os acessos, criei dois Security Groups. Um para a EC2 e outro para o RDS.  
No Security Group do RDS, a porta 5432 não ficou liberada para qualquer endereço da internet. Ela foi liberada somente para o Security Group da EC2. Assim, a aplicação consegue acessar o banco, mas o banco não fica aberto diretamente para a internet.  
Também configurei o RDS como `publicly_accessible = false` e habilitei a criptografia do armazenamento.  
Na EC2 usei uma instância `t2.micro`, conforme o que era possível utilizar no ambiente da prova.  
No Learner Lab não pude simplesmente criar minhas próprias roles e usuários IAM como faria em uma conta AWS normal. O laboratório já disponibiliza recursos específicos para isso.  
Por esse motivo usei a `LabRole` e a `LabInstanceProfile` disponibilizadas pelo próprio AWS Academy para a EC2.  
Também precisei trabalhar com as credenciais temporárias do laboratório. Em alguns momentos elas expiraram e foi necessário atualizar as credenciais antes de continuar usando a AWS CLI.  
Outro cuidado foi utilizar a região `us-east-1`, que era a região configurada para o laboratório.  
Durante o projeto também descobri que o AWS Academy possui algumas restrições próprias. Um exemplo foi o problema que aconteceu com o S3 e o Terraform, quando uma configuração do bucket foi bloqueada por uma política do ambiente.  
Também tive dificuldade para utilizar o Session Manager de forma interativa, então acabei usando comandos enviados pelo AWS Systems Manager para executar algumas ações na EC2.  
Esses problemas acabaram sendo importantes para entender que o que funciona em uma conta AWS comum nem sempre funciona exatamente da mesma forma no Learner Lab.  
No final consegui deixar a EC2 acessando o RDS pela rede privada e a API funcionando externamente sem precisar deixar o banco público.

## Questão 4 — Validação e Responsabilidade

Antes de rodar o `terraform apply`, eu não simplesmente aceitei o código que a IA tinha sugerido. Primeiro fui conferindo a estrutura dos arquivos e se os recursos estavam realmente de acordo com o que a prova pedia.  
Também executei `terraform fmt -recursive` para organizar a formatação dos arquivos.  
Depois rodei `terraform validate` para verificar se a configuração do Terraform estava válida.  
Em seguida rodei `terraform plan`, porque queria saber exatamente quais recursos seriam criados antes de executar o `apply`.  
No `plan`, conferi principalmente a VPC, as subnets, os Security Groups, a EC2 e o RDS.  
Também conferi a parte de segurança do banco, principalmente se ele estava privado e se a porta 5432 estava sendo liberada somente para a EC2.  
Depois que o `apply` terminou, não considerei que estava tudo certo apenas porque o Terraform mostrou sucesso. Fui verificar os recursos diretamente na AWS.  
Conferi se a EC2 estava rodando, se o RDS estava disponível e se o Security Group do banco estava permitindo acesso somente pelo Security Group da EC2.  
Também testei a própria aplicação usando o `/health`. No primeiro teste o banco apareceu como desconectado, então fui atrás do erro em vez de considerar a infraestrutura pronta.  
Nos logs encontrei a mensagem indicando que o PostgreSQL estava recusando a conexão sem criptografia. Corrigi o código para usar SSL, reconstruí o Docker e testei novamente.  
Depois disso o `/health` mostrou que o banco estava conectado e consegui fazer os testes de POST, GET, GET por ID, PUT e DELETE.  
Se eu simplesmente tivesse aceitado tudo que a IA gerou sem conferir, poderia ter criado uma infraestrutura que não funcionasse no Learner Lab ou até deixado alguma configuração de segurança errada.  
A sequência Git → Docker → Terraform → Modules também ajudou muito porque fui aprendendo a separar cada parte do projeto e entender o que estava acontecendo.  
Com Git eu conseguia controlar as alterações, com Docker conseguia testar a aplicação, com Terraform conseguia criar a infraestrutura e com os módulos conseguia organizar melhor os recursos.  
Por isso, a experiência me mostrou que a IA ajuda bastante a acelerar o desenvolvimento, mas não substitui os testes e a revisão de quem está fazendo o projeto.  
No final, eu precisava entender o que estava sendo criado, testar na prática e corrigir quando a solução sugerida não funcionava no ambiente real.
