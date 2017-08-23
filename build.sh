#!/bin/sh

set -e

ERLANG_VERSION=20.0.1
ELIXIR_VERSION=1.5.1
NODE_VERSION=8.4.0
YARN_NODE_VERSION=latest

# Generate
mkdir -p build

## Base
sed -e s/\${ERLANG_VERSION}/${ERLANG_VERSION}/ Dockerfile.erlang > build/Dockerfile.erlang
sed -e s/\${ELIXIR_VERSION}/${ELIXIR_VERSION}/g Dockerfile.elixir | sed -e s/\${ERLANG_VERSION}/${ERLANG_VERSION}/ > build/Dockerfile.elixir
sed -e s/\${ELIXIR_VERSION}/${ELIXIR_VERSION}/g Dockerfile.phoenix | sed -e s/\${ERLANG_VERSION}/${ERLANG_VERSION}/ | sed -e s/\${NODE_VERSION}/${NODE_VERSION}/g | sed -e s/\${YARN_NODE_VERSION}/${YARN_NODE_VERSION}/g > build/Dockerfile.phoenix

## Hipe
sed -e s/\${ELIXIR_VERSION}/${ELIXIR_VERSION}/g Dockerfile.elixir-hipe | sed -e s/\${ERLANG_VERSION}/${ERLANG_VERSION}/ > build/Dockerfile.elixir-hipe
sed -e s/\${ELIXIR_VERSION}/hipe-${ELIXIR_VERSION}/g Dockerfile.phoenix | sed -e s/\${ERLANG_VERSION}/${ERLANG_VERSION}/ | sed -e s/\${NODE_VERSION}/${NODE_VERSION}/g | sed -e s/\${YARN_NODE_VERSION}/${YARN_NODE_VERSION}/g > build/Dockerfile.phoenix-hipe

# Build
cd build

## Base
docker build --tag ianluites/erlang:${ERLANG_VERSION} -f Dockerfile.erlang .
docker build --tag ianluites/elixir:${ELIXIR_VERSION}-${ERLANG_VERSION} -f Dockerfile.elixir .
docker build --tag ianluites/phoenix:${ELIXIR_VERSION}-${ERLANG_VERSION} -f Dockerfile.phoenix ../

## Hipe
# docker build --tag ianluites/elixir:hipe-${ELIXIR_VERSION}-${ERLANG_VERSION} -f Dockerfile.elixir-hipe .
# docker build --tag ianluites/phoenix:hipe-${ELIXIR_VERSION}-${ERLANG_VERSION} -f Dockerfile.phoenix-hipe .

# Push
## Base
docker push ianluites/erlang:${ERLANG_VERSION}
docker push ianluites/elixir:${ELIXIR_VERSION}-${ERLANG_VERSION}
docker push ianluites/phoenix:${ELIXIR_VERSION}-${ERLANG_VERSION}

## Hipe
# docker push ianluites/elixir:hipe-${ELIXIR_VERSION}-${ERLANG_VERSION}

# Cleanup
cd ../
rm -Rf build
