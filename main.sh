#!/bin/bash

# Force remove contents of data dir (no error if empty or dir missing)
# Ensure data dir exists first for clarity
mkdir -p data
rm -f data/*

# Force remove output file (no error if missing)
rm -f InCollege-Output.txt

# Compile programs
mkdir -p bin && cobc -x -free -o bin/create_sample_db /workspace/src/create_sample_db.cob
mkdir -p bin && cobc -x -free -o bin/InCollege /workspace/src/InCollege.cob

# Run programs
bin/create_sample_db
bin/InCollege
