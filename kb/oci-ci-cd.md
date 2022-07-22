# Building a OCI-native Container Image CI/CD Pipeline

The [Open Container Initiative](https://opencontainers.org/) is an open
governance structure for the express purpose of creating open industry
standards around container formats and runtimes.

This document describes a step-by-step procedure towards achieving a OCI-native
secure software supply chain using `zot` in collaboration with other opensource
tools.

## Build Images

[`stacker`](https://github.com/project-stacker/stacker) is a standalone tool
for building OCI images via a declarative yaml format. The output of the build
process is a container image in a OCI layout.

```stacker build -f <stackerfile.yaml>``` 

## Image Registry

[`zot`](https://github.com/project-zot/zot) is a production-ready
vendor-neutral OCI image registry server purely based on OCI [Distribution
Specification](https://github.com/opencontainers/distribution-spec).

If `stacker` was used to build the OCI image, it can be also used to publish
the built image to a OCI registry.

```stacker publish --url <url> --username <user> --password <password>```

Alternatively, you can also use
[`skopeo`](https://github.com/containers/skopeo) which is a command line
utility that performs various operations on container images and image
repositories.

```skopeo copy --format=oci oci:<oci-dir>/image:tag docker://<zot-server>/image:tag```

## Signing Images

[`cosign`](https://github.com/sigstore/cosign) is a tool that performs
container Signing, verification and storage in an OCI registry.

```

cosign generate-key-pair

cosign sign --key cosign.key <zot-server>/image:tag

```

## Deploying Container Images

[`cri-o`](https://github.com/cri-o/cri-o) is an implementation of the
Kubernetes CRI (Container Runtime Interface) to enable using OCI (Open
Container Initiative) compatible runtimes. It is a lightweight alternative to
using Docker as the runtime for kubernetes.

```
apiVersion: v1
kind: Pod
metadata:
  name: example-pod
spec:
  containers:
  - name: example-container
    image: <zot-server>/image:tag
```

## Container Image Verification

[`cosigned`](https://artifacthub.io/packages/helm/sigstore/cosigned#deploy-cosigned-helm-chart)
is a image admission controller that validates container images before
deploying them.

```
kubectl create namespace cosign-system

kubectl create secret generic mysecret -n \
cosign-system --from-file=cosign.pub=./cosign.pub

helm repo add sigstore https://sigstore.github.io/helm-charts

helm repo update

helm install cosigned -n cosign-system sigstore/cosigned --devel --set cosign.secretKeyRef.name=mysecret
```

# References

<a href="ref-1">[1]</a> https://opencontainers.org/

<a href="ref-2">[2]</a> https://github.com/project-stacker/stacker

<a href="ref-3">[3]</a> https://github.com/opencontainers/distribution-spec

<a href="ref-4">[4]</a> https://github.com/containers/skopeo

<a href="ref-5">[5]</a> https://github.com/project-zot/zot

<a href="ref-6">[6]</a> https://github.com/cri-o/cri-o

<a href="ref-7">[7]</a> https://github.com/sigstore/cosign

<a href="ref-8">[8]</a> https://artifacthub.io/packages/helm/sigstore/cosigned#deploy-cosigned-helm-chart
