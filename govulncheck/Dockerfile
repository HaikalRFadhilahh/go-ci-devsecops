# Import Base Image
FROM golang:1.24.3-alpine3.21 AS libary-compiler

# Configure ENV
ENV CGO_ENABLED=0 \
    GOOS=linux  

# Install govulncheck
RUN go install golang.org/x/vuln/cmd/govulncheck@v1.1.4

# Alpine Linux Runner
FROM golang:1.24.3-alpine3.21 AS library-runner

# Setting Working Directory (Default PWD / Print Working Directory)
WORKDIR /app

# Copy 
COPY --from=libary-compiler /go/bin/govulncheck /usr/local/bin/govulncheck

# Give Access Exec for govulncheck
RUN chmod a+x /usr/local/bin/govulncheck

# Copy Entrypoint sh
COPY ./entrypoint.sh /entrypoint.sh

# Entrypoint for Running govulncheck
ENTRYPOINT [ "/bin/sh","/entrypoint.sh" ]
