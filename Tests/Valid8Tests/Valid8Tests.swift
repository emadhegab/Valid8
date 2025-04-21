import Testing
@testable import Valid8
import Foundation

@Test func testEmptyValidatorReturnsTrue() async throws {
    let validator = Valid8()
    #expect(validator.check("any string"))
}

@Test func testSingleRulePasses() async throws {
    let validator = Valid8().rule { $0.count >= 3 }
    #expect(validator.check("abc"))
}

@Test func testSingleRuleFails() async throws {
    let validator = Valid8().rule { $0.count >= 5 }
    #expect(!validator.check("abc"))
}

@Test func testMultipleRulesPass() async throws {
    let validator = Valid8()
        .rule { $0.count >= 3 }
        .rule { $0.contains("a") }
    #expect(validator.check("abc"))
}

@Test func testMultipleRulesFail() async throws {
    let validator = Valid8()
        .rule { $0.count >= 3 }
        .rule { $0.contains("z") }
    #expect(!validator.check("abc"))
}

@Test func testLogicalAndValidator() async throws {
    let v1 = Valid8().rule { $0.count >= 3 }
    let v2 = Valid8().rule { $0.hasPrefix("a") }
    let combined = v1 && v2
    #expect(combined.check("abc"))
    #expect(!combined.check("xbc"))
}


@Test func testPasswordValidatorValidPassword() async throws {
    let password = "Aa1@#validPASS"
    #expect(Valid8().checkPasswordValidity(password))
}

@Test func testPasswordValidatorTooShort() async throws {
    let password = "Aa1@"
    #expect(!Valid8().checkPasswordValidity(password))
}

@Test func testPasswordValidatorMissingUppercase() async throws {
    let password = "aa1@#validpass"
    #expect(!Valid8().checkPasswordValidity(password))
}

@Test func testPasswordValidatorMissingLowercase() async throws {
    let password = "AA1@#VALIDPASS"
    #expect(!Valid8().checkPasswordValidity(password))
}

@Test func testPasswordValidatorMissingNumber() async throws {
    let password = "Aa@#validPASS"
    #expect(!Valid8().checkPasswordValidity(password))
}

@Test func testPasswordValidatorMissingSpecialCharacter() async throws {
    let password = "Aa1validPASS"
    #expect(!Valid8().checkPasswordValidity(password))
}

@Test func testPasswordValidatorHasWhitespace() async throws {
    let password = "Aa1@ valid"
    #expect(!Valid8().checkPasswordValidity(password))
}

@Test func testPasswordValidatorHasEmoji() async throws {
    let password = "Aa1@valid😂"
    #expect(!Valid8().checkPasswordValidity(password))
}

@Test func testPasswordValidatorHasArabic() async throws {
    let password = "Aa1@محمد"
    #expect(!Valid8().checkPasswordValidity(password))
}


    private struct Constants {
        static let lowerCase = ".*[a-z].*"
        static let upperCase = ".*[A-Z].*"
        static let number = ".*\\d.*"
        static let specialCharacters = ".*[^\\x30-\\x39\\x41-\\x5A\\x61-\\x7A\\s].*" // Anything that's not A-Z, a-z , 0-9, not a space
        static let noSpaces = ".*\\s.*"
        static let asciiExtension = "^[\\x00-\\xFF]*$"
    }
    extension Valid8 {

        func checkPasswordCount(_ password: String) -> Bool {
            return Valid8()
                .rule { $0.count >= 8 && $0.count <= 128 }
                .check(password)
        }

        func checkLowerCase(_ password: String) -> Bool {
            let lowerCaseRegex = Constants.lowerCase
            return Valid8()
                .rule { $0.range(of: lowerCaseRegex, options: .regularExpression) != nil }
                .check(password)

        }

        func checkUpperCase(_ password: String) -> Bool {
            let upperCaseRegex = Constants.upperCase
            return Valid8()
                .rule { $0.range(of: upperCaseRegex, options: .regularExpression) != nil }
                .check(password)
        }

        func checkNumber(_ password: String) -> Bool {
            return Valid8()
                .rule { $0.range(of: Constants.number, options: .regularExpression) != nil }
                .check(password)
        }

        func checkSpecialCharacter(_ password: String) -> Bool {
            return Valid8()
                .rule { $0.range(of: Constants.specialCharacters, options: .regularExpression) != nil }
                .check(password)
        }

        func checkSpace(_ password: String) -> Bool {
            return Valid8()
                .rule { $0.range(of: Constants.noSpaces, options: .regularExpression) != nil }
                .check(password)
        }

        func canBeEncodedInWindows1252(_ password: String) -> Bool {
            guard !password.isEmpty else { return false }
            return password.canBeEncoded(using: .windowsCP1252)
        }

        func checkPasswordStrength(_ password: String) -> Int {
            var strength = 0

            if checkPasswordCount(password) {
                strength += 1
            }

            if checkLowerCase(password) {
                strength += 1
            }

            if checkUpperCase(password) {
                strength += 1
            }

            if checkNumber(password) {
                strength += 1
            }

            if checkSpecialCharacter(password) {
                strength += 1
            }

            if checkSpace(password) {
                return 0
            }

            if !canBeEncodedInWindows1252(password) {
                return 0
            }

            return strength
        }

        func checkPasswordValidity(_ password: String) -> Bool {
            let validator = Valid8()
                .rule {
                    !checkSpace($0)
                }
                .rule {
                    canBeEncodedInWindows1252($0)
                }
                .rule {
                    checkLowerCase($0)
                }
                .rule {
                    checkUpperCase($0)
                }
                .rule {
                    checkNumber($0)
                }
                .rule {
                    checkSpecialCharacter($0)
                }
                .rule {
                    checkPasswordCount($0)
                }

            return validator.check(password)
        }
    }

    private extension String {
        func canBeEncoded(using encoding: String.Encoding) -> Bool {
            return self.data(using: encoding) != nil
        }
    }


