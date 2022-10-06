# docs-zot
zot Project Documentation

## Documentation site generation
In order to generate the documentation website locally. Clone the repository and run the following commands
```console
npm install
npm start
```
And open the index.html file inside the build/site folder generated.

## Configuring docs source
By default this project will pull the upstream repository `project-zot/docs-zot` in order to generate the website.
The project can be configured to pull the adoc files from a specific fork modify the sources section of the `antora-playbook.yml` file.
```yml
content:
  #Repositories to pull for docs
  sources: 
  - url: https://github.com/[your-github-username]/docs-zot
    branches: main
```

The project also supports configuration to pull from the local files instead of a remote by modifying the configuration as such:

```yml
content:
  #Repositories to pull for docs
  sources: 
  - url: ./
```
Note: remove the branch reference in order to generate based on local files.
Note: read following subsection if planning on building locally

## Building local UI bundle
The project is configured to use a custom ui bundle, available in this repository inside the /ui directory, the ci/cd pipeline will set up everything on merge, however, if you want to use our custom bundle for local builds, you first have to run the following commands once, before generating the website with `npm start` 
```bash
npm run install:ui
npm run build:ui
```
Note: Once the ui bundle is built, it doesn't need to be built on each subsequent `npm start` generation.
Note: If the ui bundle is not built locally when generating the website, it will use the default antora ui bundle instead.

## Github pages
The site is automatically generated and deployed to github pages after every push to the main brach of the `project-zot/docs-zot` repository and is hosted at [zotregistry.io](https://zotregistry.io/docs-zot/)