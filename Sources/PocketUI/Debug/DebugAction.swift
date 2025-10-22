import SwiftUI

public extension View {
    /// Performs a debug action on the view.
    ///
    /// This modifier allows you to execute debug operations on your SwiftUI views during development.
    /// All debug actions are only executed in DEBUG builds and are automatically stripped from release builds.
    ///
    /// - Parameter action: The debug action to perform. See ``DebugAction`` for available options.
    /// - Returns: The unmodified view (debug actions don't alter the view hierarchy).
    ///
    /// - Note: This modifier only executes in DEBUG builds. In release builds, it simply returns `self` without any overhead.
    func debug(_ action: DebugAction) -> Self {
        #if DEBUG
        switch action {
        case .logChanges:
            if #available(iOS 17.1, *) {
                Self._logChanges()
            } else {
                Self._printChanges()
            }
            
        case .printStructure:
            let mirror = Mirror(reflecting: self)
            let typeName = String(describing: type(of: self))
            debugPrint("\(typeName) {")
            for child in mirror.children {
                if let label = child.label {
                    debugPrint("    \(label): \(child.value)")
                }
            }
            debugPrint("}")
            
        case .custom(let operation):
            operation()
        }
        #endif // DEBUG
        return self
    }
}

/// A set of debugging actions that can be performed on SwiftUI views during development.
///
/// `DebugAction` provides utilities to help diagnose and understand SwiftUI view behavior.
/// These actions are only executed in DEBUG builds and have zero overhead in production.
///
/// Use debug actions with the `debug(_:)` view modifier to gain insights into your SwiftUI views:
public enum DebugAction {
    /// Logs what causes a view to re-render by tracking changes to its dependencies, state, and properties.
    case logChanges
    
    /// Prints the internal structure of a view, including its type and all properties with their values.
    case printStructure
    
    /// Executes a custom closure for debugging purposes.
    case custom(() -> Void)
}
