import SwiftUI

/// A namespace for backported SwiftUI types and views.
///
/// Use this enum to access components that emulate newer SwiftUI features
/// on older operating system versions without conflicting with the standard library.
///
/// ## Usage
/// ```swift
/// Backport.ContentUnavailableView {
///     Label("Connection issue", systemImage: "wifi.slash")
/// } description: {
///     Text("Check your internet connection")
/// } actions: {
///     Button("Refresh") {}
/// }
/// ```
public enum Backport {}

/// A wrapper view used to expose backported view modifiers.
///
/// This struct acts as a proxy, allowing you to chain custom extensions via the `.backport` syntax
public struct BackportView<Content: View> {
    let content: Content
    
    init(_ content: Content) {
        self.content = content
    }
}

public extension View {
    /// Accesses the backport namespace to apply modifiers available on newer OS versions.
    ///
    /// Use this property to invoke functions defined in `BackportView` extensions.
    ///
    /// ## Usage
    /// ```swift
    /// ContentView()
    ///     .backport.presentationCornerRadius(14)
    /// ```
    var backport: BackportView<Self> { BackportView(self) }
}
