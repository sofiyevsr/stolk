#!/bin/bash
tar -czvf db-artifacts.tgz ../src/config/db ../src/utils/commons/sqlToKnex.ts ../src/utils/dbData.ts ../src/utils/constants.ts ../knexfile.ts ../package.json ../yarn.lock
