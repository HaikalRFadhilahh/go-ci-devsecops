# Import Golang Alpine Base Image
FROM golang:1.24.3-alpine3.21 AS library-compiler

# Setting Golang Config (Disabled Using C++ Library and set the image golang for linux OS)
ENV CGO_ENABLED=0 \
    GOOS=linux  

# Install gosec from go install command
RUN go install github.com/securego/gosec/v2/cmd/gosec@v2.22.4

# Import Alpine Image Runner
FROM golang:1.24.3-alpine3.21 AS library-runner

# Copy Binary gosec from library-compiler stage
COPY --from=library-compiler /go/bin/gosec /usr/local/bin/gosec

# Give Access exec for library
RUN chmod a+x /usr/local/bin/gosec

# Setting Working Directory
WORKDIR /app

# Copy Entrypoint
COPY ./entrypoint.sh /entrypoint.sh

# Entrypoint Exec gosec
ENTRYPOINT [ "/bin/sh", "/entrypoint.sh"]