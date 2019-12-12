FROM ipac/firefly:release-2019.3.2

USER root

## Install the icommands, curl, and wget
# RUN apt-get update \
#     && apt-get install -y --no-install-recommends wget gnupg curl \
#     && apt-get clean \
#     && rm -rf /usr/lib/apt/lists/*

COPY www /local/www
