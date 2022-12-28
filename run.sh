#!/bin/bash

# required env variables
export AZ_BLOB_PREFIX=
export AZ_BATCH_ACCOUNT_URL=
export AZ_BATCH_ACCOUNT_KEY=
export AZ_BLOB_ACCOUNT_URL=

# optional environment variables with defaults listed

# don't recommend changing 
# export BATCH_POOL_IMAGE_PUBLISHER=microsoft-azure-batch
# export BATCH_POOL_IMAGE_OFFER=ubuntu-server-container
# export BATCH_POOL_IMAGE_SKU=20-04-lts
# export BATCH_POOL_RESOURCE_FILE_PREFIX=

# export BATCH_POOL_VM_CONTAINER_IMAGE=ubuntu
# export BATCH_POOL_VM_NODE_AGENT_SKU_ID="batch.node.ubuntu 20.04"

# can be useful to alter task distribution across nodes

# export BATCH_POOL_VM_SIZE=Standard_D2_v3
# export BATCH_NODE_FILL_TYPE=spread
# export BATCH_POOL_NODE_COUNT=1
# export BATCH_TASKS_PER_NODE=1

snakemake \
    --jobs 3 \
    -rpf --verbose --default-remote-prefix $AZ_BLOB_PREFIX \
    --use-conda \
    --default-remote-provider AzBlob \
    --envvars AZ_BLOB_ACCOUNT_URL \
    --az-batch \
    --container-image jakevc/snakemake \
    --az-batch-account-url $AZ_BATCH_ACCOUNT_URL
