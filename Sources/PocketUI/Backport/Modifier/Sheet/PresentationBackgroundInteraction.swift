import SwiftUI

extension BackportView {
    /// Controls whether people can interact with the view behind a
    /// presentation.
    ///
    /// On many platforms, SwiftUI automatically disables the view behind a
    /// sheet that you present, so that people can't interact with the backing
    /// view until they dismiss the sheet. Use this modifier if you want to
    /// enable interaction.
    ///
    /// The following example enables people to interact with the view behind
    /// the sheet when the sheet is at the smallest detent, but not at the other
    /// detents:
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
    ///                     .presentationDetents(
    ///                         [.height(120), .medium, .large])
    ///                     .backport.presentationBackgroundInteraction(.enabled)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - interaction: A specification of how people can interact with the
    ///     view behind a presentation.
    ///
    /// - Warning: Only works perfectly with automatic, enabled, and disabled. The upThrough case cannot be properly backported.
    @available(iOS, deprecated: 16.4, message: "use `presentationBackgroundInteraction(_:)` instead.")
    @ViewBuilder
    public func presentationBackgroundInteraction(_ interaction: Backport.PresentationBackgroundInteraction) -> some View {
        if #available(iOS 16.4, *) {
            content.presentationBackgroundInteraction(interaction.originalVersion)
        } else {
            content.background(SheetPresentationRepresentable(interaction: interaction))
        }
    }
}

extension Backport {
    /// The kinds of interaction available to views behind a presentation.
    ///
    /// Use values of this type with the
    /// ``BackportView/presentationBackgroundInteraction(_:)`` modifier.
    public struct PresentationBackgroundInteraction: Equatable, Sendable {
        let interaction: Interaction
        
        enum Interaction: Equatable {
            case automatic
            case enabled
            case upThrough(detent: PresentationDetent)
            case disabled
        }
        
        /// The default background interaction for the presentation.
        public static var automatic: Backport.PresentationBackgroundInteraction { .init(interaction: .automatic) }
        
        /// People can interact with the view behind a presentation.
        public static var enabled: Backport.PresentationBackgroundInteraction { .init(interaction: .enabled) }
        
        /// People can interact with the view behind a presentation up through a
        /// specified detent.
        ///
        /// At detents larger than the one you specify, SwiftUI disables
        /// interaction.
        ///
        /// - Parameter detent: The largest detent at which people can interact with
        ///   the view behind the presentation.
        public static func enabled(upThrough detent: PresentationDetent) -> Backport.PresentationBackgroundInteraction {
            .init(interaction: .upThrough(detent: detent))
        }
        
        /// People can't interact with the view behind a presentation.
        public static var disabled: Backport.PresentationBackgroundInteraction { .init(interaction: .disabled) }
        
        @available(iOS 16.4, *)
        var originalVersion: SwiftUI.PresentationBackgroundInteraction {
            switch self.interaction {
            case .automatic:
                SwiftUI.PresentationBackgroundInteraction.automatic
            case .enabled:
                SwiftUI.PresentationBackgroundInteraction.enabled
            case .upThrough(let detent):
                SwiftUI.PresentationBackgroundInteraction.enabled(upThrough: detent)
            case .disabled:
                SwiftUI.PresentationBackgroundInteraction.disabled
            }
        }
    }
}

fileprivate struct SheetPresentationRepresentable: UIViewControllerRepresentable {
    let interaction: Backport.PresentationBackgroundInteraction
    
    func makeUIViewController(context: Context) -> SheetPresentationController {
        SheetPresentationController(interaction: interaction)
    }
    
    func updateUIViewController(_ controller: SheetPresentationController, context: Context) {
        controller.update(interaction: interaction)
    }
}

fileprivate final class SheetPresentationController: UIViewController, UISheetPresentationControllerDelegate {
    var interaction: Backport.PresentationBackgroundInteraction
    
    init(interaction: Backport.PresentationBackgroundInteraction) {
        self.interaction = interaction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        update(interaction: interaction)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        update(interaction: interaction)
    }
    
    func update(interaction: Backport.PresentationBackgroundInteraction) {
        self.interaction = interaction
        
        if let controller = parent?.sheetPresentationController {
            controller.animateChanges {
                switch interaction.interaction {
                case .automatic, .disabled:
                    controller.largestUndimmedDetentIdentifier = nil
                    controller.presentingViewController.view?.tintAdjustmentMode = .automatic
                case .enabled:
                    controller.largestUndimmedDetentIdentifier = .large
                    controller.presentingViewController.view?.tintAdjustmentMode = .normal
                case .upThrough(let detent):
                    let uiKitDetentId: UISheetPresentationController.Detent.Identifier?
                    switch detent {
                    case .large:
                        uiKitDetentId = .large
                    case .medium:
                        uiKitDetentId = .medium
                    default: // can't handle
                        uiKitDetentId = nil
                    }
                    controller.largestUndimmedDetentIdentifier = uiKitDetentId
                    
                    let selectedId = controller.selectedDetentIdentifier ?? .large
                    let tintAdjustment: UIView.TintAdjustmentMode
                    switch (selectedId, detent) {
                    case (.large, .medium):
                        tintAdjustment = .dimmed
                    default:
                        tintAdjustment = .normal
                    }
                    controller.presentingViewController.view?.tintAdjustmentMode = tintAdjustment
                }
            }
        }
    }
}
