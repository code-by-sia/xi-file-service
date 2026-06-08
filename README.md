# Xi File Server

A tiny Xi HTTP file server with create, delete, update, list, and get endpoints.
Files are stored under `./files`, and API file paths must be safe relative paths
such as `notes.txt` or `docs/notes.txt`.

Programming language: [code-by-sia/x](https://github.com/code-by-sia/x)

Built against Xi's documented `std/web` model:
https://code-by-sia.github.io/x/web

The API uses Xi's `WebRequestHandler.getBaseUrl()` mount-prefix hook. `FileApi`
is mounted at `/file/`, while `FilesApi` is mounted at `/files`. The framework
uses the mount prefix to decide which controller receives a request; `FileUtils`
then reads the rest of `req.path` as the file path.

The HTTP controllers depend on the `FileService` interface and an API-side
`FileApiOperations` helper. The disk-backed service implementation lives in the
business domain at `src/business/disk-file-service.xi`; reusable path/root/safety
helpers live in the `FileUtils` class at `src/business/file-utils.xi`. Xi's DI
system injects those classes automatically.

The service layer returns domain values only: file lists, stored file content,
and operation messages. It signals `FileServiceFailure` interrupts for domain
failures such as invalid paths, missing files, conflicts, or storage failures.
The API layer catches those interrupts and translates them to HTTP responses.

Each class, type, and interface lives in its own `.xi` file. Source folders are
organized by domain: `src/api` for HTTP concerns, `src/business` for business
rules and storage, and `src/test` for tests. `src/app.xi` contains the main
entrypoint and the `App` module metadata. `src/business/business.xi` is an
import-only manifest for the business domain.

## Structure

```text
src/
  app.xi
  api/
    default-file-api-operations.xi
    file-body.xi
    file-api.xi
    file-api-operations.xi
    file-failure-state.xi
    file-failure-store.xi
    file-list.xi
    file-message.xi
    file-write.xi
    files-api.xi
  business/
    business.xi
    disk-file-service.xi
    file-service-failure.xi
    file-service.xi
    file-utility.xi
    file-utils.xi
    stored-file.xi
  test/
    disk-file-service_test.xi
    file-failure-store_test.xi
    file-utils_test.xi
    test-module.xi
```

## Getting Started

Install Xi and `xc` with Homebrew:

```sh
brew install code-by-sia/x/xi
```

Upgrade a Homebrew installation later with:

```sh
brew upgrade xi
```

For tarball installs, keep the local Xi toolchain current before building:

```sh
xi update
```

`xi update` checks the latest [code-by-sia/x](https://github.com/code-by-sia/x)
release, downloads the matching package for your platform, and updates the local
`xi` and `xc` commands in place.

Refresh the Xi language guide for AI-assisted development:

```sh
xi skill
```

`xi skill` prints the current Xi language and testing guide, including syntax,
dependency injection, module metadata, interrupts, and native `xi test` usage.

## Build

```sh
xc src/app.xi
```

## Test

```sh
xi test --all
```

## Run

```sh
./build/file-server
```

The default port is `8080`. You can pass another port:

```sh
./build/file-server 18080
```

## Docker

```sh
docker build -t xi-file-server .
docker run --rm -p 8080:8080 -v "$(pwd)/files:/app/files" xi-file-server
```

## OpenAPI

The API is described in `api-spec.yaml`.

## Endpoints

```sh
curl http://127.0.0.1:8080/files
curl http://127.0.0.1:8080/file/hello.txt
curl -X POST -H 'Content-Type: application/json' \
  -d '{"content":"hello"}' \
  http://127.0.0.1:8080/file/hello.txt
curl -X PUT -H 'Content-Type: application/json' \
  -d '{"content":"updated"}' \
  http://127.0.0.1:8080/file/hello.txt
curl -X DELETE http://127.0.0.1:8080/file/hello.txt
```
