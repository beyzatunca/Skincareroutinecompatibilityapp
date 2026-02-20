import SwiftUI

/// Single routine item card: thumbnail, name/brand, delete; Time of Day and Frequency pill chips.
struct RoutineItemCardView: View {
    let item: RoutineItem
    let onUpdate: (String, RoutineTimeOfDay, RoutineFrequency) -> Void
    let onDelete: (String) -> Void

    @State private var timeOfDay: RoutineTimeOfDay
    @State private var frequency: RoutineFrequency

    init(item: RoutineItem, onUpdate: @escaping (String, RoutineTimeOfDay, RoutineFrequency) -> Void, onDelete: @escaping (String) -> Void) {
        self.item = item
        self.onUpdate = onUpdate
        self.onDelete = onDelete
        _timeOfDay = State(initialValue: item.timeOfDay)
        _frequency = State(initialValue: item.frequency)
    }

    private static let mintBackground = Color(hex: "B8E6D5")
    private static let mintText = Color(hex: "047857")
    private static let borderGray = Color(hex: "E5E7EB")
    private static let textGray = Color(hex: "374151")
    private static let pillCornerRadius: CGFloat = 20
    private static let cardCornerRadius: CGFloat = 16
    private static let thumbnailSize: CGFloat = 56

    var body: some View {
        VStack(alignment: .leading, spacing: Design.space16) {
            topRow
            timeOfDaySection
            frequencySection
        }
        .padding(Design.space16)
        .background(
            RoundedRectangle(cornerRadius: Self.cardCornerRadius)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Self.cardCornerRadius)
                .stroke(Color(hex: "F3F4F6"), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
        .onChange(of: item.timeOfDay) { _, newValue in timeOfDay = newValue }
        .onChange(of: item.frequency) { _, newValue in frequency = newValue }
    }

    private var topRow: some View {
        HStack(alignment: .center, spacing: Design.space12) {
            thumbnailView
            VStack(alignment: .leading, spacing: 2) {
                Text(item.product.name)
                    .font(.system(size: Design.surveyBodyFontSize + 1, weight: .bold))
                    .foregroundColor(Color(hex: "111827"))
                    .lineLimit(2)
                Text(item.product.brand)
                    .font(.system(size: Design.surveySubtextFontSize))
                    .foregroundColor(Color(hex: "6B7280"))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Button {
                onDelete(item.id)
            } label: {
                Image(systemName: "trash")
                    .font(.system(size: 18))
                    .foregroundColor(Color(hex: "6B7280"))
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
        }
    }

    private var thumbnailView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Design.space8)
                .fill(Color(hex: "F3F4F6"))
                .frame(width: Self.thumbnailSize, height: Self.thumbnailSize)
                .overlay(
                    RoundedRectangle(cornerRadius: Design.space8)
                        .stroke(Self.borderGray, lineWidth: 1)
                )
            if let name = item.product.imageName {
                Image(name)
                    .resizable()
                    .scaledToFill()
                    .frame(width: Self.thumbnailSize, height: Self.thumbnailSize)
                    .clipShape(RoundedRectangle(cornerRadius: Design.space8))
            } else {
                Image(systemName: "photo")
                    .font(.system(size: 22))
                    .foregroundColor(Color(hex: "9CA3AF"))
            }
        }
    }

    private var timeOfDaySection: some View {
        VStack(alignment: .leading, spacing: Design.space8) {
            Text("Time of Day")
                .font(.system(size: Design.surveyBodyFontSize, weight: .medium))
                .foregroundColor(Self.textGray)
            HStack(spacing: Design.space12) {
                ForEach(RoutineTimeOfDay.allCases, id: \.self) { option in
                    pillChip(
                        label: option.rawValue,
                        isSelected: timeOfDay == option
                    ) {
                        timeOfDay = option
                        onUpdate(item.id, timeOfDay, frequency)
                    }
                }
            }
        }
    }

    private var frequencySection: some View {
        VStack(alignment: .leading, spacing: Design.space8) {
            Text("Frequency")
                .font(.system(size: Design.surveyBodyFontSize, weight: .medium))
                .foregroundColor(Self.textGray)
            HStack(spacing: Design.space12) {
                ForEach(RoutineFrequency.allCases, id: \.self) { option in
                    pillChip(
                        label: option.chipLabel,
                        isSelected: frequency == option
                    ) {
                        frequency = option
                        onUpdate(item.id, timeOfDay, frequency)
                    }
                }
            }
        }
    }

    private func pillChip(label: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: Design.surveyBodyFontSize, weight: .medium))
                .lineLimit(1)
                .minimumScaleFactor(0.85)
                .foregroundColor(isSelected ? Self.mintText : Self.textGray)
                .padding(.horizontal, Design.space16)
                .padding(.vertical, Design.space12)
                .background(
                    RoundedRectangle(cornerRadius: Self.pillCornerRadius)
                        .fill(isSelected ? Self.mintBackground : Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Self.pillCornerRadius)
                        .stroke(Self.borderGray, lineWidth: isSelected ? 0 : 1)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    RoutineItemCardView(
        item: RoutineItem(
            id: "13",
            product: Product(id: "13", name: "Anthelios Melt-in Milk SPF 60", brand: "La Roche-Posay", priceTier: .mid, tags: [], category: .sunscreen, matchScore: 0.9, imageName: nil, amazonUrl: nil),
            timeOfDay: .pm,
            frequency: .daily
        ),
        onUpdate: { _, _, _ in },
        onDelete: { _ in }
    )
    .padding()
}
