# Architecture

`zot` is a OCI-native container image registry, and in this document we discuss
the overall architecture with an emphasis on the various design choices that
have been made.

# Design Goals

## OCI-first

* **Strongly conforms** to the [OCI Distribution Specification](https://github.com/opencontainers/distribution-spec)

`zot` intends to be **the** reference implementation for the OCI Distribution
Specification. In fact, it does not support any other vendor protocol or spec.

* **[OCI Image Specification](https://github.com/opencontainers/image-spec) storage layout**

The default and only supported storage layout is the OCI Image Layout. The
implications of this choice are that any OCI image layout can be served by
`zot` and conversely, `zot` converts data on-the-wire into a OCI image
layout.

## Single binary model

`zot` is a single binary with all features included so that deployment by
itself is extremely simple in various environments (bare-metal, cloud and
embedded devices) while behavior is controlled by configuration.

## Enable Only What You Need

There is a clear separation between the core OCI-compliant HTTP APIs and
storage functionality and the other add-on features modeled as _extensions_.
The additional features can be selectively enabled both at build-time and run-time.
[NOTE: add cross ref to the right article about minimal/full builds]

# Overall Architecture

[NOTE: include the image here]

## Interaction

There are two types of external interaction with `zot` - 1) clients performing
data or meta-data queries, and 2) configuration. All client-side interaction
happens over HTTP APIs. The core data path queries are governed by the
Distribution Specification. All additional meta-data queries by a graphQL
interface if the `search` extension is enabled and if not falls back to the
core APIs.

## Configuration

There is a single configuration file that governs `zot` instance behavior.
Although note that some parts of the configuration which contain sensitive
credentials are stored in their own files and these files are referenced in the
main configuration file. This is done so that stricter permissions can be
enforced on those files if stored locally, and also modeling as external files
allows for Kubernetes
[`Secrets`](https://kubernetes.io/docs/concepts/configuration/secret/).

The configuration itself is separated into `http`, `storage`, `log` and
`extension` governing the behavior of various components.

## Authentication and Authorization

Both authentication and authorization are supported natively in `zot`. These
controls are enforced before access is allowed into the storage layer. More
details are available here. [NOTE: add a cross-ref to authN doc]

## Storage Driver Support

`zot` supports any modern local filesystem, and if deduplication is desired
then a filesystem with hard-link support is required.

There is also support for remote filesystems such as AWS S3 or any AWS
S3-compatible storage systems. Additional driver support is planned in the roadmap.
Note that `zot` does support deduplication even for remote filesystems.

## Security Scanning

`zot` integrates with the [`trivy`](https://github.com/aquasecurity/trivy)
security scanner to scan container images for any vulnerabilities. The database
is kept up to date by periodically (also controlled by a configuration
parameter) downloading any vulnerability database updates. The user remains
agnostic of the actual scanner implementation which may change over time.

## Extensions

The following extensions are currently supported. Wherever applicable
extensions can be dynamically discovered using OCI Distribution Specification
[extensions support](https://github.com/opencontainers/distribution-spec/tree/main/extensions).

* **Search**

One of the key functions for a container image registry which is essentially a
graph of blobs is to be able to perform interesting image and graph traversal
queries such as "does an image exist?", "what is its size?", "does an image
depend on this image via its layers?", "what vulnerabilities in an image? or
its dependent images?" and so on.

The user interacts with this extension via a graphQL endpoint and the schema is
published with every release.

* **Sync**

You can set up a local mirror pointing to an upstream `zot` instance with
various container image download policies, including on-demand and periodic
downloads. This is useful when you do not want to overwhelm the upstream
instance or the upstream instance has rate-limited access. 

Note that `docker.io` as an upstream mirror is supported.

* **Lint**

The _lint_ extension can enforce certain policies about the image or the image
metadata. Currently, it can enforce if the uploaded image has the right
annotations (such as the author or the license). This helps with image
compliance issues.

* **Scrub**

Although container images are content-addressable with their SHA256 checksums
and validations are performed during storage and retrieval, it is possible that
bit-rot sets in when not in use. The _scrub_ extension actively scans container
images in background to proactively detect an errors.

## Background Tasks

There are several periodic tasks that occur such as garbage collection, sync
mirroring and scrubbing, and a task scheduler handles these tasks in the
background while being mindful to not degrade or interrupt foreground tasks
running in the context of HTTP APIs.
