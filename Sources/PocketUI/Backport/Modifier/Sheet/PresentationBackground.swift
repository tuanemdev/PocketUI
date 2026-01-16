import SwiftUI

extension BackportView {
    /// Sets the presentation background of the enclosing sheet using a shape
    /// style.
    ///
    /// The following example uses the ``Material/thick`` material as the sheet
    /// background:
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
    ///                     .backport.presentationBackground(.thickMaterial)
    ///             }
    ///         }
    ///     }
    ///
    /// The `presentationBackground(_:)` modifier differs from the
    /// ``View/background(_:ignoresSafeAreaEdges:)`` modifier in several key
    /// ways. A presentation background:
    ///
    /// * Automatically fills the entire presentation.
    /// * Allows views behind the presentation to show through translucent
    ///   styles on supported platforms.
    ///
    /// - Parameter style: The shape style to use as the presentation
    ///   background.
    ///
    /// - Note: Sheet presentations on macOS do not support translucency
    /// or transparency — the background is always opaque.
    @available(iOS, deprecated: 16.4, message: "use `presentationBackground(_:) instead.")
    @ViewBuilder
    public func presentationBackground<S>(_ style: S) -> some View where S : ShapeStyle {
        if #available(iOS 16.4, *) {
            content.presentationBackground(style)
        } else {
            content.background(
                SheetPresentationRepresentable(
                    content: Rectangle()
                        .fill(style)
                        .ignoresSafeArea(.container, edges: .all)
                )
            )
        }
    }
    
    /// Sets the presentation background of the enclosing sheet to a custom
    /// view.
    ///
    /// The following example uses a yellow view as the sheet background:
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
    ///                     .backport.presentationBackground {
    ///                         Color.yellow
    ///                     }
    ///             }
    ///         }
    ///     }
    ///
    /// The `presentationBackground(alignment:content:)` modifier differs from
    /// the ``View/background(alignment:content:)`` modifier in several key
    /// ways. A presentation background:
    ///
    /// * Automatically fills the entire presentation.
    /// * Allows views behind the presentation to show through translucent
    ///   areas of the `content` on supported platforms.
    ///
    /// - Parameters:
    ///   - alignment: The alignment that the modifier uses to position the
    ///     implicit ``ZStack`` that groups the background views. The default is
    ///     ``Alignment/center``.
    ///   - content: The view to use as the background of the presentation.
    ///
    /// - Note: Sheet presentations on macOS do not support translucency
    /// or transparency — the background is always opaque.
    @available(iOS, deprecated: 16.4, message: "use `presentationBackground(alignment:content:) instead.")
    @ViewBuilder
    public func presentationBackground<V>(alignment: Alignment = .center, @ViewBuilder content: () -> V) -> some View where V : View {
        if #available(iOS 16.4, *) {
            self.content.presentationBackground(alignment: alignment, content: content)
        } else {
            self.content.background(
                SheetPresentationRepresentable(
                    content:
                        ZStack(alignment: alignment) {
                            Color.clear
                            content()
                        }
                        .ignoresSafeArea(.container, edges: .all)
                )
            )
        }
    }
}

fileprivate struct SheetPresentationRepresentable<V>: UIViewControllerRepresentable where V : View {
    let content: V
    
    func makeUIViewController(context: Context) -> SheetPresentationController {
        SheetPresentationController(backgroundView: UIHostingController(rootView: content).view)
    }
    
    func updateUIViewController(_ controller: SheetPresentationController, context: Context) {
        controller.update(backgroundView: UIHostingController(rootView: content).view)
    }
}

fileprivate final class SheetPresentationController: UIViewController, UISheetPresentationControllerDelegate {
    private var currentBackgroundView: UIView
    
    init(backgroundView: UIView) {
        self.currentBackgroundView = backgroundView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        update(backgroundView: currentBackgroundView)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        update(backgroundView: currentBackgroundView)
    }
    
    func update(backgroundView: UIView) {
        guard let sheetContainerView = self.parent?.view else {
            return
        }
        sheetContainerView.backgroundColor = .clear
        currentBackgroundView.removeFromSuperview()
        backgroundView.backgroundColor = .clear
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        sheetContainerView.insertSubview(backgroundView, at: 0)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: sheetContainerView.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: sheetContainerView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: sheetContainerView.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: sheetContainerView.bottomAnchor)
        ])
        currentBackgroundView = backgroundView
    }
}
