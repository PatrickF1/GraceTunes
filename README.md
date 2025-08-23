# [GraceTunes](https://github.com/PatrickF1/GraceTunes)

## Development

Dev environment setup guide is on the GitHub wiki.

## API authentication via Firebase (Bearer token)

The API (under `api/v1/*`) accepts `Authorization: Bearer <Firebase ID token>` issued by Firebase Authentication (Google provider). The token is verified server-side using `firebase_id_token` and must include a verified email.

### Configure allowed Firebase project IDs

The verifier only accepts tokens from configured Firebase project IDs.

- Single project:
  - Set `FIREBASE_PROJECT_ID` to your Firebase project ID
- Multiple projects:
  - Set `FIREBASE_PROJECT_IDS` to a comma-separated list of project IDs

Examples (Heroku):

```bash
# Single project
heroku config:set FIREBASE_PROJECT_ID=tunes-11727 -a gracetunes

# Multiple projects
heroku config:set FIREBASE_PROJECT_IDS=tunes-11727,another-project -a gracetunes
```

Locally, export the same environment variables before starting the server.

### Making requests

Use the API routes, not the HTML routes. For example, list songs:

```bash
curl 'https://gracetunes.herokuapp.com/api/v1/songs' \
  -H 'Authorization: Bearer <FIREBASE_ID_TOKEN>' \
  -H 'Accept: application/json'
```

Notes:
- Tokens must be valid Firebase ID tokens with `email_verified=true`.
- If the email exists in `users`, that user's role is used. Otherwise, a transient user with role `Reader` is used (read-only access).

