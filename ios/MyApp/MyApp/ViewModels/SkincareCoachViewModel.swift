import Foundation
import SwiftUI

struct CoachMessage: Identifiable {
    let id = UUID()
    let text: String
    let isFromUser: Bool
    let date: Date
}

@MainActor
final class SkincareCoachViewModel: ObservableObject {
    let productId: String?

    @Published var messages: [CoachMessage] = []
    @Published var inputText: String = ""
    @Published var isTyping: Bool = false

    private let product: Product?

    init(productId: String?) {
        self.productId = productId
        self.product = productId.flatMap { SkincareCoachViewModel.loadProduct(id: $0) }
        self.messages = [CoachMessage(text: Self.initialMessageText(product: product), isFromUser: false, date: Date())]
    }

    private static func loadProduct(id: String) -> Product? {
        ProductsViewModel.mockProducts().first { $0.id == id }
    }

    var productDisplayName: String {
        Self.sanitizeDisplayName(product?.name ?? "")
    }

    var productBrand: String {
        let b = product?.brand ?? ""
        if b.isEmpty || b.lowercased() == "undefined" { return "" }
        return b
    }

    /// Top tags/actives from product (e.g. "AHA", "Glycolic Acid") for context and replies.
    var keyTagsActives: [String] {
        guard let tags = product?.tags, !tags.isEmpty else { return [] }
        return tags.filter { !$0.isEmpty && $0.lowercased() != "undefined" }
    }

    var hasProductContext: Bool {
        product != nil
    }

    var inputPlaceholder: String {
        if hasProductContext {
            return "Ask about \(productDisplayName)..."
        }
        return "Ask a question..."
    }

    private static func initialMessageText(product: Product?) -> String {
        if let p = product {
            let name = sanitizeDisplayName(p.name)
            let brandPart = p.brand.isEmpty || p.brand.lowercased() == "undefined" ? "" : " by \(p.brand)"
            return "Hi! I'm your Skincare Coach ✨\n\nI see you're looking at \(name)\(brandPart). Ask me anything about ingredients, how to use it, or compatibility with your routine!"
        }
        return "Hi! I'm your Skincare Coach ✨\n\nAsk me anything about ingredients, how to use products, routine compatibility, or what works best for your skin type."
    }

    private static func sanitizeDisplayName(_ raw: String) -> String {
        let t = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if t.isEmpty || t.lowercased() == "undefined" { return "this product" }
        return t
    }

    func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        inputText = ""
        messages.append(CoachMessage(text: text, isFromUser: true, date: Date()))
        isTyping = true
        Task {
            try? await Task.sleep(nanoseconds: 800_000_000)
            let reply = Self.generateAIReply(userText: text, product: product)
            await MainActor.run {
                messages.append(CoachMessage(text: reply, isFromUser: false, date: Date()))
                isTyping = false
            }
        }
    }

    // MARK: - Product-aware AI reply (rule-based, deterministic)

    static func generateAIReply(userText: String, product: Product?) -> String {
        let lower = userText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let name = product.map { sanitizeDisplayName($0.name) } ?? "this product"
        let tags = product?.tags ?? []

        // 1) Ingredients
        if lower.contains("ingredient") || lower.contains("ingredients") || lower.contains("main ingredients")
            || lower.contains("what's in") || lower.contains("whats in") || lower.contains("active")
            || lower.contains("glycolic") || lower.contains("what does") {
            if let p = product, !p.tags.isEmpty {
                let list = p.tags.prefix(5).map { "• \($0)" }.joined(separator: "\n")
                return "**\(name)** contains several beneficial ingredients:\n\(list)\n\nThe key actives work together to support your skin goals. Would you like to know more about any specific ingredient?"
            }
            return "Key ingredients to look for depend on your goals: vitamin C for brightness, retinol for texture, and niacinamide for balance. If you're looking at a specific product, open it and ask me about its ingredients!"
        }

        // 2) Usage (how to use, apply, routine placement)
        if lower.contains("how to use") || lower.contains("how should i use") || lower.contains("use this")
            || lower.contains("apply") || lower.contains("when do i use") || lower.contains("routine")
            || lower.contains("how do i use") {
            let fallbackSteps = "Apply to clean, dry skin. Use a small amount and allow it to absorb. You can follow with moisturizer if needed."
            let steps = fallbackSteps
            return "**How to use \(name):**\n\n\(steps)\n\n💡 Tip: Always patch test new products before full application!"
        }

        // 3) Compatibility (retinol, vitamin c, niacinamide, combine, layer)
        if lower.contains("with retinol") || lower.contains("retinol") || lower.contains("vitamin c")
            || lower.contains("niacinamide") || lower.contains("combine") || lower.contains("layer")
            || lower.contains("can i use this with") || lower.contains("use with") {
            var advice: String
            let hasAHA = tags.contains { $0.lowercased().contains("aha") || $0.lowercased().contains("glycolic") }
            let hasRetinoid = tags.contains { $0.lowercased().contains("retinol") || $0.lowercased().contains("retinoid") }
            if hasAHA {
                advice = "\(name) contains exfoliating acids (e.g. AHA/Glycolic). To use with retinol, avoid the same night—alternate nights or use acids in the morning and retinol at night. Start slowly and watch for irritation."
            } else if hasRetinoid {
                advice = "\(name) contains a retinoid. Keep it away from strong acids in the same routine. Use on alternate nights from AHAs/BHAs. Start slowly and watch for irritation."
            } else if product != nil {
                advice = "You can generally layer \(name) with other actives. Use a sensible order: thinner products first, then moisturizer. Start slowly and watch for irritation. If using retinol, many people alternate nights to reduce sensitivity."
            } else {
                advice = "When combining actives, alternate nights (e.g. retinol one night, acids another) and always start slowly and watch for irritation."
            }
            return "**Can you use \(name) with retinol?**\n\n\(advice)"
        }

        // 4) Skin type (oily, dry, sensitive, combination, good for)
        if lower.contains("oily") || lower.contains("dry") || lower.contains("sensitive")
            || lower.contains("combination") || lower.contains("good for") || lower.contains("suitable for") {
            let skinHint = lower.contains("oily") ? "oily" : (lower.contains("dry") ? "dry" : (lower.contains("sensitive") ? "sensitive" : (lower.contains("combination") ? "combination" : "your skin type")))
            return "**Is \(name) good for \(skinHint) skin?**\n\nIt can work for many skin types depending on formulation. Check whether the product is labeled non-comedogenic for oily skin, or fragrance-free for sensitive skin. Would you like more specific advice for your routine?"
        }

        // Default: product-specific or general
        if product != nil {
            return "Thanks for your question! For **\(name)** I’d suggest checking the key actives and how to use it in your routine. Ask me about ingredients, how to use it, or using it with retinol or other actives!"
        }
        return "Thanks for your question! I’d recommend checking the product’s key actives and how to use section. Feel free to ask something more specific—ingredients, usage, or compatibility with retinol or other actives."
    }
}
