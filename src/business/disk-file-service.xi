import "std/fs.xi"
import "std/path.xi"
import "file-service.xi"
import "file-utility.xi"
import "stored-file.xi"
import "file-service-failure.xi"

class DiskFileService implements FileService {
    deps { utils: FileUtility }

    producer list() -> String[] {
        return fs.listDir(utils.root())
    }

    producer get(filePath: String) -> StoredFile interrupts FileServiceFailure {
        if not utils.safePath(filePath) {
            signal FileServiceFailure { path: filePath, kind: "invalid-path", message: "file path must be a safe relative path" } recover {}
            return StoredFile { path: filePath, content: "" }
        }

        let target = utils.storagePath(filePath)
        if not fs.isFile(target) {
            signal FileServiceFailure { path: filePath, kind: "not-found", message: "file not found" } recover {}
            return StoredFile { path: filePath, content: "" }
        }

        let content = fs.readFile(target)
        if isErr(content) {
            signal FileServiceFailure { path: filePath, kind: "storage-failed", message: content.err } recover {}
            return StoredFile { path: filePath, content: "" }
        }

        return StoredFile { path: filePath, content: content.value }
    }

    producer create(filePath: String, content: String) -> String interrupts FileServiceFailure {
        if not utils.safePath(filePath) {
            signal FileServiceFailure { path: filePath, kind: "invalid-path", message: "file path must be a safe relative path" } recover {}
            return ""
        }

        let target = utils.storagePath(filePath)
        if fs.exists(target) {
            signal FileServiceFailure { path: filePath, kind: "already-exists", message: "file already exists" } recover {}
            return ""
        }

        fs.mkdirAll(path.dirname(target))
        if fs.writeFile(target, content) {
            return "created"
        }
        signal FileServiceFailure { path: filePath, kind: "storage-failed", message: "failed to create file" } recover {}
        return ""
    }

    producer update(filePath: String, content: String) -> String interrupts FileServiceFailure {
        if not utils.safePath(filePath) {
            signal FileServiceFailure { path: filePath, kind: "invalid-path", message: "file path must be a safe relative path" } recover {}
            return ""
        }

        let target = utils.storagePath(filePath)
        if not fs.isFile(target) {
            signal FileServiceFailure { path: filePath, kind: "not-found", message: "file not found" } recover {}
            return ""
        }

        fs.mkdirAll(path.dirname(target))
        if fs.writeFile(target, content) {
            return "updated"
        }
        signal FileServiceFailure { path: filePath, kind: "storage-failed", message: "failed to update file" } recover {}
        return ""
    }

    producer delete(filePath: String) -> String interrupts FileServiceFailure {
        if not utils.safePath(filePath) {
            signal FileServiceFailure { path: filePath, kind: "invalid-path", message: "file path must be a safe relative path" } recover {}
            return ""
        }

        let target = utils.storagePath(filePath)
        if not fs.isFile(target) {
            signal FileServiceFailure { path: filePath, kind: "not-found", message: "file not found" } recover {}
            return ""
        }

        if fs.remove(target) {
            return "deleted"
        }
        signal FileServiceFailure { path: filePath, kind: "storage-failed", message: "failed to delete file" } recover {}
        return ""
    }
}
