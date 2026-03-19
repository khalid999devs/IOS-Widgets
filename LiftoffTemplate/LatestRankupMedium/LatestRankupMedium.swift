import WidgetKit
import SwiftUI
import AppIntents

enum LatestRankupMediumMode: String, AppEnum {
    case minimal
    case mascot

    static var typeDisplayRepresentation: TypeDisplayRepresentation { "Mode" }

    static var caseDisplayRepresentations: [LatestRankupMediumMode: DisplayRepresentation] {
        [
            .minimal: "Minimal",
            .mascot: "Mascot"
        ]
    }
}

struct LatestRankupMediumConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Latest Rankup Medium"
    static var description = IntentDescription("Choose a widget mode")

    @Parameter(title: "Mode")
    var mode: LatestRankupMediumMode?
}

struct LatestRankupMediumProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> LatestRankupMediumEntry {
        LatestRankupMediumEntry(
            date: .now,
            configuration: LatestRankupMediumConfigurationIntent()
        )
    }

    func snapshot(
        for configuration: LatestRankupMediumConfigurationIntent,
        in context: Context
    ) async -> LatestRankupMediumEntry {
        LatestRankupMediumEntry(
            date: .now,
            configuration: configuration
        )
    }

    func timeline(
        for configuration: LatestRankupMediumConfigurationIntent,
        in context: Context
    ) async -> Timeline<LatestRankupMediumEntry> {
        let entry = LatestRankupMediumEntry(
            date: .now,
            configuration: configuration
        )

        return Timeline(
            entries: [entry],
            policy: .after(.now.addingTimeInterval(60 * 60))
        )
    }
}

struct LatestRankupMediumEntry: TimelineEntry {
    let date: Date
    let configuration: LatestRankupMediumConfigurationIntent
}

struct LatestRankupMediumEntryView: View {
    var entry: LatestRankupMediumProvider.Entry

    var body: some View {
        let mode = entry.configuration.mode ?? .mascot

        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            let baseW: CGFloat = 364.0
            let baseH: CGFloat = 170.0
            let s = min(w / baseW, h / baseH)

            let layoutW = baseW * s
            let layoutH = baseH * s
            let originX = (w - layoutW) / 2.0
            let originY = (h - layoutH) / 2.0

            let rightGradientW = 239.0 * s
            let rightGradientCenterX = w - (rightGradientW / 2.0)
            let rightGradientCenterY = h / 2.0

            let chestPlateW = 112.0 * s
            let chestPlateH = 125.95 * s
            let chestPlateX = originX + ((mode == .mascot ? 53.0 : 33.23) * s)
            let chestPlateY = originY + ((mode == .mascot ? 4.0 : 22.02) * s)
            let chestPlateCenterX = chestPlateX + (chestPlateW / 2.0)
            let chestPlateCenterY = chestPlateY + (chestPlateH / 2.0)

            let glowW = 83.0 * s
            let glowH = 70.0 * s
            let glowX = originX + ((mode == .mascot ? 71.0 : 49.0) * s)
            let glowY = originY + ((mode == .mascot ? 3.0 : 16.0) * s)
            let glowCenterX = glowX + (glowW / 2.0)
            let glowCenterY = glowY + (glowH / 2.0)

            let jymboW = 210.0 * s

            let rightGroupW = 150.0 * s
            let rightGroupH = 141.0 * s
            let rightGroupX = originX + (200.0 * s)
            let rightGroupY = originY + (15.0 * s)
            let rightGroupCenterX = rightGroupX + (rightGroupW / 2.0)
            let rightGroupCenterY = rightGroupY + (rightGroupH / 2.0)

            let recentRankupsTitleH = 12.0 * s
            let recentRankupsFont = 10.0 * s

            let cards: [(imageName: String, title: String, levelText: String)] = [
                ("chest", "Upper Chest", "CHAMPION I"),
                ("chest", "Upper Chest", "CHAMPION I"),
                ("chest", "Upper Chest", "CHAMPION I")
            ]

            ZStack(alignment: .topLeading) {
                Image(mode == .mascot ? "mascotBg" : "bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: w, height: h)
                    .clipped()

                LinearGradient(
                    stops: [
                        .init(color: Color(hex: 0xD77CE6), location: 0.0),
                        .init(color: Color(hex: 0xFFE343).opacity(0.0), location: 1.0)
                    ],
                    startPoint: .trailing,
                    endPoint: .leading
                )
                .frame(width: rightGradientW, height: h)
                .position(x: rightGradientCenterX, y: rightGradientCenterY)
                .allowsHitTesting(false)

                Image("chestPlateChamp")
                    .resizable()
                    .scaledToFit()
                    .frame(width: chestPlateW, height: chestPlateH)
                    .position(x: chestPlateCenterX, y: chestPlateCenterY)
                    .allowsHitTesting(false)

                Ellipse()
                    .fill(Color(hex: 0xA8B2DA))
                    .frame(width: glowW, height: glowH)
                    .blur(radius: 40.0 * s)
                    .blendMode(.plusLighter)
                    .opacity(0.60)
                    .position(x: glowCenterX, y: glowCenterY)
                    .allowsHitTesting(false)

                if mode == .mascot {
                    Image("jymbo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: jymboW)
                        .frame(width: w, height: h, alignment: .bottomLeading)
                        .offset(x: 0, y: 0)
                        .allowsHitTesting(false)
                }

                VStack(spacing: 3.0 * s) {
                    Text("Recent Rankups")
                        .font(.custom("Figtree-SemiBold", size: recentRankupsFont))
                        .foregroundStyle(Color.black.opacity(0.80))
                        .frame( height: recentRankupsTitleH, alignment: .center)

                    ForEach(Array(cards.enumerated()), id: \.offset) { _, card in
                        latestRankupCard(
                            imageName: card.imageName,
                            title: card.title,
                            levelText: card.levelText,
                            strokeStartHex: 0xFDAEFF,
                            strokeEndHex: 0xBA55D3,
                            scale: s,
                            circleStrokeColor: 0xB969D1
                        )
                    }
                    if cards.count <= 1 {
                        unRankedCard(scale: s)
                    }
                }
                .frame(width: rightGroupW, height: rightGroupH)
                .position(x: rightGroupCenterX, y: rightGroupCenterY)
            }
            .frame(width: w, height: h)
        }
        .containerBackground(for: .widget) { Color.clear }
    }
}

private func verticalFillGradient(
    topHex: UInt32,
    bottomHex: UInt32
) -> LinearGradient {
    LinearGradient(
        stops: [
            .init(color: Color(hex: topHex), location: 0.0),
            .init(color: Color(hex: bottomHex), location: 1.0)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}

private func imageMaskingGradient(
    topHex: UInt32,
    bottomHex: UInt32
) -> LinearGradient {
    LinearGradient(
        stops: [
            .init(color: Color(hex: topHex), location: 0.5),
            .init(color: Color(hex: bottomHex), location: 0.7)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}

private func latestRankupCard(
    imageName: String,
    title: String,
    levelText: String,
    strokeStartHex: UInt32,
    strokeEndHex: UInt32,
    scale s: CGFloat,
    circleStrokeColor: UInt32
) -> some View {
    let cardW = 150.0 * s
    let cardH = 40.0 * s
    let circleD = 28.8 * s
    let circleStrokeW = 0.60 * s
    let corner = 8.0 * s
    let cardFill = Color(hex: 0x79367E)
    let cardStroke = verticalFillGradient(
        topHex: strokeStartHex,
        bottomHex: strokeEndHex
    )
    let levelColor = Color(hex: 0xE391FF)
    let titleColor = Color.white.opacity(0.80)
    let circleFill = Color(hex: 0x311D0A)

    return ZStack(alignment: .topLeading) {
        RoundedRectangle(cornerRadius: corner, style: .continuous)
            .fill(cardFill)

        RoundedRectangle(cornerRadius: corner, style: .continuous)
            .stroke(cardStroke, lineWidth: 1.0)

        HStack(alignment: .center, spacing: 6.0 * s) {
            ZStack {
                Circle()
                    .fill(circleFill)

                ZStack {
                    Image("bodyFront")
                        .resizable()
                        .scaledToFit()

                    Image("bodyFrontMuscle")
                        .resizable()
                        .scaledToFit()

                    imageMaskingGradient(
                        topHex: strokeStartHex,
                        bottomHex: strokeEndHex
                    )
                    .mask(
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                    )
                }
                .padding(circleStrokeW * 0.4)
            }
            .frame(width: circleD, height: circleD)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color(hex: circleStrokeColor), lineWidth: circleStrokeW)
            )

            VStack(alignment: .leading, spacing: -2.0 * s) {
                Text(title)
                    .font(.custom("Figtree-SemiBold", size: 10.0 * s))
                    .foregroundStyle(titleColor)
                    .lineLimit(1)

                Text(levelText)
                    .font(.custom("Figtree-SemiBold", size: 10.0 * s))
                    .foregroundStyle(levelColor)
                    .lineLimit(1)
            }
            .frame(alignment: .leading)

            Spacer(minLength: 0)
        }
        .padding(.leading, 10.0 * s)
        .padding(.top, 5.6 * s)
        .padding(.bottom, 5.6 * s)
        .padding(.trailing, 10.0 * s)
    }
    .frame(width: cardW, height: cardH)
}

private func unrankStrokeGradient() -> AngularGradient {
    AngularGradient(
        gradient: Gradient(stops: [
            .init(color: Color(hex: 0xFDCC1A), location: 0.00),
            .init(color: Color(hex: 0x8FFFE6), location: 0.25),
            .init(color: Color(hex: 0xB5C1F3), location: 0.38),
            .init(color: Color(hex: 0xDC82FF), location: 0.50),
            .init(color: Color(hex: 0xFE181F), location: 0.75),
            .init(color: Color(hex: 0xFDCC1A), location: 1.00)
        ]),
        center: .center,
        startAngle: .degrees(0),
        endAngle: .degrees(360)
    )
}

private func unRankedCard(
    scale s: CGFloat,
) -> some View {
    let cardW = 150.0 * s
    let cardH = 40.0 * s
    let circleD = 28.8 * s
    let circleStrokeW = 0.60 * s
    let corner = 8.0 * s
    let cardFill = Color(hex: 0x79367E)
    let cardStroke = unrankStrokeGradient()
    let titleColor = Color.white.opacity(0.80)
    let circleFill = Color(hex: 0x311D0A)

    return ZStack(alignment: .topLeading) {
        RoundedRectangle(cornerRadius: corner, style: .continuous)
            .fill(cardFill)

        RoundedRectangle(cornerRadius: corner, style: .continuous)
            .stroke(cardStroke, lineWidth: 1.0)

        HStack(alignment:.center, spacing: 0.0){
            HStack(alignment: .center, spacing: 6.0 * s) {
                ZStack {
                    Circle()
                        .fill(circleFill)
                    
                    ZStack {
                        Image("bodyFront")
                            .resizable()
                            .scaledToFit()
                        
                        Image("bodyFrontMuscle")
                            .resizable()
                            .scaledToFit()
                    }
                    .padding(circleStrokeW * 0.4)
                }
                .frame(width: circleD, height: circleD)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(unrankStrokeGradient(), lineWidth: circleStrokeW)
                )
                
                VStack(alignment: .leading, spacing: -2.0 * s) {
                    Text("Discover your")
                        .font(.custom("Figtree-SemiBold", size: 10.0 * s))
                        .foregroundStyle(titleColor)
                        .lineLimit(1)
                    Text("next rank?")
                        .font(.custom("Figtree-SemiBold", size: 10.0 * s))
                        .foregroundStyle(titleColor)
                        .lineLimit(1)
                }
                .frame(alignment: .leading)
            }.frame(minWidth: 96.0)
            
            Spacer(minLength: 0)
            Image("unranked")
                .resizable()
                .scaledToFit()
                .frame(width: 30.75 * s, height: 28.92 * s)
        }
        .padding(.leading, 10.0 * s)
        .padding(.top, 5.6 * s)
        .padding(.bottom, 5.6 * s)
        .padding(.trailing, 8.0 * s)
    }
    .frame(width: cardW, height: cardH)
    .opacity(0.70)
}

private extension Color {
    init(hex: UInt32) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

struct LatestRankupMedium: Widget {
    let kind: String = "LatestRankupMedium"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: LatestRankupMediumConfigurationIntent.self,
            provider: LatestRankupMediumProvider()
        ) { entry in
            LatestRankupMediumEntryView(entry: entry)
        }
        .supportedFamilies([.systemMedium])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemMedium) {
    LatestRankupMedium()
} timeline: {
    LatestRankupMediumEntry(date: .now, configuration: {
        var i = LatestRankupMediumConfigurationIntent()
        i.mode = .mascot
        return i
    }())

    LatestRankupMediumEntry(date: .now, configuration: {
        var i = LatestRankupMediumConfigurationIntent()
        i.mode = .minimal
        return i
    }())
}
