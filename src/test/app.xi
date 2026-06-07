import "file-utils-test.xi"
import "test-suite.xi"

async entry main(args: String[]) -> Integer {
    let failures = App.resolve(TestSuite).run()
    if failures == 0 {
        system.stdout.writeln("tests passed")
        return 0
    }
    system.stdout.writeln("tests failed: " + failures)
    return 1
}

module App {
    id = "file-server-tests"
    name = "Xi File Server Tests"
    description = "Test module for the Xi file server domains"
}
