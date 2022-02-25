# Node-RED Docker - Watson va a Clase

Este repositorio describe el uso de Node-RED sobre Docker para el proyecto Watson va a Clase (https://www.watsonvaaclase.es) y tiene soporte para diversas arquitecturas 
(amd64, arm32v6, arm32v7, arm64v8 y i386).
Se asume estar familiarizado con Docker y el [Docker Command Line](https://docs.docker.com/engine/reference/commandline/cli/).

## Inicio Rápido
Para ejecutar Docker en su forma más simple, tecleamos:

        docker run -it -p 1880:1880 -v node_red_data:/data --name minodered watsonvaclase/node-red

Vamos a diseccionar el comando:

        docker run              - run this container, initially building locally if necessary
        -it                     - attach a terminal session so we can see what is going on
        -p 1880:1880            - connect local port 1880 to the exposed internal port 1880
        -v node_red_data:/data  - mount the host node_red_data directory to the container /data directory so any changes made to flows are persisted
        --name minodered        - give this machine a friendly local name
        watsonvaclase/node-red  - the image to base it on - currently Node-RED v2.2.2


Running that command should give a terminal window with a running instance of Node-RED.

        Welcome to Node-RED
        ===================

        10 Oct 12:57:10 - [info] Node-RED version: v2.2.2
        10 Oct 12:57:10 - [info] Node.js  version: v12.22.2
        10 Oct 12:57:10 - [info] Linux 4.19.76-linuxkit x64 LE
        10 Oct 12:57:11 - [info] Loading palette nodes
        10 Oct 12:57:16 - [info] Settings file  : /data/settings.js
        10 Oct 12:57:16 - [info] Context store  : 'default' [module=memory]
        10 Oct 12:57:16 - [info] User directory : /data
        10 Oct 12:57:16 - [warn] Projects disabled : editorTheme.projects.enabled=false
        10 Oct 12:57:16 - [info] Flows file     : /data/flows.json
        10 Oct 12:57:16 - [info] Creating new flow file
        10 Oct 12:57:17 - [warn]

        ---------------------------------------------------------------------
        Your flow credentials file is encrypted using a system-generated key.

        If the system-generated key is lost for any reason, your credentials
        file will not be recoverable, you will have to delete it and re-enter
        your credentials.

        You should set your own key using the 'credentialSecret' option in
        your settings file. Node-RED will then re-encrypt your credentials
        file using your chosen key the next time you deploy a change.
        ---------------------------------------------------------------------

        10 Oct 12:57:17 - [info] Starting flows
        10 Oct 12:57:17 - [info] Started flows
        10 Oct 12:57:17 - [info] Server now running at http://127.0.0.1:1880/

        [...]

You can then browse to `http://{host-ip}:1880` to get the familiar Node-RED desktop.


The advantage of doing this is that by giving it a name (mynodered) we can manipulate it
more easily, and by fixing the host port we know we are on familiar ground.
Of course this does mean we can only run one instance at a time... but one step at a time folks...

If we are happy with what we see, we can detach the terminal with `Ctrl-p` `Ctrl-q` - the
container will keep running in the background.

To reattach to the terminal (to see logging) run:

        $ docker attach mynodered

If you need to restart the container (e.g. after a reboot or restart of the Docker daemon):

        $ docker start mynodered

and stop it again when required:

        $ docker stop mynodered

**Healthcheck**: to turn off the Healthcheck add `--no-healthcheck` to the run command.

## Image Variations
The Node-RED images come in different variations and are supported by manifest lists (auto-detect architecture).
This makes it more easy to deploy in a multi architecture Docker environment. E.g. a Docker Swarm with mix of Raspberry Pi's and amd64 nodes.

The tag naming convention is `<node-red-version>-<node-version>-<image-type>-<architecture>`, where:
- `<node-red-version>` is the Node-RED version.
- `<node-version>` is the Node JS version.
- `<image-type>` is type of image and is optional, can be either _none_ or minimal.
    - _none_ : is the default and has Python 2 & Python 3 + devtools installed
    - minimal : has no Python installed and no devtools installed
- `<architecture>` is the architecture of the Docker host system, can be either amd64, arm32v6, arm32v7, arm64, s390x or i386.

The minimal versions (without python and build tools) are not able to install nodes that require any locally compiled native code.

For example - to run the latest minimal version, you would run
```
docker run -it -p 1880:1880 -v node_red_data:/data --name mynodered nodered/node-red:latest-minimal
```

The Node-RED images are based on [official Node JS Alpine Linux](https://hub.docker.com/_/node/) images to keep them as small as possible.
Using Alpine Linux reduces the built image size, but removes standard dependencies that are required for native module compilation. If you want to add dependencies with native dependencies, extend the Node-RED image with the missing packages on running containers or build new images see [docker-custom](docker-custom/README.md) and the documentation on the Node-RED site [here](https://nodered.org/docs/getting-started/docker-custom).

The following table shows the variety of provided Node-RED images.

| **Tag**                    |**Node**| **Arch** | **Python** |**Dev**| **Base Image**         |
|----------------------------|--------|----------|------------|-------|------------------------|
| 2.2.2-12-amd64             |   12   | amd64    |   2.x 3.x  |  yes  | amd64/node:12-alpine   |
| 2.2.2-12-arm32v6           |   12   | arm32v6  |   2.x 3.x  |  yes  | arm32v6/node:12-alpine |
| 2.2.2-12-arm32v7           |   12   | arm32v7  |   2.x 3.x  |  yes  | arm32v7/node:12-alpine |
| 2.2.2-12-arm64v8           |   12   | arm64v8  |   2.x 3.x  |  yes  | arm64v8/node:12-alpine |


| **Tag**                    |**Node**| **Arch** | **Python** |**Dev**| **Base Image**         |
|----------------------------|--------|----------|------------|-------|------------------------|
| 2.2.2-14-amd64             |   14   | amd64    |   2.x 3.x  |  yes  | amd64/node:14-alpine   |
| 2.2.2-14-arm32v6           |   14   | arm32v6  |   2.x 3.x  |  yes  | arm32v6/node:14-alpine |
| 2.2.2-14-arm32v7           |   14   | arm32v7  |   2.x 3.x  |  yes  | arm32v7/node:14-alpine |
| 2.2.2-14-arm64v8           |   14   | arm64v8  |   2.x 3.x  |  yes  | arm64v8/node:14-alpine |


