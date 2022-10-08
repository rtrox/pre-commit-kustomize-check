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