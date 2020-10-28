#!/bin/bash
# Combine fields to calucalte SMB

set -x
set -e

# SMB = SNOW + QSNOFRZ - QSNOMELT - QICE_MELT – QSOIL

#for ayear in 0001 0002 0003 0004 0005 0006 0007 0008 0009 0010; do
for ayear in 01 02 03 04 05 06 07 08 09 10 11 12; do

    cdo merge input/SNOW_${ayear}_N1850frc2_SMB1.nc input/QSNOFRZ_${ayear}_N1850frc2_SMB1.nc input/QSNOMELT_${ayear}_N1850frc2_SMB1.nc input/QICE_MELT_${ayear}_N1850frc2_SMB1.nc input/QSOIL_${ayear}_N1850frc2_SMB1.nc  output/SMB_${ayear}_N1850frc2_SMB1.nc

# add components change units from mm/s to mm/yr w.e.
    ncap2 -O -s "SMB=(SNOW+QSNOFRZ-QSNOMELT-QICE_MELT-QSOIL)" output/SMB_${ayear}_N1850frc2_SMB1.nc output/SMB_${ayear}_N1850frc2_SMB1.nc
    ncap2 -O -s "SMB=(SNOW+QSNOFRZ-QSNOMELT-QICE_MELT-QSOIL)" output/SMB_${ayear}_N1850frc2_SMB1.nc output/SMB_${ayear}_N1850frc2_SMB1.nc

done
