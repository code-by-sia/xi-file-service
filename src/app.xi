import "api/file-api.xi"
import "api/files-api.xi"
import "std/convert.xi"

module App {
    id = "file-server"
    name = "Xi File Server"
    description = "HTTP file server with create, delete, update, list, and get endpoints"
    version = "1.0.0"
    license = "MIT"
    includes = ["./src/**"]
    excludes = ["./src/test/**"]

    async entry main(args: String[]) -> Integer {
        let port = 8080
        if args.len >= 2 {
            let parsed = convert.parseInteger(args.data[1])
            if isOk(parsed) { port = parsed.value }
        }
        web.serve(port)
    }
}
