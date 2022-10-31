import FluentKit

extension DatabaseQuery.Sort.Direction {

    init?(_ str: String) {
        
        switch str.lowercased() {
        case "ascending":
            self = .ascending
        case "descending":
            self = .descending
        default:
            return nil
        }
    }
}
