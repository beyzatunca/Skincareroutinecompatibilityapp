import SwiftUI

struct SkincareCoachView: View {
    let productId: String?
    let onDismiss: () -> Void
    @StateObject private var viewModel: SkincareCoachViewModel
    @FocusState private var isInputFocused: Bool

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .short
        return f
    }()

    init(productId: String?, onDismiss: @escaping () -> Void) {
        self.productId = productId
        self.onDismiss = onDismiss
        _viewModel = StateObject(wrappedValue: SkincareCoachViewModel(productId: productId))
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            contextStrip
            messageList
            typingIndicator
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "F5F5F5"))
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            inputBar
        }
    }

    private var header: some View {
        HStack(alignment: .center, spacing: Design.space12) {
            coachAvatar
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: Design.space4) {
                    Text("Skincare Coach")
                        .font(.system(size: Design.headerTitleFontSize, weight: .bold))
                        .foregroundColor(Color(hex: "111827"))
                    Image(systemName: "sparkles")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "581C87"))
                }
                Text("AI-powered advice")
                    .font(.system(size: Design.headerSubtitleFontSize))
                    .foregroundColor(Color(hex: "6B7280"))
            }
            Spacer()
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "374151"))
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(Color(hex: "F3E8FF")))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, Design.contentHorizontalPadding)
        .padding(.top, Design.space16)
        .padding(.bottom, Design.space12)
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(hex: "E5E7EB")),
            alignment: .bottom
        )
    }

    private var coachAvatar: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "E8D5F2"))
                .frame(width: 40, height: 40)
            Text("☺")
                .font(.system(size: 22))
        }
    }

    private var contextStrip: some View {
        HStack(spacing: Design.space12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "E5E7EB"))
                .frame(width: 44, height: 44)
            VStack(alignment: .leading, spacing: 2) {
                Text("Discussing")
                    .font(.system(size: Design.surveyBodyFontSize, weight: .semibold))
                    .foregroundColor(Color(hex: "581C87"))
                if viewModel.hasProductContext {
                    Text(productContextLine)
                        .font(.system(size: Design.surveySubtextFontSize))
                        .foregroundColor(Color(hex: "6B7280"))
                        .lineLimit(1)
                }
            }
            Spacer()
        }
        .padding(Design.space12)
        .background(Color(hex: "FAF5FF").opacity(0.8))
        .padding(.horizontal, Design.contentHorizontalPadding)
    }

    private var productContextLine: String {
        let name = viewModel.productDisplayName
        let brand = viewModel.productBrand
        if brand.isEmpty { return name }
        return "\(name) · \(brand)"
    }

    private var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: Design.space16) {
                    ForEach(viewModel.messages) { msg in
                        Group {
                            if msg.isFromUser {
                                UserMessageBubble(text: msg.text)
                            } else {
                                AIMessageCard(message: msg)
                            }
                        }
                        .id(msg.id)
                    }
                }
                .padding(.horizontal, Design.contentHorizontalPadding)
                .padding(.vertical, Design.space16)
                .padding(.bottom, Design.space24)
            }
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: viewModel.messages.count) { _, _ in
                if let last = viewModel.messages.last {
                    withAnimation(.easeOut(duration: 0.2)) {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var typingIndicator: some View {
        Group {
            if viewModel.isTyping {
                HStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { i in
                        TypingDot(delay: Double(i) * 0.15)
                    }
                }
                .padding(.horizontal, Design.space16)
                .padding(.vertical, Design.space12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, Design.contentHorizontalPadding)
                .padding(.bottom, Design.space8)
            }
        }
    }

    private var inputBar: some View {
        HStack(spacing: Design.space12) {
            TextField(viewModel.inputPlaceholder, text: $viewModel.inputText)
                .font(.system(size: Design.surveyBodyFontSize))
                .padding(.horizontal, Design.space16)
                .padding(.vertical, Design.space12)
                .background(Color(hex: "F9FAFB"))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color(hex: "E5E7EB"), lineWidth: 1)
                )
                .focused($isInputFocused)
                .onSubmit { viewModel.sendMessage() }

            Button(action: { viewModel.sendMessage() }) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .frame(width: 48, height: 48)
                    .background(Circle().fill(Color(hex: "14B8A6")))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, Design.contentHorizontalPadding)
        .padding(.vertical, Design.space12)
        .background(Color.white)
    }
}

private struct AIMessageCard: View {
    let message: CoachMessage

    private var bodyText: AttributedString {
        (try? AttributedString(markdown: message.text)) ?? AttributedString(message.text)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Design.space8) {
            Text(bodyText)
                .font(.system(size: Design.surveyBodyFontSize))
                .foregroundColor(Color(hex: "111827"))
                .fixedSize(horizontal: false, vertical: true)
            Text(Self.formatTime(message.date))
                .font(.system(size: Design.surveySubtextFontSize - 1))
                .foregroundColor(Color(hex: "9CA3AF"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Design.space16)
        .background(
            RoundedRectangle(cornerRadius: Design.productsCardCornerRadius)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
        )
    }

    private static func formatTime(_ date: Date) -> String {
        let f = DateFormatter()
        f.timeStyle = .short
        return f.string(from: date)
    }
}

private struct UserMessageBubble: View {
    let text: String

    var body: some View {
        HStack(alignment: .bottom) {
            Spacer(minLength: 48)
            Text(text)
                .font(.system(size: Design.surveyBodyFontSize))
                .foregroundColor(.white)
                .padding(.horizontal, Design.space16)
                .padding(.vertical, Design.space12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: "0D9488"))
                )
        }
    }
}

private struct TypingDot: View {
    let delay: Double
    @State private var isUp = false

    var body: some View {
        Circle()
            .fill(Color(hex: "9CA3AF"))
            .frame(width: 8, height: 8)
            .offset(y: isUp ? -4 : 0)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 0.4)
                    .repeatForever(autoreverses: true)
                    .delay(delay)
                ) {
                    isUp = true
                }
            }
    }
}

#Preview {
    SkincareCoachView(productId: "13", onDismiss: {})
}
