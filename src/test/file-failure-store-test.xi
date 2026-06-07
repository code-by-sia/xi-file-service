import "../api/file-failure-store.xi"
import "test-module.xi"

test "captures and clears file service failures" {
    fileFailure.clear()
    fileFailure.capture(FileServiceFailure {
        path: "docs/missing.txt",
        kind: "not-found",
        message: "file not found"
    })

    assert fileFailure.current.hasFailure
    assert fileFailure.current.path == "docs/missing.txt"
    assert fileFailure.current.kind == "not-found"
    assert fileFailure.current.message == "file not found"

    fileFailure.clear()

    assert not fileFailure.current.hasFailure
    assert fileFailure.current.path == ""
    assert fileFailure.current.kind == ""
    assert fileFailure.current.message == ""
}
