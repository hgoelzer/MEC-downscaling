#!/bin/bash
# Run processing chain

./extract_variables.sh
./process_raw_vector.py
./convert_grid.sh
./apply_vertical_interpolation.py
./calc_SMB.sh

