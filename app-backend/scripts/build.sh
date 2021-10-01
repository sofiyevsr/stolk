#!/bin/bash
yarn build
tar -czvf app-artifacts.tgz ../dist/ ../package.json ../yarn.lock
