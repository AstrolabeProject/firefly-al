FROM ipac/firefly:release-2019.4.0

USER root

## Install the icommands, curl, and wget
# RUN apt-get update \
#     && apt-get install -y --no-install-recommends wget gnupg curl \
#     && apt-get clean \
#     && rm -rf /usr/lib/apt/lists/*

# possible alternative to the specifying this in JAVA_OPTIONS:
RUN echo "securerandom.source=file:/dev/./urandom" >> /usr/local/openjdk-11/lib/security/java.security

COPY www /local/www
