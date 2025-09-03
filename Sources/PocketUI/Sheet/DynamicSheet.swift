import SwiftUI

public extension View {
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
