import SwiftUI

public struct Backport<Content> {
    let content: Content
    
    init(_ content: Content) {
        self.content = content
    }
}

public extension View {
    var backport: Backport<Self> { Backport(self) }
}
