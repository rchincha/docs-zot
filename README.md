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
## Github pages
The site is automatically generated and deployed to github pages after every push to the main brach of the `project-zot/docs-zot` repository and is hosted at [zotregistry.io](https://zotregistry.io/docs-zot/)