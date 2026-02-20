import Foundation

/// Where ProductDetail was opened from; drives footer visibility (e.g. only "+" from Home Add Products).
enum ProductDetailSource: Hashable {
    case homeAddProducts
    case discover
}

/// Unified route for the home tab navigation stack. Survey, Products, and Scan push onto this stack.
enum AppRoute: Hashable {
    case survey
    case surveyFromProductDetail(productId: String)
    case products(personalized: Bool, fromHome: Bool)
    case productDetail(productId: String, personalized: Bool, source: ProductDetailSource)
    case skincareCoach(productId: String?)
    case scan
    case routine
    case compatibility
    case compatibilityResults
}
