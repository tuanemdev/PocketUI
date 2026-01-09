import SwiftUI

extension Backport {
    public struct ContentUnavailableView<Label: View, Description: View, Actions: View>: View {
        let label: () -> Label
        let description: () -> Description
        let actions: () -> Actions
        
        /// Creates an interface, consisting of a label and additional content, that you
        /// display when the content of your app is unavailable to users.
        ///
        /// - Parameters:
        ///   - label: The label that describes the view.
        ///   - description: The view that describes the interface.
        ///   - actions: The content of the interface actions.
        @available(iOS, deprecated: 17.0, message: "Use SwiftUI.ContentUnavailableView(label:description:actions:) instead.")
        public init(
            @ViewBuilder label: @escaping () -> Label,
            @ViewBuilder description: @escaping () -> Description = { EmptyView() },
            @ViewBuilder actions: @escaping () -> Actions = { EmptyView() }
        ) {
            self.label = label
            self.description = description
            self.actions = actions
        }
        
        public var body: some View {
            if #available(iOS 17.0, *) {
                SwiftUI.ContentUnavailableView(label: label, description: description, actions: actions)
            } else {
                backportView
            }
        }
        
        private var backportView: some View {
            VStack(spacing: 20) {
                VStack {
                    label()
                        .labelStyle(.contentUnavailable)
                    
                    description()
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: 15) {
                    actions()
                }
                .font(.subheadline)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}

extension Backport.ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text?, Actions == EmptyView {
    /// Creates an interface, consisting of a title generated from a localized
    /// string, an image and additional content, that you display when the
    /// content of your app is unavailable to users.
    ///
    /// - Parameters:
    ///    - title: A title generated from a localized string.
    ///    - image: The name of the image resource to lookup.
    ///    - description: The view that describes the interface.
    @available(iOS, deprecated: 17.0, message: "Use SwiftUI.ContentUnavailableView(_:image:description:) instead.")
    public init(
        _ title: LocalizedStringKey,
        image name: String,
        description: Text? = nil
    ) {
        self.label = { SwiftUI.Label(title, image: name) }
        self.description = { description.flatMap { $0 } }
        self.actions = EmptyView.init
    }
    
    /// Creates an interface, consisting of a title generated from a localized
    /// string resource, an image and additional content, that you display when
    /// the content of your app is unavailable to users.
    ///
    /// - Parameters:
    ///    - title: A title generated from a localized string.
    ///    - image: The name of the image resource to lookup.
    ///    - description: The view that describes the interface.
    @available(iOS, deprecated: 17.0, message: "Use SwiftUI.ContentUnavailableView(_:image:description:) instead.")
    public init(
        _ title: LocalizedStringResource,
        image name: String,
        description: Text? = nil
    ) {
        self.label = { SwiftUI.Label(title, image: name) }
        self.description = { description.flatMap { $0 } }
        self.actions = EmptyView.init
    }
    
    /// Creates an interface, consisting of a title generated from a localized
    /// string, a system icon image and additional content, that you display when the
    /// content of your app is unavailable to users.
    ///
    /// - Parameters:
    ///    - title: A title generated from a localized string.
    ///    - systemImage: The name of the system symbol image resource to lookup.
    ///      Use the SF Symbols app to look up the names of system symbol images.
    ///    - description: The view that describes the interface.
    @available(iOS, deprecated: 17.0, message: "Use SwiftUI.ContentUnavailableViewinit(_:systemImage:description:) instead.")
    public init(
        _ title: LocalizedStringKey,
        systemImage name: String,
        description: Text? = nil
    ) {
        self.label = { SwiftUI.Label(title, systemImage: name) }
        self.description = { description.flatMap { $0 } }
        self.actions = EmptyView.init
    }
    
    /// Creates an interface, consisting of a title generated from a localized
    /// string resource, a system icon image and additional content, that you
    /// display when the content of your app is unavailable to users.
    ///
    /// - Parameters:
    ///    - title: A title generated from a localized string.
    ///    - systemImage: The name of the system symbol image resource to lookup.
    ///      Use the SF Symbols app to look up the names of system symbol images.
    ///    - description: The view that describes the interface.
    @available(iOS, deprecated: 17.0, message: "Use SwiftUI.ContentUnavailableViewinit(_:systemImage:description:) instead.")
    public init(
        _ title: LocalizedStringResource,
        systemImage name: String,
        description: Text? = nil
    ) {
        self.label = { SwiftUI.Label(title, systemImage: name) }
        self.description = { description.flatMap { $0 } }
        self.actions = EmptyView.init
    }
    
    /// Creates an interface, consisting of a title generated from a string,
    /// an image and additional content, that you display when the content of
    /// your app is unavailable to users.
    ///
    /// - Parameters:
    ///    - title: A string used as the title.
    ///    - image: The name of the image resource to lookup.
    ///    - description: The view that describes the interface.
    @available(iOS, deprecated: 17.0, message: "Use SwiftUI.ContentUnavailableViewinit(_:image:description:) instead.")
    public init<S>(
        _ title: S,
        image name: String,
        description: Text? = nil
    ) where S : StringProtocol {
        self.label = { SwiftUI.Label(title, image: name) }
        self.description = { description.flatMap { $0 } }
        self.actions = EmptyView.init
    }
    
    /// Creates an interface, consisting of a title generated from a string,
    /// a system icon image and additional content, that you display when the
    /// content of your app is unavailable to users.
    ///
    /// - Parameters:
    ///    - title: A string used as the title.
    ///    - systemImage: The name of the system symbol image resource to lookup.
    ///      Use the SF Symbols app to look up the names of system symbol images.
    ///    - description: The view that describes the interface.
    @available(iOS, deprecated: 17.0, message: "Use SwiftUI.ContentUnavailableViewinit(_:systemImage:description:) instead.")
    public init<S>(
        _ title: S,
        systemImage name: String,
        description: Text? = nil
    ) where S : StringProtocol {
        self.label = { SwiftUI.Label(title, systemImage: name) }
        self.description = { description.flatMap { $0 } }
        self.actions = EmptyView.init
    }
}

fileprivate extension LabelStyle where Self == ContentUnavailableLabelStyle {
    static var contentUnavailable: Self { .init() }
}

fileprivate struct ContentUnavailableLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 10) {
            configuration.icon
                .font(.largeTitle.weight(.medium))
                .foregroundStyle(.secondary)
                .imageScale(.large)
            
            configuration.title
                .font(.title2.weight(.bold))
        }
    }
}
