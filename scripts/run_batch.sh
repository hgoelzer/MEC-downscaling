#!/bin/bash
# Run processing chain

./extract_variables.sh               # extract to s1_vector
./process_raw_vector.py              # Process to s2_gridded3d
./convert_grid.sh                    # convert to s3_regridded
./apply_vertical_interpolation.py    # interpolate to s4_remapped
./calc_SMB.sh                        # combine to s5_smb
./make_forcing_timeseries.sh         # concat to s6_timeseries

./calc_ARTM.sh                       # combine to s7_art
./make_artm_forcing_timeseries.sh    # concat to s8_timeseries
