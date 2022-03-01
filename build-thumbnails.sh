#!/usr/bin/env bash

# TODO do this automatically

cd document-proposal-management-with-finite-state-machines/dist
mv slidev-exported.pdf document-proposal-management-with-finite-state-machines.pdf
pdftocairo document-proposal-management-with-finite-state-machines.pdf -jpeg -singlefile -scale-to 400
mv document-proposal-management-with-finite-state-machines.jpg ..
cd ..