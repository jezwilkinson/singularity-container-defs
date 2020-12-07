#!/bin/bash
####################################################
#                                                  #
#  Simple build script for singularity container   #
#  J. Wilkinson [jeremy.wilkinson@cern.ch]         #
#                                                  #
####################################################

# Keep singularity cache local to this folder
export SINGULARITY_CACHEDIR=$PWD/cache
export SINGULARITY_TMPDIR=$PWD/tmp

#run singularity build
singularity build cuda_xgboost_env.sif singularity_cudaxgboost.def 
