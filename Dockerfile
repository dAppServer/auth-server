FROM quay.io/keycloak/keycloak:latest as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

WORKDIR /opt/keycloak

# A example build step that downloads a JAR file from a URL and adds it to the providers directory
#ADD --chown=keycloak:keycloak <MY_PROVIDER_JAR_URL> /opt/keycloak/providers/myprovider.jar
ENV KC_DB=mysql

RUN /opt/keycloak/bin/kc.sh build


FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/
COPY ./providers/ /opt/keycloak/providers/

VOLUME ./conf /opt/keycloak/conf

### DATABASE SETTINGS ###
ENV KC_DB=mysql
ENV KC_DB_URL_DATABASE=auth
ENV KC_DB_URL_HOST=10.0.0.3
ENV KC_DB_URL_PORT=3306
ENV KC_DB_URL=jdbc:$KC_DB://$KC_DB_URL_HOST:$KC_DB_URL_PORT/$KC_DB_URL_DATABASE

ENV KC_DB_USERNAME=auth
ENV KC_DB_PASSWORD=password
### HTTP SETTINGS ###
ENV KC_HOSTNAME=auth.host.uk.com
ENV KC_PROXY="edge"
ENV KC_HTTP_ENABLED=true
ENV KC_HOSTNAME_STRICT=false
### KEYCLOAK CONFIG ###
ENV KC_FEATURES="docker,token-exchange,account-api,account2,web-authn,impersonation,js-adapter,authorization,admin2,recovery-codes,scripts,update-email,par"
ENV KC_HTTPS_KEY_STORE_FILE=/opt/keycloak/conf/server.keystore
ENV KC_HTTPS_KEY_STORE_PASSWORD=password

CMD start
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
