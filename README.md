# pre-commit-kustomize-check

`pre-commit-kustomize-check` utilizes a docker container to run `kustomize build` against directories in your repository. This repository is based on [pre-commit-docker-kustomize](https://github.com/dmitri-lerko/pre-commit-docker-kustomize),
with a few crucial improvements:
- `kustomize-check` defaults to using a pre-built image, which drastically speeds up checks, as the image can be cached locally. If you prefer to build the image locally for security, you can utilize the `kustomize_check_local` hook instead, which utilizes the original behavior of building the docker image locally for each run.
- `kustomize-check` utilizes renovate to automatically keep up with upstream versions of the `kustomize` binary. `kustomize` version availability starts with `v4.5.6`

# Configuration

`pre-commit-kustomize-check` utilizes standard pre-commit hook configuration.

### Global Config Options:
- `rev`: like normally, this points to the git tag you wish to use for 
# Build Multi-Arch Image Locally
[Docker Instructions](https://www.docker.com/blog/how-to-rapidly-build-multi-architecture-images-with-buildx/#:~:text=Building%20Multi%2DArchitecture%20Images%20with,manifest%20list%20to%20Docker%20Hub.)
```bash
docker buildx create --name kustomize-precheck-builder --use --bootstrap
docker buildx build \
    --platform linux/amd64,linux/arm64,linux/ppc64le,linux/s390x \
    --tag <your_docker_username>/kustomize_check:latest .
```

# Example Config
```
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
    rev: v4.5.7
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
```