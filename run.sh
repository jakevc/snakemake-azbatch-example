#!/bin/bash
snakemake \
    --jobs 3 \
    -rpf --verbose --default-remote-prefix $PREFIX \
    --use-conda \
    --default-remote-provider AzBlob \
    --envvars AZ_BLOB_ACCOUNT_URL \
    --az-batch \
    --container-image jakevc/snakemake \
    --az-batch-account-url $AZ_BATCH_ACCOUNT_URL
