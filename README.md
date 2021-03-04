# parse_keycloak

A playground for authenticating a parse based Flutter application against a KeyCloak server using an ldap user federation.

## Getting Started

### Start servers
```shell script
docker-compose up -d
```

### Stop servers
```shell script
docker-compose down
```

### Stop servers and delete data
```shell script
docker-compose down -v
```

### Links
- [phpldapadmin](http://localhost:8081) (login: `cn=admin,dc=example,dc=org`, password: `password`)
- [KeyCloak](http://localhost:8080) (login: `admin`, password: `password`)

