#!/usr/bin/env bash

cd document-proposal-management-with-finite-state-machines --base /document-proposal-management-with-finite-state-machines/talk
npm ci
npm run build
cd ..