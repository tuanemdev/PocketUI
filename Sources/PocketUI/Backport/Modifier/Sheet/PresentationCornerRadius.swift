import SwiftUI

extension BackportView {
    /// Requests that the presentation have a specific corner radius.
    ///
    /// Use this modifier to change the corner radius of a presentation.
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
    ///                     .backport.presentationCornerRadius(21)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameter cornerRadius: The corner radius, or `nil` to use the system
    ///   default.
    @available(iOS, deprecated: 16.4, message: "use `presentationCornerRadius(_:) instead.")
    @ViewBuilder
    public func presentationCornerRadius(_ cornerRadius: CGFloat?) -> some View {
        if #available(iOS 16.4, *) {
            content.presentationCornerRadius(cornerRadius)
        } else {
            content.background(SheetPresentationRepresentable(cornerRadius: cornerRadius))
        }
    }
}

fileprivate struct SheetPresentationRepresentable: UIViewControllerRepresentable {
    let cornerRadius: CGFloat?
    
    func makeUIViewController(context: Context) -> SheetPresentationController {
        SheetPresentationController(cornerRadius: cornerRadius)
    }
    
    func updateUIViewController(_ controller: SheetPresentationController, context: Context) {
        controller.update(cornerRadius: cornerRadius)
    }
}

fileprivate final class SheetPresentationController: UIViewController, UISheetPresentationControllerDelegate {
    var cornerRadius: CGFloat?
    
    init(cornerRadius: CGFloat?) {
        self.cornerRadius = cornerRadius
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        update(cornerRadius: cornerRadius)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        update(cornerRadius: cornerRadius)
    }
    
    func update(cornerRadius: CGFloat?) {
        self.cornerRadius = cornerRadius
        
        if let controller = parent?.sheetPresentationController {
            controller.animateChanges {
                controller.preferredCornerRadius = cornerRadius
            }
        }
    }
}
