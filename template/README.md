# Quick POC

Created using [this template](https://github.com/gudmundurh/quick-infra)

# Setup

Before you start:

1. You need to be logged in via the Azure CLI and have selected a subscription you can write to (see `az account show`)
2. You need to be logged in with the Github CLI (`gh`)

The snippets below refer to the environment variable `NAME`, which you should set to your project name:

    NAME=poc-quicky-20230225

(I like having a timestamp in the name, minimizing the headache in the future when trying to get rid of old projects.)

Create Svelte app

    pnpm create svelte@latest $NAME 
    cd $NAME
    pnpm i

Copy in the template:

    curl -L https://github.com/gudmundurh/quick-infra/archive/refs/heads/main.tar.gz | tar  --strip-components=2 -xvz '*/template'

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

# Teardown

    az group delete -g $NAME
    gh repo delete $NAME

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
