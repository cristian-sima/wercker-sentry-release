wercker-sync-sentry
==============

Sync your release with Sentry.io


Example
--------

Add SENTRY_AUTH and SENTRY_ORG as deploy target or application environment variable.

```
    - cristian-sima/wercker-sync-sentry:
        version: **OPTIONAL** // default: '$WERCKER_GIT_COMMIT'
        projects: **OPTIONAL** // default: '$WERCKER_GIT_REPOSITORY'; format: "projectA,projectB"
        organization: $SENTRY_ORG
        auth_token: $SENTRY_AUTH
```
