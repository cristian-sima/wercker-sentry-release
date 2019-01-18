#!/bin/bash

ERR_MSG=()
if [ ! -n "$WERCKER_SENTRY_RELEASE_AUTH_TOKEN" ]; then
  ERR_MSG+=("Please specify auth_token property")
fi

if [ ! -n "$WERCKER_SENTRY_RELEASE_ORGANIZATION" ]; then
  ERR_MSG+=("Please specify organization property")
fi

if [ -n "$ERR_MSG" ]; then
  printf '\033[0;91m%s\n\033[0m' "${ERR_MSG[@]}"
  exit 1
fi

if [ ! -n "$WERCKER_SENTRY_RELEASE_VERSION" ]; then
  export WERCKER_SENTRY_RELEASE_VERSION=$WERCKER_GIT_COMMIT
fi

if [ ! -n "$WERCKER_SENTRY_RELEASE_PROJECTS" ]; then
  export WERCKER_SENTRY_RELEASE_PROJECTS=$WERCKER_GIT_REPOSITORY
fi
WERCKER_SENTRY_RELEASE_PROJECTS="\"${WERCKER_SENTRY_RELEASE_PROJECTS/,/\",\"}\""

SENTRY_ENTRYPOINT="https://sentry.io/api/0/organizations/$WERCKER_SENTRY_RELEASE_ORGANIZATION/releases/"

curl -v $SENTRY_ENTRYPOINT \
  -X POST \
  -H "Authorization: Bearer $WERCKER_SENTRY_RELEASE_AUTH_TOKEN" \
  -H 'Content-Type: application/json' \
  -d "
  {
    \"version\": \"$WERCKER_SENTRY_RELEASE_VERSION\",
    \"refs\": [{
        \"repository\":\"$WERCKER_GIT_REPOSITORY\",
        \"commit\":\"$WERCKER_GIT_COMMIT\",
    }],
    \"projects\": [$WERCKER_SENTRY_RELEASE_PROJECTS]
  }
"
