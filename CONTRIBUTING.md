# Contributing Guide

The sources of this tutorial docs is in [documentation](./documentation) folder.
The site generation is done my [Antora](https://docs.antora.org/)


## Running site in development mode

After cloning the repositories, navigate to the root of `tekton-tutorial` repository.  You can then either follow the local instructions or the VS Code Remote Containers instructions.

Regardless of which instructions you follow, making any changes to your local repositories above cloned earlier, will be automatically built and the development site gets reloaded automatically.

### Local Development

To run the site locally in development mode you need to have [yarn](https://yarnpkg.com) or [npm](https://nodejs.org/en/) installed with [nodejs](https://nodejs.org) v12.x or above.

Start the development site using `yarn run dev` or `npm run dev` command, this should open a local development site in http://localhost:3000.

### Visual Studio Code Remote Development

If you are using [Visual Studio Code](https://code.visualstudio.com/) with the [Remote Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers), you don't need to install anything locally.

Simply open VS Code from the root of `tekton-tutorial` repository and when prompted indicate that you want to open the folder in a container.

Once the devcontainer is initialized, from the Visual Studio Code terminal run `npm run dev` to start the development site.  (Visual Studio Code should handle all the port forwarding into the devcontainer so that you can interact with the site from an VSCode assigned port on your localhost)

## Send your contribution

Now you are all set,
- Open an Issue in http://github.com/redhat-scholars/tekton-tutorial.git
- Prepare your changes in the respective documentation repository
- Send the PR to respective repositories listed above

We try to follow the Git commit messages using http://karma-runner.github.io/4.0/dev/git-commit-msg.html and that's not a hard rule ;)
