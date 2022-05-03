# `zot` Clustering

`zot` supports a clustering scheme with stateless zot instances/replicas and a
shared remote storage to ensure high-availability of the `zot` registry.  With
this scheme, even if a few replicas fail or become unavailable, the registry
service still remains available. Furthermore, this scheme can increase
aggregate network throughput by loadbalancing across the many zot replicas.

Clustering is supported both in bare-metal and Kubernetes environments.

# Bare-metal Deployment

## Prerequisites

* A highly-available loadbalancer such as HaProxy configured to point to backend zot replicas
* Remote storage (mounted locally or S3-compatible)
* `zot` configuration using above remote storage and with deduplication and garbage-collection disabled

# Kubernetes Deployment

## Prerequisites

* `helm` version X.Y.Z
* `Kubernetes` version A.B.C
* Ingress controller
* Remote storage (S3-compatible)
* `zot` configuration (as a ConfigMap) using above remote storage and with deduplication and garbage-collection disabled 

Note that if authentication is enabled on `zot` itself, then that configuration must also be identical across all replicas.

# Solution Overview

clients <--> loadbalancer <--> [zot replicas] <--> [[remote storage]]

All incoming requests from clients are first intercepted at the loadbalancer
and then routed to one of the `zot` replicas which then interfaces with the
remote storage.
