#!/bin/bash
# Regrid to regional grid

# Needs module cdo
 
#set -x
set -e

source ../params
# ln -s /cluster/work/users/heig/archive/N1850frc2_SMB1/lnd/hist/vregrid ./output
# ln -s /cluster/work/users/heig/archive/N1850frc2_SMB1/lnd/hist/vector2gridded3d ./input

# Directories with files from step before (can be symlink)
INDIR=$scratchdir/s2_gridded3d
OUTDIR=$scratchdir/s3_regridded

# Select variables to process
FILES=$(ls $INDIR/*nc)
#FILES=$(ls $INDIR/QICE_19*nc) # specific variable
#FILES=$(ls $INDIR/QRUNOFF_19*nc) # specific variable
#FILES=$(ls $INDIR/TOPO_COL_timmean.nc) # specific file

echo $FILES

# Variable $FILES is a list, select first entry
set -- $FILES
FILE1=$1 

# Pre-compute interpolation weights
cdo genbil,${grid_file} $FILE1 weights.nc

# Main loop
for FILE in $FILES; do
   FNAME=$(basename $FILE)
   NEWFILE=$OUTDIR/$FNAME

   # Remap directly
   #cdo remapbil,${grid_file} $FILE $NEWFILE
   # Or USE PRECOMPUTED WEIGHTS
   cdo --format nc4 -b F32 remap,${grid_file},weights.nc $FILE $NEWFILE
done
