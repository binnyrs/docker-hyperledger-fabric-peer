# Dockerfile for Hyperledger peer image. This actually follow yeasy/hyperledger-fabric
# image and add default start cmd.
# Data is stored under /var/hyperledger/db and /var/hyperledger/production

FROM yeasy/hyperledger-fabric-base:latest
LABEL maintainer "Baohua Yang <yeasy.github.com>"

EXPOSE 7051

# ENV CORE_PEER_MSPCONFIGPATH $FABRIC_CFG_PATH/msp/sampleconfig

# ignore handshake, since not using mutual TLS
ENV CORE_PEER_GOSSIP_SKIPHANDSHAKE true

# Done in base
# ENV FABRIC_CFG_PATH /etc/hyperledger/fabric
# RUN mkdir -p $FABRIC_CFG_PATH

# install fabric peer and copy sampleconfigs
RUN cd $FABRIC_HOME/peer \
    && CGO_CFLAGS=" " go install -ldflags "$LDFLAGS -linkmode external -extldflags '-static -lpthread'" \
    && go clean

# This will start with joining the default chain "testchainid"
# Use `peer node start --peer-defaultchain=false` will join no channel by default. 
# Then need to manually create a chain with `peer channel create -c test_chain`, then join with `peer channel join -b test_chain.block`.
CMD ["peer","node","start"]
