# Valid8

A lightweight, composable Swift validation framework that makes form and string validation elegant and reusable. Build complex validation logic with simple, chainable rules.

## ✨ Why Valid8?

- **Composable**: Chain rules together with intuitive operators
- **Reusable**: Define validation logic once, use everywhere
- **Type-safe**: Leverage Swift's type system for reliable validation
- **Framework-agnostic**: Works seamlessly with SwiftUI, UIKit, and Combine
- **Lightweight**: Zero dependencies, minimal footprint

## 🚀 Quick Start

```swift
import Valid8

// Simple validation
let validator = Valid8()
    .rule { !$0.isEmpty }
    .rule { $0.count >= 8 }

let isValid = validator.check("mypassword") // true
```

## 📦 Installation

### Swift Package Manager

**Xcode:**
1. File → Add Package Dependencies
2. Enter: `https://github.com/emadhegab/Valid8`
3. Select version and target

**Package.swift:**
```swift
dependencies: [
    .package(url: "https://github.com/emadhegab/Valid8", from: "1.0.0")
]
```

## 🎯 Usage Examples

### Basic String Validation

```swift
let emailValidator = Valid8()
    .rule { $0.contains("@") }
    .rule { $0.contains(".") }
    .rule { $0.count > 5 }

emailValidator.check("user@example.com") // true
emailValidator.check("invalid") // false
```

### Composing Complex Rules

```swift
// Define reusable components
let hasDigit = Valid8().rule { $0.contains { $0.isNumber } }
let hasUppercase = Valid8().rule { $0.rangeOfCharacter(from: .uppercaseLetters) != nil }
let hasLowercase = Valid8().rule { $0.rangeOfCharacter(from: .lowercaseLetters) != nil }
let minLength = Valid8().rule { $0.count >= 8 }

// Combine with logical operators
let strongPassword = hasDigit && hasUppercase && hasLowercase && minLength

strongPassword.check("SecurePass123") // true
strongPassword.check("weak") // false
```

### Password Validation Made Easy

```swift
// Built-in password validation
let isStrongPassword = Valid8().checkPasswordValidity("MySecure123!")

// Get password strength score (0-5)
let strengthScore = Valid8().checkPasswordStrength("MySecure123!")
```

### Real-World Form Validation

```swift
struct RegistrationForm {
    let usernameValidator = Valid8()
        .rule { $0.count >= 3 }
        .rule { $0.allSatisfy { $0.isLetter || $0.isNumber } }
    
    let emailValidator = Valid8()
        .rule { $0.range(of: #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#, 
                options: [.regularExpression, .caseInsensitive]) != nil }
    
    func validateUser(_ username: String, _ email: String) -> Bool {
        return usernameValidator.check(username) && emailValidator.check(email)
    }
}
```

## 🔧 Advanced Features

### Custom Rules

```swift
extension Valid8 {
    func containsSpecialCharacter() -> Valid8 {
        return rule { password in
            let specialChars = CharacterSet(charactersIn: "!@#$%^&*()_-+=[]{}|;:,.<>?")
            return password.rangeOfCharacter(from: specialChars) != nil
        }
    }
}

let customValidator = Valid8().containsSpecialCharacter()
```

### Integration with SwiftUI

```swift
struct LoginView: View {
    @State private var password = ""
    
    private let passwordValidator = Valid8()
        .rule { $0.count >= 8 }
        .rule { $0.contains { $0.isNumber } }
    
    var body: some View {
        VStack {
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .border(passwordValidator.check(password) ? Color.green : Color.red)
            
            Text(passwordValidator.check(password) ? "✓ Valid" : "✗ Invalid")
                .foregroundColor(passwordValidator.check(password) ? .green : .red)
        }
    }
}
```

## 🧪 Testing

Valid8 uses Apple's modern [swift-testing](https://github.com/apple/swift-testing) framework for comprehensive test coverage.

```bash
swift test
```

## 🤝 Contributing

We welcome contributions! Here's how to get started:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin amazing-feature`)
5. **Open** a Pull Request

### Development Setup

```bash
git clone https://github.com/emadhegab/Valid8.git
cd Valid8
swift build
swift test
```

## 📚 Documentation

For detailed API documentation and advanced usage patterns, visit our [documentation site](https://github.com/emadhegab/Valid8/wiki).

## 🐛 Issues & Support

Found a bug or have a feature request? Please [open an issue](https://github.com/emadhegab/Valid8/issues) on GitHub.

## 📄 License

Valid8 is available under the MIT License. See the [LICENSE](LICENSE) file for details.

---

**Made with ❤️ by [Mohamed Hegab](https://github.com/emadhegab)**

*Building better apps, one validation at a time.*
