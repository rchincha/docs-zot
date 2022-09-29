# User Authentication and Authorization

`zot` configuration model supports both authentication and authorization. The
authentication credentials are used to allow access to `zot`'s HTTP APIs.
Further fine-grained controls on what each action each authenticated user can
perform can be specified using authorization policies.

## Authentication

Authentication credentials are passed over HTTP, and for this reason it is
imperative that TLS be enabled.

```
"http": {
...
    "tls": {
      "cert": "/etc/zot/certs/server.cert",
      "key": "/etc/zot/certs/server.key"
    }
```

### HTTP Basic Authentication

When [basic HTTP authentication](https://www.rfc-editor.org/rfc/rfc7617.html)
is used, the username and password credentials are joined by a colon (:), base64
encoded and passed using the Authorization header.

### HTTP Bearer Authentication

Instead of passing the username and password credentials for every HTTP
request, [token-based authentication](https://www.rfc-editor.org/rfc/rfc6750)
is also supported. The client first contacts the token server, specifies the
credentials and service scope and receives a short-lived token. The client then
passes this token in the `Authorization` header using the `Bearer`
authentiation sceme.

```
"http": {
...
  "auth": {
    "bearer": {
      "realm": "https://auth.myreg.io/auth/token",
        "service": "myauth",
        "cert": "/etc/zot/auth.crt"
    }
  }
```

### mTLS Authentication

`zot` also supports password-less mutual TLS authentication. In this
configuration mode, you must also provide the `cacert` parameter in the TLS
section which will be used to validate the client-side TLS certs.

```
"http": {
...
    "tls": {
      "cert": "/etc/zot/certs/server.cert",
      "key": "/etc/zot/certs/server.key",
      "cacert": "/etc/zot/certs/ca.cert"
    }
```

## Authentication State

The server-side authentication state can be specified and stored in the following forms.

### htpasswd

`htpasswd`-based state is strictly local and requires no additional remote
service to perform authentication. This is useful to have a fail-safe
authentication mechanism in place.

```
$ htpasswd -bBn <username> <password> >> /etc/zot/htpasswd
```

```
"http": {
...
  "auth": {
      "htpasswd": {
        "path": "/etc/zot/htpasswd"
      },
```

### LDAP

You can also integrate with a LDAP based authentication service such as Microsoft Windows Active Directory.

```
"http": {
...
    "auth": {
      "ldap": {
        "address": "ldap.example.org",
        "port": 389,
        "startTLS": false,
        "baseDN": "ou=Users,dc=example,dc=org",
        "userAttribute": "uid",
        "bindDN": "cn=ldap-searcher,ou=Users,dc=example,dc=org",
        "bindPassword": "ldap-searcher-password",
        "skipVerify": false,
        "subtreeSearch": true
      },
```

## Authorization

Just relying on authentication alone gives complete access to the registry.
`zot` also offers access control by the way of repository-level access control
policies. There are four types of policies - anonymous, user-specific, default and admin.

```
"http": {
...
  "accessControl": {
      "repo/**": {
        "anonymousPolicy": ["read"],
        "policies": [
          { "users": [ "charlie" ],
            "actions": [ "read", "create", "update" ]
          }
        ],
        "defaultPolicy": [ "read", "create" ]
      },
       "adminPolicy": {
        "users": [ "admin" ],
        "actions": [ "read", "create", "update", "delete" ]
      }
    }
```

The above example specifies the policy for `repo` and the '**' represents all sub-repositories under `repo`.

### AnonymousPolicy

This policy specifies what unauthenticated users are allowed to do. This is
typically useful when one or more repositories be allowed read-only access.

### User-specific Policy

This policy specifies users and user-specific actions.

### DefaultPolicy

This policy specifies what actions are allowed if a user is authenticated by does match any of the user-specific policies.

### AdminPolicy

This is a global access control policy typically useful to give certain users privileges to perform actions on any repository.
