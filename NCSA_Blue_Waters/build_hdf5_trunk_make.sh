#!/bin/bash
#   ___  __           _      __     __
#  / _ )/ /_ _____   | | /| / /__ _/ /____ _______
# / _  / / // / -_)  | |/ |/ / _ `/ __/ -_) __(_-<
#/____/_/\_,_/\__/   |__/|__/\_,_/\__/\__/_/ /___/
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Build script to build hdf5 from trunk on Blue Waters
source /opt/modules/default/init/bash

module load automake
module load autoconf

# There is currently a HDF5 naming conflict with Darshan
module unload darshan
module list

<<COMMENT2
- Script name: build_hdf5_trunk_make.sh
- Assumes autogen.sh has been run successfully in SOURCEDIR
-- autoconf/2.69 (or newer)
-- automake/1.14 (or newer)
-- libtool/2.4.5 (or newer)

COMMENT2


BUILDBASE="hdf5-build-"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
SOURCEDIR="$HOME/src/hdf5-trunk"
BUILDDIR="$PWD/$BUILDBASE$TIMESTAMP"

# Create build directory
mkdir -p $BUILDDIR
if [ -d "$BUILDDIR" ]; then
  # Build directory created
  echo "Successfully created build directory: ${BUILDDIR}"
  cd $BUILDDIR
else
  # Fail to create build directory
  echo "unable to create build directory ${BUILDDIR}"
  exit 1
fi




export CC="cc"
export FC="ftn"
export CXX="CC"

export LDFLAGS="-dynamic"
export XTPE_LINK_TYPE="dynamic"
export CRAY_CPU_TARGET="x86-64"

export RUNPARALLEL="aprun -n 6"


$SOURCEDIR/configure \
--prefix=${BUILDDIR} --enable-fortran  \
--with-pic  --with-zlib=/usr/lib64 --enable-parallel \
--enable-production

make -j 8
make install
