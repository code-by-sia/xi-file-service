import "stored-file.xi"
import "file-service-failure.xi"

interface FileService {
    producer list() -> String[]
    producer get(filePath: String) -> StoredFile interrupts FileServiceFailure
    producer create(filePath: String, content: String) -> String interrupts FileServiceFailure
    producer update(filePath: String, content: String) -> String interrupts FileServiceFailure
    producer delete(filePath: String) -> String interrupts FileServiceFailure
}
