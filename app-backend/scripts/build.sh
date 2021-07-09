#!/bin/bash
yarn build
tar -czvf build.tgz ../dist/ ../package.json ../yarn.lock
