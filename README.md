# pre-commit-kustomize-check
Test build kustomizations via Docker image during pre-commit

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
    rev: 4.5.6
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