What this is:

_Light-weight and production grade skeleton for building web apps super-quickly_

# Design

Principles:

1. No complex scripts and no custom libraries
2. Self-contained – can survive for years despite org/tech/env changes
3. Super cheap – ideally free – to host
4. From zero to full app in no time – including database and user logins
5. Production-grade – as POCs have the (scary but real) tendency to end up in production

The tech stack:

1. SvelteKit – could also be other JamStack solutions like Next.js. Allow building frontend easily but also fully fledged backends and APIs.
2. Azure Static Web Apps – pretty much free and not at all static (Az Functions under the hood)
3. Github and Github Actions for CI/CD


# Template files

1. bicep file with infrastructure
2. YAML pipeline for SWA

# Setup

Before you start:

1. You need to be logged in via the Azure CLI and have selected a subscription you can write to (see `az account show`)
2. You need to be logged in with the Github CLI (`gh`)

The snippets below refer to these environment variables:

    NAME=poc-quicky-20230225
    TEMPLATE=$(realpath ../template)

Create Svelte app

    pnpm create svelte@latest $NAME 
    cd $NAME
    pnpm i

Copy in template files

    cp -r $TEMPLATE/. .

Create infrastructure

    az group create -g $NAME -l westeurope
    az deployment group create -g $NAME --template-file infrastructure/main.bicep

Create Github repo

    gh repo create $NAME --private

Create Git repo and push

    git init . && git add . && git commit -m 'Initial commit'
    git remote add origin git@github.com:gudmundurh/$NAME.git
    git branch -M main
    git push -u origin main

Configure for SWA

    pnpm i -D svelte-adapter-azure-swa

    // in svelte.config.json
    import azure from 'svelte-adapter-azure-swa';
    ...
    kit: {
        adapter: azure()
    }

Set up deployment to SWA

    SECRET=$(az staticwebapp secrets list -g $NAME -n $NAME -o tsv --query properties.apiKey)
    gh secret set AZURE_STATIC_WEB_APPS_API_TOKEN --body "$SECRET"

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
