import "../business/business.xi"
import "test-module.xi"

test "accepts safe file paths" (utils: FileUtility) {
    assert utils.safePath("hello.txt")
    assert utils.safePath("docs/notes.txt")
}

test "rejects unsafe file paths" (utils: FileUtility) {
    assert not utils.safePath("")
    assert not utils.safePath("/tmp/notes.txt")
    assert not utils.safePath("docs/")
    assert not utils.safePath("../notes.txt")
    assert not utils.safePath("docs\\notes.txt")
}
