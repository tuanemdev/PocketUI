import SwiftUI

public struct VisualEffectView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    public init(style: UIBlurEffect.Style) {
        self.style = style
    }
    
    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        let effect = UIBlurEffect(style: style)
        return UIVisualEffectView(effect: effect)
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
