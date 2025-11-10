import Foundation
import SwiftUI

/// Modifier for appending a new destination builder.
struct DestinationBuilderModifier<TypedData>: ViewModifier {
  let typedDestinationBuilder: DestinationBuilder<TypedData>

    @Environment(\.destinationBuilder) var destinationBuilder // Changed this line

  func body(content: Content) -> some View {
    destinationBuilder?.appendBuilder(typedDestinationBuilder)

    return content
          .environment(\.destinationBuilder, destinationBuilder)
  }
}

struct DestinationBuilderKey: EnvironmentKey {
  static let defaultValue: DestinationBuilderHolder? = nil
}

extension EnvironmentValues {
  var destinationBuilder: DestinationBuilderHolder? {
    get { self[DestinationBuilderKey.self] }
    set { self[DestinationBuilderKey.self] = newValue }
  }
}
