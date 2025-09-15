import SwiftUI

public extension View {
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
