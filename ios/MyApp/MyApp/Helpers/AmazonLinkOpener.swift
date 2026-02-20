import Foundation
import UIKit

/// Opens product's Amazon URL: app deep link if available, else https in Safari.
enum AmazonLinkOpener {
    private static let amazonScheme = "amazon"

    /// Open Amazon for product. Use product.amazonUrl (https). Tries amazon://dp/<ASIN> first if ASIN can be derived.
    static func openAmazon(for product: Product) {
        guard let urlString = product.amazonUrl, !urlString.isEmpty else { return }
        guard let httpsUrl = URL(string: urlString) else { return }

        let asin = extractASIN(from: urlString)
        if let asin = asin, let deepLink = URL(string: "\(amazonScheme)://dp/\(asin)") {
            if UIApplication.shared.canOpenURL(deepLink) {
                UIApplication.shared.open(deepLink)
                return
            }
        }
        UIApplication.shared.open(httpsUrl)
    }

    /// Extract ASIN from Amazon URL (e.g. /dp/B08XXX or /gp/product/B08XXX).
    private static func extractASIN(from urlString: String) -> String? {
        let patterns = ["/dp/([A-Z0-9]{10})", "/gp/product/([A-Z0-9]{10})", "/gp/aw/d/([A-Z0-9]{10})"]
        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern),
               let match = regex.firstMatch(in: urlString, range: NSRange(urlString.startIndex..., in: urlString)),
               let range = Range(match.range(at: 1), in: urlString) {
                return String(urlString[range])
            }
        }
        return nil
    }
}
