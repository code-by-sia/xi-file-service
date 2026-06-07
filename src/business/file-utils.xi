import "std/fs.xi"
import "std/path.xi"
import "std/text.xi"
import "std/web.xi"
import "file-utility.xi"

class FileUtils implements FileUtility {
    producer root() -> String {
        let dir = path.join(fs.cwd(), "files")
        fs.mkdirAll(dir)
        return dir
    }

    producer storagePath(filePath: String) -> String {
        let dir = path.join(fs.cwd(), "files")
        fs.mkdirAll(dir)
        return path.join(dir, filePath)
    }

    predicate safePath(filePath: String) {
        if text.isEmpty(filePath) { return false }
        if text.startsWith(filePath, "/") { return false }
        if text.endsWith(filePath, "/") { return false }
        if text.contains(filePath, "\\") { return false }
        if text.contains(filePath, "..") { return false }
        return true
    }

    mapper requestPath(req: HttpRequest) -> String {
        return text.substring(req.path, 6, text.length(req.path))
    }
}
