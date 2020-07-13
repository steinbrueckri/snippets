# Docker

## **Docker**

```bash
docker rm -v $(docker ps -a | grep "winexec-mount.*Created" | awk '{print $1}‘)
```

Find your stopped container id

```bash
docker ps -a
```

## Commit the stopped container

This command saves modified container state into a new image user/test_image

```bash
docker commit $CONTAINER_ID user/test_image
```

**Start/run with a different entry point:**

```bash
docker run -ti --entrypoint=sh user/test_image
```

[Entrypoint argument description](https://docs.docker.com/engine/reference/run/#/entrypoint-default-command-to-execute-at-runtime)

## Add a restart policy to a container that was already created

In recent versions of docker (as of 1.11) you have an update command:

```bash
docker update --restart=always <container>
```
