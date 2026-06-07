import "std/web.xi"
import "../dto/file-write.xi"
import "../service/service.xi"
import "../service/models/stored-file.xi"
import "file-api-operations.xi"
import "file-failure-store.xi"

class DefaultFileApiOperations implements FileApiOperations {
    deps {
        store: FileService
        utils: FileUtility
    }

    producer getFile(req: HttpRequest) -> StoredFile {
        fileFailure.clear()
        try {
            return store.get(utils.requestPath(req))
        } catch e: FileServiceFailure {
            fileFailure.capture(e)
            skip
        }
        return empty StoredFile
    }

    producer createFile(req: HttpRequest, body: FileWrite) -> String {
        fileFailure.clear()
        try {
            return store.create(utils.requestPath(req), body.content)
        } catch e: FileServiceFailure {
            fileFailure.capture(e)
            skip
        }
        return ""
    }

    producer updateFile(req: HttpRequest, body: FileWrite) -> String {
        fileFailure.clear()
        try {
            return store.update(utils.requestPath(req), body.content)
        } catch e: FileServiceFailure {
            fileFailure.capture(e)
            skip
        }
        return ""
    }

    producer deleteFile(req: HttpRequest) -> String {
        fileFailure.clear()
        try {
            return store.delete(utils.requestPath(req))
        } catch e: FileServiceFailure {
            fileFailure.capture(e)
            skip
        }
        return ""
    }

    consumer sendFailure(res: HttpResponse) {
        let failure = fileFailure.current
        if failure.kind == "invalid-path" {
            res.sendStatus(400, failure.message)
        } else if failure.kind == "not-found" {
            res.sendStatus(404, failure.message)
        } else if failure.kind == "already-exists" {
            res.sendStatus(409, failure.message)
        } else {
            res.sendStatus(500, failure.message)
        }
        fileFailure.clear()
    }
}
