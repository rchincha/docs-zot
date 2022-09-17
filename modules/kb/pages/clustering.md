# `zot` Clustering

## Highlights

* Scale-out support with stateless `zot` instances
* Both bare-metal and Kubernetes deployments

`zot` supports a clustering scheme with stateless zot instances/replicas
fronted by a loadbalancer and a shared remote backend storage to ensure
high-availability of the `zot` registry. With this scheme, even if a few
replicas fail or become unavailable, the registry service still remains
available. Furthermore, this scheme can increase aggregate network throughput
by loadbalancing across the many zot replicas.

Clustering is supported both in bare-metal and Kubernetes environments.

NOTE: the remote backend storage must be
[S3 API-compatible](https://docs.aws.amazon.com/AmazonS3/latest/API/Welcome.html)

# Bare-metal Deployment

## Prerequisites

* A highly-available loadbalancer such as `HAProxy` configured to point to
  `zot` replicas.

* Multiple `zot` replicas as systemd services hosted on mutiple hosts or VMs.

* AWS S3 API-compatible remote backend storage.

# Kubernetes Deployment

## Prerequisites

* A `zot` Kubernetes
  [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
  with required number of replicas.

* AWS S3 API-compatible remote backend storage.

* A `zot` Kubernetes [Service](https://kubernetes.io/docs/concepts/services-networking/service/).

* A `zot` Kubernetes [Ingress Gateway](https://kubernetes.io/docs/concepts/services-networking/ingress/) if the service needs to be exposed outside.

# Stateless `zot`

`zot` maintains two types of durable state - 1) the actual image data itself,
2) image metadata in its cache. In this scheme, the former is stored in the
remote storage backend, and for a stateless `zot` all that remains is to
disable the cache by turning off both deduplication and garbage collection.

# Ecosystem tools

Note that the Distribution Specification imposes certain rules about the HTTP
URI paths which various ecosystem tools conform to so care must be taken about
the HTTP prefixes during loadbalancing and ingress gateway configuration.
