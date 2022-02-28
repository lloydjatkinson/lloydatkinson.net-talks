#!/usr/bin/env bash

cd document-proposal-management-with-finite-state-machines
npm ci
npm run build --base /document-proposal-management-with-finite-state-machines/talk
cd ..