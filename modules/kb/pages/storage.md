# Storage Model

Data handling in `zot` revolves around two main ideas, that data and APIs on
the wire conform to the Distribution Specification and data on the disk
conforms to the OCI Image Layout specification. To elaborate on this, any
client which is Distribution Specification compliant can read from or write to
a `zot` registry. Furthermore, the actual storage is simply an OCI Image
Layout. So with just these two specification documents in hand, the entire data
flow inside should be easily understood.

Also **NOTE** that `zot` does not implement or support any other vendor-specific
protocols including that of Docker.

## Hosting an OCI Image Layout

Since the OCI Image Layout is a first-class type in `zot`, it can readily host
and serve one or more directories holding a valid OCI image layout
after-the-fact. This property of `zot` is suitable for use cases where
container images are independently built, stored and transferred, but
need to be served over the network at a later time or stage.

# Storage Backends

The following types of storage backends are supported.

## Local Filesystem

`zot` operates on directories or folders and files and at the very minimum
requires one root directory to store and host data. Additional folders can also
be specified which can be hosted and over HTTP APIs, they all appear to be a
single data store.

**NOTE** that even remote filesystems which are
mounted and accessible locally such as `NFS` or `fuse` fit under this model.

## Remote Filesystem

`zot` can also store data on cloud backend via their own storage APIs.
Currently, only the AWS S3 storage backend is supported.

# Storage Configuration

To cater to the requirements of varied environments ranging from cloud,
on-prem to IoT, exposing flexibility in storage capabilities is a key tenet.

## Commit

Most modern filesystems buffer and flush data to disk after a delay due to
performance considerations but at the cost of higher memory usage. However, for
embedded devices, memory is very limited and hence at a premium and it is
desirable to flush data to disk more frequently. The storage configuration
exposes an option called `commit` which by default is off but when turned on
causes data writes to be committed to disk immediately.

## Deduplication

This a storage space saving feature wherein only a single copy of the content is
maintained on disk while there could be many references to it via different
image manifests. This feature is also available for supported cloud storage
backends.

## Garbage Collection

Once an image is deleted by virtue of deleting an image manifest, the
corresponding blobs can be reaped to free up space. However, since Distribution
Specification APIs are not transactional between blob and manifest lifecycle,
care must be taken so as to not the storage in an inconsistent state. Garbage
collection in `zot` is an inline feature meaning it is **not** necessary to
take the registry offline. The configuration model allows for enabling and
disabling garbage collection along with a tunable delay which can be set
depending on client network speeds and size of blobs.

## Scrub

Available as an _extension_, it is also possible to ascertain data validity by
computing hashes on blobs periodically and continuously so that any bit rot is
caught and reported early.
