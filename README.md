# pre-commit-kustomize-check

`pre-commit-kustomize-check` utilizes a docker container to run `kustomize build` against directories in your repository. This repository is based on [pre-commit-docker-kustomize](https://github.com/dmitri-lerko/pre-commit-docker-kustomize),
with a few crucial improvements:

- `kustomize-check` defaults to using a pre-built image, which drastically speeds up checks, as the image can be cached locally. If you prefer to build the image locally for security, you can utilize the `kustomize_check_local` hook instead, which utilizes the original behavior of building the docker image locally for each run.
- `kustomize-check` utilizes renovate to automatically keep up with upstream versions of the `kustomize` binary. `kustomize` version availability starts with `v4.5.6`
- the `kustomize_check` docker image stored in dockerhub is now multiarch, allowing it to be run natively on the following platforms: `linux/amd64`, `linux/arm64`, `linux/ppc64le`, `linux/s390x`

## Configuration

`pre-commit-kustomize-check` utilizes standard pre-commit hook configuration.

### Global Config Options

- `rev`: the version of `kustomize` you wish to use in this hook (this repository is tagged by `kustomize` version).
- `repo`: this repo (`https://github.com/rtrox/pre-commit-kustomize-check`)

### Hook configuration

- `id`: `kustomize_check`,  `kustomize_check_local`, or `kustomize_check_system`.
  - `kustomize_check` uses the dockerhub image built by this repo
  - `kustomize_check_local` builds the docker image locally for each run.
  - `kustomize_check_system` does not use docker, and instead uses the kustomize binary already installed on your system
- `name`: A unique name which will be printed with `pre-commit` output.
- `args`: The directory you wish to build with kustomize

### Example Config

```yaml
---
fail_fast: false
repos:
  - repo: https://github.com/adrienverge/yamllint
    rev: v1.28.0
    hooks:
      - args:
          - --config-file
          - .github/lint/.yamllint.yaml
        id: yamllint
  - repo: https://github.com/rtrox/pre-commit-kustomize-check
    rev: v5.8.0
    hooks:
      # Use docker image published by this repo
      - id: kustomize_check
        name: kustomize-x86-system
        args: [cluster-cd/system/x86]
        verbose: false
      # Build docker image locally
      - id: kustomize_check_local
        name: kustomize-x86-infra
        args: [cluster-cd/infra/x86]
        verbose: false
      # Use the kustomize binary installed on your system
      - id: kustomize_check_binary
        name: kustomize-x86-apps
        args: [cluster-cd/infra/apps]
        verbose: false
```

## Building the Multi Arch image locally for Testing

[Docker Instructions](https://www.docker.com/blog/how-to-rapidly-build-multi-architecture-images-with-buildx/#:~:text=Building%20Multi%2DArchitecture%20Images%20with,manifest%20list%20to%20Docker%20Hub.)

```bash
docker buildx create --name kustomize-precheck-builder --use --bootstrap
docker buildx build \
    --platform linux/amd64,linux/arm64,linux/ppc64le,linux/s390x \
    --tag <your_docker_username>/kustomize_check:latest .
```
