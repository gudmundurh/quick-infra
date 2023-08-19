# Infrastructure for quick POCs

_Light-weight and (somewhat) production grade skeleton for building web apps on Azure super-quickly._

Get started: Follow [the steps in the template README](template/README.md).


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

1. [An readme file](template/README.md), containing all the necessary commands
1. [Bicep file](template/infrastructure/main.bicep) with Azure infrastructure
2. Github Actions pipeline for deploying to Azure SWA

The infrastructure footprint is limited to a single Azure resource group and a repository in Github, sharing the same name. This makes it easy to delete the project down the line.

# Ideas

1. Tag Azure resources and the resource group with initial creation date
