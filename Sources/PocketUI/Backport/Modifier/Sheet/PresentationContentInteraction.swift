import SwiftUI

extension BackportView {
    /// Configures the behavior of swipe gestures on a presentation.
    ///
    /// By default, when a person swipes up on a scroll view in a resizable
    /// presentation, the presentation grows to the next detent. A scroll view
    /// embedded in the presentation only scrolls after the presentation
    /// reaches its largest size. Use this modifier to control which action
    /// takes precedence.
    ///
    /// For example, you can request that swipe gestures scroll content first,
    /// resizing the sheet only after hitting the end of the scroll view, by
    /// passing the ``Backport/PresentationContentInteraction/scrolls`` value to this
    /// modifier:
    ///
    ///     struct ContentView: View {
    ///         @State private var showSettings = false
    ///
    ///         var body: some View {
    ///             Button("View Settings") {
    ///                 showSettings = true
    ///             }
    ///             .sheet(isPresented: $showSettings) {
    ///                 SettingsView()
    ///                     .presentationDetents([.medium, .large])
    ///                     .backport.presentationContentInteraction(.scrolls)
    ///             }
    ///         }
    ///     }
    ///
    /// People can always resize your presentation using the drag indicator.
    ///
    /// - Parameter behavior: The requested behavior.
    @available(iOS, deprecated: 16.4, message: "use `presentationContentInteraction(_:) instead.")
    @ViewBuilder
    public func presentationContentInteraction(_ behavior: Backport.PresentationContentInteraction) -> some View {
        if #available(iOS 16.4, *) {
            content.presentationContentInteraction(behavior.originalVersion)
        } else {
            content.background(SheetPresentationRepresentable(behavior: behavior))
        }
    }
}

extension Backport {
    /// A behavior that you can use to influence how a presentation responds to
    /// swipe gestures.
    ///
    /// Use values of this type with the
    /// ``BackportView/presentationContentInteraction(_:)`` modifier.
    public struct PresentationContentInteraction: Equatable, Sendable {
        let interaction: Interaction
        
        enum Interaction {
            case automatic
            case resizes
            case scrolls
        }
        
        /// The default swipe behavior for the presentation.
        public static var automatic: Backport.PresentationContentInteraction { .init(interaction: .automatic) }
        
        /// A behavior that prioritizes resizing a presentation when swiping, rather
        /// than scrolling the content of the presentation.
        public static var resizes: Backport.PresentationContentInteraction { .init(interaction: .resizes) }
        
        /// A behavior that prioritizes scrolling the content of a presentation when
        /// swiping, rather than resizing the presentation.
        public static var scrolls: Backport.PresentationContentInteraction { .init(interaction: .scrolls) }
        
        @available(iOS 16.4, *)
        var originalVersion: SwiftUI.PresentationContentInteraction {
            switch self.interaction {
            case .automatic:
                SwiftUI.PresentationContentInteraction.automatic
            case .resizes:
                SwiftUI.PresentationContentInteraction.resizes
            case .scrolls:
                SwiftUI.PresentationContentInteraction.scrolls
            }
        }
    }
}

fileprivate struct SheetPresentationRepresentable: UIViewControllerRepresentable {
    let behavior: Backport.PresentationContentInteraction
    
    func makeUIViewController(context: Context) -> SheetPresentationController {
        SheetPresentationController(behavior: behavior)
    }
    
    func updateUIViewController(_ controller: SheetPresentationController, context: Context) {
        controller.update(behavior: behavior)
    }
}

fileprivate final class SheetPresentationController: UIViewController, UISheetPresentationControllerDelegate {
    var behavior: Backport.PresentationContentInteraction
    
    init(behavior: Backport.PresentationContentInteraction) {
        self.behavior = behavior
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        update(behavior: behavior)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        update(behavior: behavior)
    }
    
    func update(behavior: Backport.PresentationContentInteraction) {
        self.behavior = behavior
        
        if let controller = parent?.sheetPresentationController {
            controller.animateChanges {
                switch behavior.interaction {
                case .automatic, .resizes:
                    controller.prefersScrollingExpandsWhenScrolledToEdge = true
                case .scrolls:
                    controller.prefersScrollingExpandsWhenScrolledToEdge = false
                }
            }
        }
    }
}
