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
`FileApiOperations` helper. The disk-backed service
implementation lives in `src/service/disk-file-service.xi`; reusable
path/root/safety helpers live in the `FileUtils` class at
`src/service/file-utils.xi`. Xi's DI system injects those classes automatically.

The service layer returns domain values only: file lists, stored file content,
and operation messages. It signals `FileServiceFailure` interrupts for domain
failures such as invalid paths, missing files, conflicts, or storage failures.
The API layer catches those interrupts and translates them to HTTP responses.

Each class, type, and interface lives in its own `.xi` file. `src/app.xi`
contains the `App` module marker and the `main` entrypoint. `src/service/service.xi`
is an import-only manifest for the service layer.

## Structure

```text
src/
  app.xi
  api/
    default-file-api-operations.xi
    file-api.xi
    file-api-operations.xi
    file-failure-state.xi
    file-failure-store.xi
    files-api.xi
  dto/
    file-body.xi
    file-list.xi
    file-message.xi
    file-write.xi
  service/
    disk-file-service.xi
    file-service.xi
    file-utility.xi
    file-utils.xi
    interrupts/
      file-service-failure.xi
    models/
      stored-file.xi
    service.xi
```

## Build

```sh
xc src/app.xi
```

## Run

```sh
./build/app
```

The default port is `8080`. You can pass another port:

```sh
./build/app 18080
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
