import SwiftUI

public extension View {
    /// Applies a secure layer property to discourage screen recording and screenshots.
    ///
    /// This modifier wraps the SwiftUI content inside a `UIHostingController` and manipulates
    /// the underlying `CALayer` to leverage UIKit's secure text entry behavior. By associating
    /// the hosting view's layer with a secure text field's internal view hierarchy, the system
    /// attempts to omit or obscure this content from:
    /// - System screenshots and screen recordings
    /// - App Switcher snapshots
    /// - Some system-level accessibility or preview snapshots
    ///
    /// - Parameter isActive: Whether to enable the secure layer behavior.
    /// - Returns: A view with secure layer properties applied when active.
    ///
    /// ## Usage
    /// ```swift
    /// Text("Sensitive information")
    ///     .secured(isPrivateMode)
    /// ```
    ///
    /// - Warning:
    ///   - This technique relies on undocumented UIKit behavior that may change in future OS releases.
    ///   - This does NOT provide cryptographic security—it is purely a UI-level mitigation.
    ///   - Some third-party screen capture tools or jailbroken devices may bypass this protection.
    ///   - Layout and animations should work normally, but edge cases may affect hit-testing or
    ///     subview interactions. Test thoroughly with your UI.
    func secured(_ isActive: Bool) -> some View {
        SecureView(isSecured: isActive) { self }
    }
}

fileprivate struct SecureView<Content: View>: UIViewRepresentable {
    private let hostingController: UIHostingController<Content>
    private let isSecured: Bool
    
    init(isSecured: Bool, @ViewBuilder content: () -> Content) {
        self.isSecured = isSecured
        hostingController = UIHostingController(rootView: content())
    }
    
    func makeUIView(context: Context) -> UIView {
        hostingController.view.layer.secured(isSecured, in: context)
        return hostingController.view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.layer.secured(isSecured, in: context)
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIView, context: Context) -> CGSize? {
        let targetSize = CGSize(
            width: proposal.width ?? .infinity,
            height: proposal.height ?? .infinity
        )
        return hostingController.sizeThatFits(in: targetSize)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    final class Coordinator {
        var textField: UITextField?
    }
}

fileprivate extension CALayer {
    func secured(_ isActive: Bool, in context: SecureView<some View>.Context) {
        if context.coordinator.textField == nil {
            context.coordinator.textField = UITextField()
        }
        guard let textField = context.coordinator.textField,
              let secureView = textField.subviews.first
        else { return }
        let originalLayer = secureView.layer
        secureView.setValue(self, forKey: "layer")
        textField.isSecureTextEntry = isActive
        secureView.setValue(originalLayer, forKey: "layer")
    }
}
