# singularity-cudaxgboost
Singularity container definition for XGBoost/hipe4ml environment

This is a minimal container for running Hipe4ML (https://github.com/hipe4ml/hipe4ml) with XGBoost, including NVidia GPU support with CUDA 11.0. Based on the official CUDA image from NVidia, https://hub.docker.com/r/nvidia/cuda. 

NOTE: If using a GPU method in XGBoost such as "gpu_tree", the container must be run with the --nv switch (e.g. "singularity exec --nv [COMMAND]") in order to access the driver binaries on the host machine.

This environment is also compatible with CPU-only running of Hipe4ML on any host machine, without any additional setup.

# singularity-cudatorch
Singularity container definition for Pytorch with CUDA support (Pytorch 1.10.1, CUDA 11.3)
Based on Docker image from https://hub.docker.com/r/nvidia/cuda

# singularity-o2dev
Minimal build environment for ALICE O2/O2Physics software, pulling from https://hub.docker.com/r/alisw/slc7-builder and adding standard dependencies.

Compilation of ALICE software requires `--no-home` to be passed to singularity, to avoid clash with system Python

# singularity-o2deploy
Scripts and definitions for a sandboxed environment for building and deploying O2Physics to distributed cluster computing, when direct building on network storage is not possible. Base environment is pulled from https://hub.docker.com/r/alisw/slc7-builder with standard dependencies added.

See documentation under singularity-o2deploy/README.md for full steps/instructions.