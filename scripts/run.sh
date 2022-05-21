#!/bin/bash
set -e

source_dir=source
build_dir=build

. ${source_dir}/pdxinfo

mkdir -p ${build_dir}
pdc ${source_dir} "${build_dir}/${name:?}.pdx"
open "${build_dir}/${name:?}.pdx"
