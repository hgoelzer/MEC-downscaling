#!/bin/bash
# Calucalte T2M
# T2M = TSA-273.16

set -x
set -e

params=$1

if [ ! -f ${params} ]; then
    echo Error: parameter file $params not found, exiting! 
    exit
fi

## User settings
source $params

# Directories with files from step before (can be symlink)
INDIR=$scratchdir/s4_remapped
OUTDIR=$scratchdir/s9_t2m

/bin/rm -r $OUTDIR
mkdir -p $OUTDIR

for ayear in `eval echo {${syear}..${eyear}..1}`; do

    cdo merge ${INDIR}/TSA_${ayear}_${run}.nc ${OUTDIR}/T2M_${ayear}_${run}.nc

    # remove unused vars
    ncks -C -O -x -v lon,lat,lon_bnds,lat_bnds ${OUTDIR}/T2M_${ayear}_${run}.nc ${OUTDIR}/T2M_${ayear}_${run}.nc
    
    # change units +sanity 
    ncap2 -O -s 'T2M=TSA-273.16; where(T2M<-273.16)T2M=-273.16' ${OUTDIR}/T2M_${ayear}_${run}.nc ${OUTDIR}/T2M_${ayear}_${run}.nc

    # make axis
    ncecat -O -u time ${OUTDIR}/T2M_${ayear}_${run}.nc ${OUTDIR}/T2M_${ayear}_${run}.nc

done
