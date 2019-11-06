FROM amd64/golang:1.13
WORKDIR $GOPATH/src/github.com/ankurgel/duss
# Install dep
RUN go get github.com/golang/dep/cmd/dep

ENV PATH=$PATH:$GOPATH/bin

# Install OS dependencies
RUN apt-get update && apt-get install -qq -y --fix-missing --no-install-recommends \
    build-essential supervisor && \
    rm -rf /var/lib/apt/lists/*


##############################################################################
# Configure supervisord
##############################################################################

RUN useradd supervisor -s /bin/false
RUN mkdir -p /var/log/supervisord
RUN mkdir -p /var/cache/supervisord
RUN chown -R supervisor:supervisor /var/log/supervisord
RUN chown -R supervisor:supervisor /var/cache/supervisord

# Copy repo
COPY . .

# Install dependencies
RUN dep ensure

# Build Binary
RUN chmod +x ./build.sh ./deploy/run-server.sh

RUN ./build.sh

ENTRYPOINT ["./deploy/run-server.sh"]
