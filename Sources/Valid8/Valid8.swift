public struct Valid8 {

    var rules = [Rule]()

    public init() {}
    func check(_ string: String) -> Bool {
        for rule in rules {
            if !rule.predicate(string) {
                return false
            }
        }

        return true
    }

    public func rule(predicate: @escaping (String) -> Bool) -> Valid8 {
        var combined = Valid8()
        combined.rules = self.rules
        combined.rules.append(Rule(predicate: predicate))
        return combined
    }

    static func && (left: Valid8, right: Valid8) -> Valid8 {
        var combined = Valid8()
        combined.rules = left.rules + right.rules
        return combined
    }
}
