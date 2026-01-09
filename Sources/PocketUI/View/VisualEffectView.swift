import SwiftUI

/// A SwiftUI wrapper around UIKit's `UIVisualEffectView` for applying blur effects.
///
/// `VisualEffectView` enables modern iOS design patterns like blur backgrounds and frosted glass
/// effects in SwiftUI. It provides a simple way to apply various blur styles to your views.
///
/// ## Usage
/// ```swift
/// ZStack {
///     Image("background")
///         .ignoresSafeArea()
///
///     VisualEffectView(style: .systemMaterial)
///
///     VStack {
///         Text("Content with blur background")
///             .foregroundColor(.white)
///     }
/// }
/// ```
public struct VisualEffectView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    /// Initializes a visual effect view with the specified blur style.
    ///
    /// - Parameter style: The blur effect style to apply to the view.
    public init(style: UIBlurEffect.Style) {
        self.style = style
    }
    
    public func makeUIView(context: Context) -> UIVisualEffectView {
        let effect = UIBlurEffect(style: style)
        return UIVisualEffectView(effect: effect)
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
