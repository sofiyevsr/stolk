#!/bin/bash

echo "VERCEL_GIT_COMMIT_REF: $VERCEL_GIT_COMMIT_REF"

if [[ "$VERCEL_GIT_COMMIT_REF" == "master" ]] ; then
  # Proceed with the build
  echo "✅ - Build can proceed"
  git diff HEAD^ HEAD --quiet .

else
  # Don't build
  echo "🛑 - Build cancelled"
  exit 0;
fi
