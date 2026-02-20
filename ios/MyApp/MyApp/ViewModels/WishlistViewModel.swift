import Foundation
import SwiftUI

@MainActor
final class WishlistViewModel: ObservableObject {
    @Published var items: [WishlistItem] = []

    var itemCountText: String {
        "\(items.count) items"
    }
}
