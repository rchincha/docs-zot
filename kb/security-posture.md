# Security Posture

The `zot` project takes a defense-in-depth approach to security and
industry-standard best practices are applied at various stages. We also
recognize that security hardening and product features are sometimes in
conflict with each other and in such cases we also provide flexibility both at
build and deployment time.

# Build-time Hardening

The following are the steps taken during build-time.

## PIE Build-mode

The `zot` binary is built with PIE build-mode [[1]](#ref-1) enabled to take advantage of ASLR
support in modern operating systems such as Linux [[2]](#ref-2),[[3]](#ref-3).
While `zot` is intended to be a long-running service (without frequent
restarts), it prevents attackers from developing a generic attack that depends
on predictable memory addresses _across_ multiple `zot` deployments.

## Conditional Builds

Functionality in `zot` is broadly organized as a _core_ [Distribution Specification]($ref-4)
implementation and additional features as _extensions_. The rationale behind
this approach is to minimize or control library dependencies that get included in the
binary and consequently the attack surface.

We currently build and release two image flavors:

* **minimal**, which is a minimal Distribution Specification conformant registry, and

* **full**, which incorporates the _minimal_ build **and** all extensions

The _minimal_ flavor is for the security-minded and minimizes the number of
dependencies and libraries. On the other hand, the _full_ flavor is for the
functionality-minded with the caveat that the attack surface of the binary is
potentially broader. However by no means are these the only options. Our build (via
the `Makefile`) provides the flexibility to pick and choose extensions in order
to build a binary between _minimal_ and _full_. For example,

``` make EXTENSIONS=search binary ```

will produce a `zot` binary with only the _search_ feature enabled.

## CI/CD Pipeline

`zot` CI/CD process attempts to align with the 
[Open Source Security Foundation](#ref-5) Best Practices guide to 
achieve high code quality.

### Code Reviews

`zot` is an opensource project and all code submissions are open and
transparent. Every pull request (PR) submitted to the project repository must
be reviewed by the code owners. We have additional CI/CD workflows monitoring
for unreviewed commits.

### CI/CD Checks

All PRs must pass the full CI/CD pipeline checks including unit, functional and
integration tests, code quality and style checks and performance regressions.
In addition, all binaries produced are subjected to further security scans to
detect any known vulnerabilities.

# Runtime Hardening

The following steps can be taken to harden a `zot` deployment.

## Unprivileged Runtime Process

Running `zot` doesn't require _root_ privileges. In fact, the recommended
approach is to create a separate user/group ID for the `zot` process.

## Authentication

All interactions with `zot` are over HTTP APIs and `htpasswd`-based local
authentication, LDAP, mutual TLS and token-based authentication mechanisms are
supported. It is strongly recommended to enable a suitable mechanism for your
deployment use case in order to prevent unauthorized access. 
Please see [examples](https://github.com/project-zot/zot/tree/main/examples).

## Access Control

Following authentication, it is further possible to allow or deny actions
by a user on a particular repository stored on the `zot` registry.
Please see [examples](https://github.com/project-zot/zot/tree/main/examples).

# Vulnerability Scans

Apart from the hardening the deployment itself, `zot` also supports security
scanning of container images stored on it.

# Reporting Security Issues

We understand that no software is perfect and in spite of our best efforts,
security bugs may be found. Please refer to our 
[security policy](https://github.com/project-zot/zot/blob/main/SECURITY.md) 
on taking a responsible course of action when reporting security bugs.

# References

<a id="ref-1">[1]</a> https://en.wikipedia.org/wiki/Position-independent_code

<a id="ref-2">[2]</a> https://en.wikipedia.org/wiki/Address_space_layout_randomization 

<a id="ref-3">[3]</a> https://lwn.net/Articles/569635/ 

<a id="ref-4">[4]</a> https://github.com/opencontainers/distribution-spec

<a id="ref-5">[5]</a> https://bestpractices.coreinfrastructure.org/en

<a id="ref-6">[6]</a> https://github.com/project-zot/zot/tree/main/examples 
