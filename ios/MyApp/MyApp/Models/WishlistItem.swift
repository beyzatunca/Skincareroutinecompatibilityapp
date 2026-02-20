import Foundation

/// Represents an item in the user's wishlist (future: link to Product).
struct WishlistItem: Identifiable, Equatable {
    let id: String
    var productId: String?
}
