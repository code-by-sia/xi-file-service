import "test-assert.xi"

class DefaultTestAssert implements TestAssert {
    producer expectBool(name: String, actual: Bool, expected: Bool) -> Integer {
        if actual == expected {
            return 0
        }
        system.stdout.writeln("failed: " + name)
        return 1
    }
}
