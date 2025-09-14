import SwiftUI

public extension View {
    /// Applies dynamic presentation detents to a sheet that automatically adjusts its height based on content size.
    ///
    /// This modifier creates a sheet that dynamically resizes itself to fit its content, with a maximum height
    /// of 80% of the screen height. The sheet height updates smoothly when the content size changes, providing
    /// a responsive user experience.
    ///
    /// - Parameter animation: The animation to use when the sheet height changes. Defaults to `.smooth`.
    ///
    /// - Returns: A view modified with dynamic sheet presentation behavior.
    ///
    /// ## Usage
    /// ```swift
    /// .sheet(isPresented: $showSheet) {
    ///     VStack {
    ///         Text("Dynamic Content")
    ///         // Content that may change in size
    ///     }
    ///     .presentationDetentsDynamic(.snappy)
    /// }
    /// ```
    ///
    /// - Note:
    ///   - The sheet initially sizes to fit its content
    ///   - Maximum height is capped at 80% of screen height
    ///   - Height adjustments are animated for smooth transitions
    func presentationDetentsDynamic(_ animation: Animation = .smooth) -> some View {
        self.modifier(DynamicSheetModifier(animation: animation))
    }
}

fileprivate struct DynamicSheetModifier: ViewModifier {
    let animation: Animation
    
    @State private var sheetHeight: CGFloat = .zero
    
    func body(content: Content) -> some View {
        content
            .onGeometryChange(for: CGFloat.self) { proxy in
                proxy.size.height
            } action: { contentHeight in
                let newSheetHeight = min(contentHeight, windowSize.height * 0.8)
                if sheetHeight == .zero {
                    sheetHeight = newSheetHeight
                } else {
                    withAnimation(animation) {
                        sheetHeight = newSheetHeight
                    }
                }
            }
            .modifier(SheetHeightModifier(height: sheetHeight))
    }
    
    private var windowSize: CGSize {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.screen.bounds.size
        }
        return .zero
    }
}

fileprivate struct SheetHeightModifier: ViewModifier, @preconcurrency Animatable {
    var height: CGFloat
    
    var animatableData: CGFloat {
        get { height }
        set { height = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .presentationDetents([.height(height)])
    }
}
