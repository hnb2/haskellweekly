# https://docs.docker.com/engine/reference/builder/
FROM alpine:3.10.2

  WORKDIR /opt/haskellweekly
  RUN apk add --no-cache cabal ghc git libpq musl-dev postgresql-dev wget zlib-dev

  COPY cabal.project haskellweekly.cabal ./
  RUN cabal v2-update
  RUN cabal v2-build --enable-tests --only-dependencies

  COPY . .
  RUN cabal v2-test
  RUN cabal v2-install .
  RUN cp ~/.cabal/bin/haskellweekly /usr/local/bin/

FROM alpine:3.10.2

  RUN apk add --no-cache gmp libffi libpq
  COPY --from=0 /usr/local/bin/haskellweekly /usr/local/bin/
  COPY data/ /var/opt/haskellweekly/
  ENV DATA_DIRECTORY /var/opt/haskellweekly
  CMD haskellweekly
