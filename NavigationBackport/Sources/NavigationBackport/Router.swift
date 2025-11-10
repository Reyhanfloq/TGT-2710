import Foundation
import SwiftUI

struct Router<Screen: Hashable, RootView: View>: View {
  let rootView: RootView

  @Binding var screens: [Screen]

  init(rootView: RootView, screens: Binding<[Screen]>) {
    self.rootView = rootView
    _screens = screens
  }

  var pushedScreens: some View {
    Node(allScreens: $screens, truncateToIndex: { screens = Array(screens.prefix($0)) }, index: 0)
  }

  private var isActiveBinding: Binding<Bool> {
    Binding(
      get: {
          print("screen is empty = \(screens.isEmpty)")
          return !screens.isEmpty
      },
      set: { isShowing in
        guard !isShowing else { return }
        guard !screens.isEmpty else { return }
        screens = []
      }
    )
  }

  var body: some View {
    rootView
          .if(screens.count > 0, content: { view in
              view._navigationDestination(isActive: isActiveBinding, destination: pushedScreens)
          })
  }
}

extension View{
    func `if`<Content: View>(
        _ condition: Bool,
        content: (Self) -> Content
    ) -> some View {
        if condition {
            AnyView(content(self))
        } else {
            AnyView(self)
        }
    }

}
