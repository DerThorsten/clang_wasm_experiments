#!/bin/bash
set -e

# THIS DIR
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# deployment dir
DEPLOYMENT=$DIR/deploy_dedicated
mkdir -p $DEPLOYMENT

# WASM PREFIX
PREFIX=$DIR/wasm

# set to false to skip environment creation
if true; then
    $MAMBA_EXE create -p $PREFIX  \
    --platform=emscripten-wasm32 \
    -c https://repo.mamba.pm/emscripten-forge \
    -c https://repo.mamba.pm/conda-forge \
    --yes \ llvm
fi


EMSDK_DIR=$HOME/src/pyjs/emsdk_install
source $EMSDK_DIR/emsdk_env.sh

cd dedicated
mkdir -p build
cd build



export PREFIX
export CMAKE_PREFIX_PATH=$PREFIX
export CMAKE_SYSTEM_PREFIX_PATH=$PREFIX
if true; then

    emcmake cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ON \
    -DBUILD_RUNTIME_BROWSER=ON \
    -DBUILD_RUNTIME_NODE=OFF \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    ..

    emmake make -j8
fi
