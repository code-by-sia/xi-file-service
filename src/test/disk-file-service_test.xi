import "../business/business.xi"
import "test-module.xi"

test "creates reads updates and deletes files" (service: FileService) {
    let filePath = "codex-native-test.txt"

    try {
        service.delete(filePath)
    } catch e: FileServiceFailure {
        recover
    }

    assert service.create(filePath, "hello") == "created"

    let created = service.get(filePath)
    assert created.path == filePath
    assert created.content == "hello"

    assert service.update(filePath, "updated") == "updated"

    let updated = service.get(filePath)
    assert updated.path == filePath
    assert updated.content == "updated"

    assert service.delete(filePath) == "deleted"
}

test "signals invalid path failures" (service: FileService) {
    try {
        service.create("../bad.txt", "bad")
        assert false
    } catch e: FileServiceFailure {
        assert e.path == "../bad.txt"
        assert e.kind == "invalid-path"
        assert e.message == "file path must be a safe relative path"
        skip
    }
}

test "signals not found failures" (service: FileService) {
    try {
        service.get("codex-missing-native-test.txt")
        assert false
    } catch e: FileServiceFailure {
        assert e.path == "codex-missing-native-test.txt"
        assert e.kind == "not-found"
        assert e.message == "file not found"
        skip
    }
}

test "signals already exists failures" (service: FileService) {
    let filePath = "codex-existing-native-test.txt"

    try {
        service.delete(filePath)
    } catch e: FileServiceFailure {
        recover
    }

    assert service.create(filePath, "first") == "created"

    try {
        service.create(filePath, "second")
        assert false
    } catch e: FileServiceFailure {
        assert e.path == "codex-existing-native-test.txt"
        assert e.kind == "already-exists"
        assert e.message == "file already exists"
        skip
    }

    assert service.delete(filePath) == "deleted"
}
