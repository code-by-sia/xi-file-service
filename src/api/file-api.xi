import "std/web.xi"
import "../dto/file-write.xi"
import "../dto/file-body.xi"
import "../dto/file-message.xi"
import "file-api-operations.xi"
import "default-file-api-operations.xi"
import "file-failure-store.xi"

class FileApi implements WebRequestHandler {
    deps { operations: FileApiOperations }

    mapper getBaseUrl() -> String => "/file/"

    action handle(req: HttpRequest, res: HttpResponse) where req.method == "GET" {
        let file = operations.getFile(req)
        if fileFailure.current.hasFailure {
            operations.sendFailure(res)
            return
        }
        res.send(FileBody { path: file.path, content: file.content })
    }

    action handle(req: HttpRequest, res: HttpResponse) where req.method == "POST" {
        let body = req.parse(FileWrite)
        let message = operations.createFile(req, body)
        if fileFailure.current.hasFailure {
            operations.sendFailure(res)
            return
        }
        res.send(FileMessage { ok: true, message: message })
    }

    action handle(req: HttpRequest, res: HttpResponse) where req.method == "PUT" {
        let body = req.parse(FileWrite)
        let message = operations.updateFile(req, body)
        if fileFailure.current.hasFailure {
            operations.sendFailure(res)
            return
        }
        res.send(FileMessage { ok: true, message: message })
    }

    action handle(req: HttpRequest, res: HttpResponse) where req.method == "DELETE" {
        let message = operations.deleteFile(req)
        if fileFailure.current.hasFailure {
            operations.sendFailure(res)
            return
        }
        res.send(FileMessage { ok: true, message: message })
    }

    action handle(req: HttpRequest, res: HttpResponse) {
        res.sendStatus(404, "Not Found")
    }
}
