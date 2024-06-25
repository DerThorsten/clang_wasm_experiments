#!/bin/bash
set -e

# get first argument
EMSDK_DIR=$1

# check if the argument is empty
if [ -z "$EMSDK_DIR" ]; then
    echo "Usage: $0 <path to emsdk directory>"
    exit 1
fi

# THIS DIR
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "THIS_DIR: $THIS_DIR"
# deployment dir
DEPLOYMENT=$THIS_DIR/deploy_dedicated
mkdir -p $DEPLOYMENT

# WASM PREFIX
PREFIX=$THIS_DIR/wasm

# create the env
# set to false to skip environment creation
if false; then
    $MAMBA_EXE create -p $PREFIX  \
    --platform=emscripten-wasm32 \
    -c https://repo.mamba.pm/emscripten-forge \
    -c https://repo.mamba.pm/conda-forge \
    --yes \ llvm
fi


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

echo "Copying files to deployment dir from $THIS_DIR/dedicated/build"

# copy the just built files to the deployment dir
cp $THIS_DIR/dedicated/build/compile_string.js $DEPLOYMENT
cp $THIS_DIR/dedicated/build/compile_string.wasm $DEPLOYMENT
  
# copy the clang resources to the deployment dir
mkdir -p $DEPLOYMENT/clang_resources
echo "copy clang resources from $PREFIX/lib/clang/17 to $DEPLOYMENT/clang_resources"
cp -r $PREFIX/lib/clang/17  $DEPLOYMENT/clang_resources



# python script to create a json with all files
python $THIS_DIR/make_list.py