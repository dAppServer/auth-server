# Auth Server

This is KeyCloak https://www.keycloak.org/ configured to use mysql in a cluster behind a load balancer.

It also includes the following plugins:
- apple-identity-provider-1.6.0.jar
- github-ssh-mapper-1.0.0.jar
- keycloak-config-cli-21.0.0.jar
- keycloak-discord-cli-0.4.0.jar
- keycloak-protocol-cas-21.1.1.jar

## Installing

You will need a SSL for this, first we need to combine the certificate and private key into a p12 file,
then using the Java KeyTool creating a AES encrypted keystore file allowing KeyClock to serve HTTPS correctly.

Create
- conf/cert.crt - The CA signed certificate
- conf/cert.key - The private key
- conf/ca.crt -- The CA Bundle
```shell
openssl pkcs12 -export -in conf/cert.crt -inkey conf/cert.key \ 
-out conf/cert.p12 -name auth -passin "pass:PASSWORD" -passout "pass:PASSWORD" \
-CAfile conf/ca.crt -caname YOUR_HOSTNAME.com 
```

```shell
keytool -importkeystore \ 
-deststorepass PASSWORD -destkeypass PASSWORD -destkeystore conf/server.keystore \
-srckeystore conf/cert.p12 -srcstoretype PKCS12 -srcstorepass PASSWORD \
-alias auth
```
Next, create your .env file by running `cp .env-example .env` then edit the settings for your environment
