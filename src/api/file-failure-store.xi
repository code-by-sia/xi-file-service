import "../business/file-service-failure.xi"
import "file-failure-state.xi"

atom fileFailure {
    initial FileFailureState { hasFailure: false, path: "", kind: "", message: "" }

    transition capture(s: FileFailureState, failure: FileServiceFailure) -> FileFailureState {
        return FileFailureState {
            hasFailure: true,
            path: failure.path,
            kind: failure.kind,
            message: failure.message
        }
    }

    transition clear(s: FileFailureState) -> FileFailureState {
        return FileFailureState { hasFailure: false, path: "", kind: "", message: "" }
    }
}
