import SwiftUI

public extension View {
    /// Creates a reverse mask effect where the masked area becomes transparent instead of visible.
    ///
    /// Unlike a standard mask that shows only the masked area, a reverse mask hides the masked area
    /// and displays everything else. This is useful for creating cutout effects, punch-holes, or
    /// revealing backgrounds through specific shapes.
    ///
    /// - Parameters:
    ///   - alignment: The alignment guide for positioning the mask within the view. Default is `.center`.
    ///   - mask: A view builder closure that returns the mask shape. The area covered by this view
    ///           will become transparent, while the rest of the view remains visible.
    ///
    /// - Returns: A view with the reverse mask effect applied.
    ///
    /// ## Usage
    /// ```swift
    /// Image("background")
    ///     .reverseMask(alignment: .topLeading) {
    ///         RoundedRectangle(cornerRadius: 20)
    ///             .frame(width: 80, height: 80)
    ///             .padding()
    ///     }
    /// ```
    ///
    /// - Note: This modifier uses the `.destinationOut` blend mode to create the reverse masking effect.
    ///         The masked area will be completely transparent, revealing any views behind it.
    @inlinable
    func reverseMask<Mask>(alignment: Alignment = .center, @ViewBuilder _ mask: () -> Mask) -> some View where Mask : View {
        self.mask {
            Rectangle()
                .overlay(alignment: alignment) {
                    mask()
                        .blendMode(.destinationOut)
                }
        }
    }
}
