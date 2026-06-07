import "../business/business.xi"
import "default-test-assert.xi"
import "test-assert.xi"
import "test-suite.xi"

class FileUtilsTest implements TestSuite {
    deps {
        utils: FileUtility
        assertions: TestAssert
    }

    producer run() -> Integer {
        let failures = 0
        failures = failures + assertions.expectBool("safe leaf path", utils.safePath("hello.txt"), true)
        failures = failures + assertions.expectBool("safe nested path", utils.safePath("docs/notes.txt"), true)
        failures = failures + assertions.expectBool("empty path rejected", utils.safePath(""), false)
        failures = failures + assertions.expectBool("absolute path rejected", utils.safePath("/tmp/notes.txt"), false)
        failures = failures + assertions.expectBool("directory path rejected", utils.safePath("docs/"), false)
        failures = failures + assertions.expectBool("parent traversal rejected", utils.safePath("../notes.txt"), false)
        failures = failures + assertions.expectBool("backslash path rejected", utils.safePath("docs\\notes.txt"), false)
        return failures
    }
}
