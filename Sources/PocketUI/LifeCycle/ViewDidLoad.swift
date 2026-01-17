import SwiftUI

public extension View {
    /// Adds an action to perform when this view loads.
    ///
    /// A view modifier that executes code when a view loads, similar to `viewDidLoad()` in UIKit.
    ///
    /// This modifier ensures that the provided action is executed exactly once when the view appears.
    /// It's useful for initializing data, setting up analytics, or performing other setup tasks
    /// that should happen when a view first loads.
    ///
    /// - Parameter action: An optional closure to be executed when the view loads.
    ///   If `nil`, no action is performed.
    ///
    /// - Returns: A modified view with the load action applied.
    ///
    /// ## Usage
    /// ```swift
    /// VStack {
    ///     Text("Hello, World!")
    /// }
    /// .onLoad {
    ///     print("View did load")
    ///     // Perform initialization tasks
    /// }
    /// ```
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
}

fileprivate struct ViewDidLoadModifier: ViewModifier {
    private let action: (() -> Void)?
    
    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }
    
    @State private var didLoad = false
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                guard !didLoad else { return }
                didLoad = true
                action?()
            }
    }
}
