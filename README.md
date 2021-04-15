# multiarch-container

Example repository how to create a multiarch container with Docker Hub. The `hooks` folder contain build hooks for Docker Hub CI infrastructure. `hooks/push` creates a common manifest for all architectures.

Build script `build.sh` can run separat on local machine. It build architectures defined in `build.arch` with `podman` and `docker`. Docker need to have the experimental cli enabled either in config or environment.

Images print out architecture.

## Supported tags

* `latest`
* `1.0.0`

## Usage

```bash
docker run --rm -t aheimsbakk/multiarchitecture-container:latest
```

## Tips

Enable Docker experimental cli.

```bash
export DOCKER_CLI_EXPERIMENTAL=enabled
```

Build images locally

```build
./build.sh Dockerfile multiarch-container:latest
```

Dockers official documentation of to use hooks.

* https://docs.docker.com/docker-hub/builds/advanced/
