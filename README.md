# Valid8

A lightweight, composable Swift validation framework for strings and forms. Define rules once and reuse them across your app with clarity and control.

## ✨ Features

    - Combine multiple rules using a declarative API
    - Extensible `Validator` and `Rule` structures
    - Logical chaining 
    - Works great with SwiftUI, Combine, or UIKit

## 📦 Installation

    You can install **Valid8** using Swift Package Manager. In Xcode:

        1. Go to **File > Add Packages…**
    2. Enter the URL:
        ```
        https://github.com/emadhegab/Valid8
        ```
    3. Select the version and target you'd like to add it to.

    Or add it to your `Package.swift`:

    ```swift
    .package(url: "https://github.com/emadhegab/Valid8", from: "1.0.0")
    ```


## 🧪 Usage

### Basic Validation

```swift
    let validator = Valid8()
        .rule { !$0.isEmpty }
        .rule { $0.count >= 3 }

        validator.check("abc") // true
        validator.check("") // false
```


### Composing Rules

```swift
    let hasDigit = Valid8().rule { $0.contains { $0.isNumber } }
    let hasUpper = Valid8().rule { $0.range(of: "[A-Z]", options: .regularExpression) != nil }

    let strongValidator = hasDigit && hasUpper
    strongValidator.check("Password123") // true
    ```

## Password Validation

Use the built-in `checkPasswordValidity` function:

```swift
let isValid = Valid8().checkPasswordValidity("Aa1@#ValidPass")
```

Or compute strength:

```swift
let strength = Valid8().checkPasswordStrength("Aa1@#ValidPass") // Score out of 5
```
 

## 🧪 Testing

Tests are written using Apple’s new [swift-testing](https://github.com/apple/swift-testing) framework.

Run tests with:
    ```
        swift test
    ```

## Contribute 
    * fork
    * add/fix
    * PR and spread the love 
    
## 📄 License

MIT License. See [LICENSE](LICENSE) for details.

---

Crafted with ❤️ by Mohamed Hegab
