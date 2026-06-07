import "api/file-api.xi"
import "api/files-api.xi"
import "std/convert.xi"

module App {}

async entry main(args: String[]) -> Integer {
    let port = 8080
    if args.len >= 2 {
        let parsed = convert.parseInteger(args.data[1])
        if isOk(parsed) { port = parsed.value }
    }
    web.serve(port)
    return 0
}
