# parse_keycloak

A playground for authenticating a parse based Flutter application against a KeyCloak server using openid.

## Getting Started

### Generate SSL cert for keycloak:
```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout keycloak.key -out keycloak.crt
```

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

