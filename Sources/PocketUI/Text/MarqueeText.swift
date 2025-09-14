import SwiftUI

public extension Text {
    /// Creates a marquee scrolling effect for text that overflows its container.
    ///
    /// This modifier makes text scroll horizontally when it's too wide to fit in the available space.
    /// The text will continuously scroll from right to left with optional fade effects on the edges.
    ///
    /// - Parameters:
    ///   - startDelay: The delay in seconds before the scrolling animation begins. Default is 1.0 second.
    ///   - speed: The scrolling speed in points per second. Higher values make the text scroll faster. Default is 30.0.
    ///   - leftFade: The width of the fade effect on the left edge in points. If nil, no left fade is applied.
    ///   - rightFade: The width of the fade effect on the right edge in points. If nil, no right fade is applied.
    ///
    /// - Returns: A view with the marquee scrolling effect applied.
    ///
    /// ## Usage
    /// ```swift
    /// Text("This is a very long text that will scroll")
    ///     .marquee(startDelay: 2.0, speed: 50.0, leftFade: 20, rightFade: 20)
    /// ```
    ///
    /// - Note: The marquee effect only activates when the text is wider than its container.
    ///         If the text fits within the available space, it displays normally without scrolling.
    func marquee(
        startDelay: Double = 1.0,
        speed: Double = 30.0,
        leftFade: Double? = nil,
        rightFade: Double? = nil,
    ) -> some View {
        modifier(MarqueeTextModifier(startDelay: startDelay, speed: speed, leftFade: leftFade, rightFade: rightFade))
    }
}

fileprivate struct MarqueeTextModifier: ViewModifier {
    let startDelay: Double
    let speed: Double
    let leftFade: Double?
    let rightFade: Double?
    
    @State private var contentSize: CGSize = .zero
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .lineLimit(1)
            .hidden()
            .background {
                content
                    .lineLimit(1)
                    .fixedSize()
                    .hidden()
                    .onGeometryChange(for: CGSize.self) { proxy in
                        proxy.size
                    } action: { newValue in
                        contentSize = newValue
                    }
            }
            .overlay(alignment: .leading) {
                GeometryReader { proxy in
                    if contentSize.width > proxy.size.width {
                        let animation = Animation
                            .linear(duration: contentSize.width / speed)
                            .delay(startDelay)
                            .repeatForever(autoreverses: false)
                        let offsetX = contentSize.width + contentSize.height * 2
                        
                        Group {
                            content
                                .offset(x: isAnimating ? -offsetX : .zero)
                            content
                                .offset(x: isAnimating ? .zero : offsetX)
                        }
                        .lineLimit(1)
                        .fixedSize()
                        .offset(x: leftFade ?? .zero)
                        .animation(animation, value: isAnimating)
                        .frame(minWidth: .zero, maxWidth: .infinity, alignment: .leading)
                        .mask(fadeMask(leftFade: leftFade ?? .zero, rightFade: rightFade ?? .zero))
                        .onAppear {
                            isAnimating = true
                        }
                    } else {
                        content
                            .lineLimit(1)
                    }
                }
            }
    }
    
    private func fadeMask(leftFade: Double, rightFade: Double) -> some View {
        HStack(spacing: 0) {
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0), Color.black]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: leftFade)
            
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.black]),
                startPoint: .leading,
                endPoint: .trailing
            )
            
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.black.opacity(0)]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: rightFade)
        }
    }
}
