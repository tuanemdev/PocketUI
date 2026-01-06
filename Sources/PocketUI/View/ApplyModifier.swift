import SwiftUI

public extension View {
    /// Applies a transformation block to the current view.
    ///
    /// This modifier provides a flexible way to apply conditional modifiers or compose
    /// multiple modifiers together using a closure-based approach.
    ///
    /// - Parameter block: A closure that takes the current view and returns a transformed view.
    ///
    /// - Returns: A new view created by applying the transformation block.
    ///
    /// Usage
    /// ```swift
    /// Text("Modern Design")
    ///     .apply { view in
    ///         if #available(iOS 26, *) {
    ///             view.glassEffect()
    ///         } else {
    ///             view
    ///                 .background(.ultraThinMaterial)
    ///                 .cornerRadius(12)
    ///         }
    ///     }
    /// ```
    ///
    /// - Warning:
    ///   **State Loss**: Using `if-else` with runtime conditions (not `#available` or `#if`)
    ///   creates different view types for each branch, causing SwiftUI to lose view identity
    ///   and reset any `@State` properties when switching between branches.
    @inlinable
    func apply<Content: View>(@ViewBuilder _ block: (Self) -> Content) -> some View {
        block(self)
    }
}
