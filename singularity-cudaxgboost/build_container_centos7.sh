#!/bin/bash
####################################################
#                                                  #
#  Simple build script for singularity container   #
#  J. Wilkinson [jeremy.wilkinson@cern.ch]         #
#                                                  #
####################################################

# Keep singularity cache local to this folder
#export SINGULARITY_CACHEDIR=$PWD/cache
#export SINGULARITY_TMPDIR=$PWD/tmp

#run singularity build
singularity build --fakeroot cuda_xgboost_env_centos7.sif singularity_cudaxgboost_centos7.def 
