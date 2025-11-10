import Foundation
import SwiftUI

/// An object that publishes changes to the path Array it holds.
class NavigationPathHolder: ObservableObject {
    @Published var path: [AnyHashable]{
        willSet{
            willSetToNoView = newValue.isEmpty
        }
        didSet{
            Task {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    self.willSetToNoView = false
                }
            }
        }
    }
    @Published var willSetToNoView: Bool = false

  init(path: [AnyHashable] = []) {
    self.path = path
  }
}
