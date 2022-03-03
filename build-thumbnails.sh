#!/usr/bin/env bash

# TODO do this automatically

cd document-proposal-management-with-finite-state-machines/dist
mv slidev-exported.pdf document-proposal-management-with-finite-state-machines.pdf
pdftocairo document-proposal-management-with-finite-state-machines.pdf -jpeg -singlefile -scale-to 500
mv document-proposal-management-with-finite-state-machines.jpg ..
cd ..

cd unit-testing-and-test-driven-development
pdftocairo unit-testing-and-test-driven-development.pdf -jpeg -singlefile -scale-to 500
mv unit-testing-and-test-driven-development.jpg ..
cd ..