import "std/web.xi"
import "../dto/file-write.xi"
import "../service/models/stored-file.xi"

interface FileApiOperations {
    producer getFile(req: HttpRequest) -> StoredFile
    producer createFile(req: HttpRequest, body: FileWrite) -> String
    producer updateFile(req: HttpRequest, body: FileWrite) -> String
    producer deleteFile(req: HttpRequest) -> String
    consumer sendFailure(res: HttpResponse)
}
