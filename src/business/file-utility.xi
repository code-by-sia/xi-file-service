import "std/web.xi"

interface FileUtility {
    producer root() -> String
    producer storagePath(filePath: String) -> String
    predicate safePath(filePath: String)
    mapper requestPath(req: HttpRequest) -> String
}
