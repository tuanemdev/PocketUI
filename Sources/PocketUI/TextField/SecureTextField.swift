import SwiftUI

public extension TextField {
    /// Toggles the secure text entry behavior of the TextField.
    ///
    /// This modifier allows you to dynamically switch between secure (password-style)
    /// and normal text input modes. When secure is true, the text field will behave
    /// like a SecureField, obscuring the input. When false, it displays text normally.
    ///
    /// - Parameter secure: A Boolean value that determines whether the text field should
    ///   obscure text input.
    ///   - `true`: Text input is obscured (secure mode)
    ///   - `false`: Text input is displayed normally
    ///
    /// - Returns: A modified TextField instance with the secure text entry behavior applied.
    ///
    /// ## Usage
    /// ```swift
    /// struct LoginView: View {
    ///     @State private var password: String = ""
    ///     @State private var isSecure: Bool = true
    ///
    ///     var body: some View {
    ///         VStack {
    ///             TextField("Enter password", text: $password)
    ///                 .secureTextEntry(isSecure)
    ///                 .textFieldStyle(RoundedBorderTextFieldStyle())
    ///
    ///             Button(action: {
    ///                 isSecure.toggle()
    ///             }) {
    ///                 Image(systemName: isSecure ? "eye.slash" : "eye")
    ///             }
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// - Note:
    ///   ⚠️ **Warning**: This extension uses unsafe memory operations and reflection.
    ///   While functional, it relies on SwiftUI's internal structure which may change
    ///   in future versions. Use with caution in production code.
    ///
    ///   If the internal structure of TextField changes or the `isSecure` property
    ///   cannot be found, the method silently fails and returns the original TextField
    ///   unchanged. This ensures app stability even if the implementation becomes
    ///   incompatible with future SwiftUI versions.
    func secureTextEntry(_ secure: Bool) -> TextField {
        var secureField = self
        if let offset = secureField.propertyOffset("isSecure", type: Bool.self) {
            withUnsafeMutablePointer(to: &secureField) { pointer in
                let valuePointer = UnsafeMutableRawPointer(mutating: pointer)
                    .assumingMemoryBound(to: Bool.self)
                    .advanced(by: offset)
                valuePointer.pointee = secure
            }
        }
        return secureField
    }
}

fileprivate extension TextField {
    func propertyOffset<T>(_ label: String, type: T.Type) -> Int? {
        var offset = 0
        for child in Mirror(reflecting: self).children {
            if child.label == label && child.value is T {
                return offset
            }
            offset += MemoryLayout.size(ofValue: child.value)
        }
        return nil
    }
}
