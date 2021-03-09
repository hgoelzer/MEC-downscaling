#!/bin/bash
# Combine fields to calucalte SMB
# SMB = SNOW + QSNOFRZ - QSNOMELT - QICE_MELT – QSOIL

set -x
set -e

# Read user settings
source ../params

# Directories with files from step before (can be symlink)
INDIR=$scratchdir/s4_remapped
OUTDIR=$scratchdir/s5_smb

/bin/rm -r $OUTDIR
mkdir -p $OUTDIR

for ayear in `eval echo {${syear}..${eyear}..1}`; do

    cdo merge ${INDIR}/SNOW_${ayear}_${run}.nc ${INDIR}/QSNOFRZ_${ayear}_${run}.nc ${INDIR}/QSNOMELT_${ayear}_${run}.nc ${INDIR}/QICE_MELT_${ayear}_${run}.nc ${INDIR}/QSOIL_${ayear}_${run}.nc  ${OUTDIR}/SMB_${ayear}_${run}.nc

# remove unused vars
ncks -C -O -x -v lon,lat,lon_bnds,lat_bnds ${OUTDIR}/SMB_${ayear}_${run}.nc ${OUTDIR}/SMB_${ayear}_${run}.nc
    
# add components change units from mm/s to mm/yr w.e.
    ncap2 -O -s "SMB=(SNOW+QSNOFRZ-QSNOMELT-QICE_MELT-QSOIL)" ${OUTDIR}/SMB_${ayear}_${run}.nc ${OUTDIR}/SMB_${ayear}_${run}.nc
    ncap2 -O -s "SMB=(SNOW+QSNOFRZ-QSNOMELT-QICE_MELT-QSOIL)" ${OUTDIR}/SMB_${ayear}_${run}.nc ${OUTDIR}/SMB_${ayear}_${run}.nc

    # make axis
    ncecat -O -u time ${OUTDIR}/SMB_${ayear}_${run}.nc ${OUTDIR}/SMB_${ayear}_${run}.nc

done
