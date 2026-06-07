import "std/web.xi"
import "../business/business.xi"
import "file-list.xi"

class FilesApi implements WebRequestHandler {
    deps { store: FileService }

    mapper getBaseUrl() -> String => "/files"

    action handle(req: HttpRequest, res: HttpResponse) where req.path == "/files" and req.method == "GET" {
        res.send(FileList { files: store.list() })
    }

    action handle(req: HttpRequest, res: HttpResponse) {
        res.sendStatus(404, "Not Found")
    }
}
