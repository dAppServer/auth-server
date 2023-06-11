FROM quay.io/keycloak/keycloak:latest as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

WORKDIR /opt/keycloak

# A example build step that downloads a JAR file from a URL and adds it to the providers directory
#ADD --chown=keycloak:keycloak <MY_PROVIDER_JAR_URL> /opt/keycloak/providers/myprovider.jar
ENV KC_DB=mysql

# for demonstration purposes only, please make sure to use proper certificates in production instead
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore || true
RUN /opt/keycloak/bin/kc.sh build


FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/
COPY ./providers/ /opt/keycloak/providers/

VOLUME ./conf /opt/keycloak/conf

# change these values to point to a running postgres instance
ENV KC_DB=mysql
ENV KC_DB_URL_HOST=localhost
ENV KC_DB_USERNAME=auth
ENV KC_DB_PASSWORD=admin
ENV KC_HOSTNAME=localhost
ENV KC_PROXY="edge"
ENV KC_HTTP_ENABLED=true
ENV KC_HOSTNAME_STRICT=false
ENV KC_FEATURES="docker,token-exchange,account-api,account2,web-authn,impersonation,js-adapter,authorization,admin2,recovery-codes,scripts,update-email,par"

CMD start
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
