# Infrastructure for quick POCs

_Light-weight and (somewhat) production grade skeleton for building web apps on Azure super-quickly._

# Design

Principles:

1. Simple – No complex scripts and no custom libraries
2. Self-contained – likely to survive for years despite org/tech/env changes
3. Super cheap – ideally free – to host
4. From zero to full app in no time – including database and user logins
5. Production-grade – as POCs have the (scary but real) tendency to end up in production (we need source control, CI/CD, infrastructure-as-code, etc.)
6. Easy to throw away

My tech stack for this:

1. SvelteKit – as Svelte is simply my favorite, very easy to use, true to the web and with very low footprint. SveleKit is a full application framework for Svelte, allowing one to build true web apps (not just frontend or backend).
2. Azure Static Web Apps – available for free and not at all static, running on Az Functions under the hood for server side code. Works out of the box with SvelteKit and Github, and has nice features like automatic environments and deployments of Github PRs.
3. Github and Github Actions for CI/CD

Will it last? Time will tell 😎

# The skeleton

The template contains:

1. This readme, containing all the necessary commands
1. Bicep file with Azure infrastructure
2. Github Actions pipeline for deploying to Azure SWA

The infrastructure footprint is limited to a single Azure resource group and a repository in Github, sharing the same name. This makes it easy to delete the project down the line.

# Setup

Before you start:

1. You need to be logged in via the Azure CLI and have selected a subscription you can write to (see `az account show`)
2. You need to be logged in with the Github CLI (`gh`)

The snippets below refer to the environment variable `NAME`, which you should set to your project name:

    NAME=poc-quicky-20230225

(I like having a timestamp in the name, minimizing the headache in the future when trying to get rid of old projects.)

Copy in the template:

    git clone --depth=1 https://github.com/gudmundurh/quick-infra.git $NAME && rm -rf $NAME/.git

Create Svelte app

    pnpm create svelte@latest $NAME 
    cd $NAME
    pnpm i

Create infrastructure

    az group create -g $NAME -l westeurope
    az deployment group create -g $NAME --template-file infrastructure/main.bicep

Create Github repo

    gh repo create $NAME --private

Create Git repo and push

    git init . && git add . && git commit -m 'Initial commit'
    git remote add origin git@github.com:gudmundurh/$NAME.git
    git branch -M main

Set up deployment to SWA

    SECRET=$(az staticwebapp secrets list -g $NAME -n $NAME -o tsv --query properties.apiKey)
    gh secret set AZURE_STATIC_WEB_APPS_API_TOKEN --body "$SECRET"

Push and wait:

    git push -u origin main
    sleep 2 && gh run watch

Browse the site

    open "https://$(az staticwebapp show  -g $NAME -n $NAME -o tsv --query defaultHostname)"

# Frequently Used Features

## Calling APIs

via openapi client

    pnpm i -D openapi-typescript-codegen
    
    In package.json:
      "apiClient": "openapi -i http://localhost:5191/swagger/v1/swagger.json -o src/lib/apiClient",

## Login

via SWA

## Database

via Azure Storage


# Teardown

    az group delete -g $RG
    gh repo delete $REPO 


# Ideas

1. Tag resources and the group with initial creation date
