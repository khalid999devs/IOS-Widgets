import WidgetKit
import SwiftUI
import AppIntents

enum BestRankMediumMode: String, AppEnum {
    case minimal
    case mascot

    static var typeDisplayRepresentation: TypeDisplayRepresentation { "Mode" }

    static var caseDisplayRepresentations: [BestRankMediumMode: DisplayRepresentation] {
        [
            .minimal: "Minimal",
            .mascot: "Mascot"
        ]
    }
}

struct BestRankWidgetMediumConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Best Rank Medium"
    static var description = IntentDescription("Choose a widget mode")

    @Parameter(title: "Mode")
    var mode: BestRankMediumMode?
}

struct BestRankWidgetMediumProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> BestRankWidgetMediumEntry {
        BestRankWidgetMediumEntry(
            date: .now,
            configuration: BestRankWidgetMediumConfigurationIntent()
        )
    }

    func snapshot(
        for configuration: BestRankWidgetMediumConfigurationIntent,
        in context: Context
    ) async -> BestRankWidgetMediumEntry {
        BestRankWidgetMediumEntry(
            date: .now,
            configuration: configuration
        )
    }

    func timeline(
        for configuration: BestRankWidgetMediumConfigurationIntent,
        in context: Context
    ) async -> Timeline<BestRankWidgetMediumEntry> {
        let entry = BestRankWidgetMediumEntry(
            date: .now,
            configuration: configuration
        )

        return Timeline(
            entries: [entry],
            policy: .after(.now.addingTimeInterval(60 * 60))
        )
    }
}

struct BestRankWidgetMediumEntry: TimelineEntry {
    let date: Date
    let configuration: BestRankWidgetMediumConfigurationIntent
}

struct BestRankWidgetMediumEntryView: View {
    var entry: BestRankWidgetMediumProvider.Entry

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

            let rankW = 93.62 * s
            let rankH = 105.28 * s
            let rankX = originX + (51.0 * s)
            let rankY = originY + (36.33 * s)
            let rankCenterX = rankX + (rankW / 2.0)
            let rankCenterY = rankY + (rankH / 2.0)

            let hindlegH = 102.0 * s
            let hindlegY = originY + (68.0 * s)

            let starW = 36.0 * s
            let starH = 40.0 * s
            let starX = originX + (130.0 * s)
            let starY = originY + (28.33 * s)
            let starCenterX = starX + (starW / 2.0)
            let starCenterY = starY + (starH / 2.0)

            let lightW = 94.79 * s
            let lightH = 79.94 * s
            let lightX = originX + (8.0 * s)
            let lightY = originY + (10.0 * s)
            let lightCenterX = lightX + (lightW / 2.0)
            let lightCenterY = lightY + (lightH / 2.0)
            let lightRotation = 28.74

            let textX = originX + (16.0 * s)
            let textY = originY + (16.0 * s)
            let textW = 157.0 * s
            let textH = 30.0 * s
            let boldTextFont = 14.0 * s
            let textFont = 10.0 * s
            let lineSpacing = 0.0 * s

            let rightGroupW = 150.0 * s
            let rightGroupH = 130.0 * s
            let rightGroupX = originX + (176.0 * s)
            let rightGroupY = originY + (20.0 * s)
            let rightGroupCenterX = rightGroupX + (rightGroupW / 2.0)
            let rightGroupCenterY = rightGroupY + (rightGroupH / 2.0)

            let cards: [(imageName: String, title: String, levelText: String)] = [
                ("hip", "Calves", "GOLD III"),
                ("hip", "Quadriceps", "GOLD II"),
                ("hip", "Abductors", "GOLD II")
            ]

            ZStack(alignment: .topLeading) {
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: w, height: h)
                    .clipped()

                Image("rank")
                    .resizable()
                    .scaledToFit()
                    .frame(width: rankW, height: rankH)
                    .position(x: rankCenterX, y: rankCenterY)

                Image("star")
                    .resizable()
                    .scaledToFit()
                    .frame(width: starW, height: starH)
                    .position(x: starCenterX, y: starCenterY)
                    .allowsHitTesting(false)

                Ellipse()
                    .fill(Color(hex: 0x83A2C0))
                    .frame(width: lightW, height: lightH)
                    .rotationEffect(.degrees(lightRotation))
                    .blur(radius: 40.0 * s)
                    .blendMode(.plusLighter)
                    .opacity(0.60)
                    .position(x: lightCenterX, y: lightCenterY)
                    .allowsHitTesting(false)

                VStack(alignment: .leading, spacing: lineSpacing) {
                    Text("Best Muscle Group")
                        .font(.custom("Figtree-Medium", size: textFont))
                        .foregroundStyle(Color.white)
                        .opacity(0.80)
                        .lineLimit(1)

                    Text("Legs")
                        .font(.custom("Figtree-Bold", size: boldTextFont))
                        .foregroundStyle(Color.white)
                        .lineLimit(1)
                }
                .frame(width: textW, height: textH, alignment: .topLeading)
                .position(x: textX + (textW / 2.0), y: textY + (textH / 2.0))
                
                if mode == .mascot {
                    Image("hindleg")
                        .resizable()
                        .scaledToFit()
                        .frame(height: hindlegH)
                        .frame(width: w, height: h, alignment: .topLeading)
                        .offset(x: 0, y: hindlegY)
                        .allowsHitTesting(false)
                }

                VStack(spacing: 5.0 * s) {
                    ForEach(Array(cards.enumerated()), id: \.offset) { _, card in
                        rankCard(
                            imageName: card.imageName,
                            title: card.title,
                            levelText: card.levelText,
                            badgeImageName: "goldRank",
                            scale: s
                        )
                    }

                    if cards.count <= 1 {
                        unRankCard(scale: s)

                        Text("Discover your next rank?")
                            .font(.custom("Figtree-SemiBold", size: 10.0 * s))
                            .foregroundStyle(Color.white.opacity(0.80))
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                            .frame(height: 9.0 * s, alignment: .center)
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

private func rankCard(
    imageName: String,
    title: String,
    levelText: String,
    badgeImageName: String,
    scale s: CGFloat
) -> some View {
    let cardW = 150.0 * s
    let cardH = 40.0 * s
    let circleD = 28.8 * s
    let ringW = 0.6 * s
    let corner = 8.0 * s
    let glowColor = Color(hex: 0xD3A313)

    return ZStack(alignment: .topLeading) {
        ZStack {
            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .fill(glowColor)
                .blur(radius: 4.0 * s)
                .opacity(0.6)

            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .fill(Color.black)
                .blendMode(.destinationOut)
        }
        .compositingGroup()

        RoundedRectangle(cornerRadius: corner, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        Color(hex: 0x040028),
                        Color(hex: 0x274690).opacity(0.50)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )

        RoundedRectangle(cornerRadius: corner, style: .continuous)
            .stroke(glowColor, lineWidth: 1.0 * s)

        HStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 6.0 * s) {
                ZStack {
                    Circle()
                        .fill(Color(hex: 0x0F0A18))

                    ZStack {
                        Image("lowerFrontBg")
                            .resizable()
                            .scaledToFit()

                        Image("lowerFront")
                            .resizable()
                            .scaledToFit()

                        ZStack {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .opacity(0)

                            LinearGradient(
                                stops: [
                                    .init(color: Color(hex: 0xFFE37E), location: 0.2),
                                    .init(color: Color(hex: 0xE6AE08), location: 0.7)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .mask(
                                Image(imageName)
                                    .resizable()
                                    .scaledToFit()
                            )
                        }
                    }
                    .padding(ringW * 0.4)
                }
                .frame(width: circleD, height: circleD)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(glowColor, lineWidth: ringW)
                )

                VStack(alignment: .leading, spacing: 0) {
                    Text(title)
                        .font(.custom("Figtree-SemiBold", size: 10.0 * s))
                        .foregroundStyle(Color.white)
                        .opacity(0.80)
                        .lineLimit(1)

                    Text(levelText)
                        .font(.custom("Figtree-SemiBold", size: 10.0 * s))
                        .foregroundStyle(glowColor)
                        .lineLimit(1)
                }
                .frame(height: 24.0 * s, alignment: .leading)
            }
            .frame(height: 28.8 * s, alignment: .leading)

            Spacer(minLength: 0)

            Image(badgeImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 30.75 * s, height: 28.92 * s)
        }
        .padding(.leading, 10.0 * s)
        .padding(.trailing, 10.0 * s)
        .padding(.top, 5.6 * s)
        .padding(.bottom, 5.6 * s)
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

private func unRankCard(
    scale s: CGFloat
) -> some View {
    let cardW = 150.0 * s
    let cardH = 40.0 * s
    let circleD = 28.8 * s
    let circleStrokeW = 0.60 * s
    let cardStrokeW = 1.0 * s
    let corner = 8.0 * s
    let glowColor = Color(hex: 0xDC82FF)
    let strokeGradient = unrankStrokeGradient()

    return ZStack(alignment: .topLeading) {
        ZStack {
            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .fill(glowColor)
                .blur(radius: 4.0 * s)
                .opacity(0.6)

            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .fill(Color.black)
                .blendMode(.destinationOut)
        }
        .compositingGroup()

        RoundedRectangle(cornerRadius: corner, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        Color(hex: 0x040028),
                        Color(hex: 0x274690).opacity(0.50)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )

        RoundedRectangle(cornerRadius: corner, style: .continuous)
            .stroke(strokeGradient, lineWidth: cardStrokeW)

        HStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 6.0 * s) {
                ZStack {
                    Circle()
                        .fill(Color(hex: 0x0F0A18))

                    ZStack {
                        Image("lowerFrontBg")
                            .resizable()
                            .scaledToFit()

                        Image("lowerFront")
                            .resizable()
                            .scaledToFit()
                    }
                    .padding(circleStrokeW * 0.4)
                }
                .frame(width: circleD, height: circleD)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(strokeGradient, lineWidth: circleStrokeW)
                )

                VStack(alignment: .leading, spacing: 0) {
                    Text("???")
                        .font(.custom("Figtree-SemiBold", size: 10.0 * s))
                        .foregroundStyle(Color.white)
                        .opacity(0.80)
                        .lineLimit(1)
                }
                .frame(height: 24.0 * s, alignment: .leading)
            }
            .frame(height: 28.8 * s, alignment: .leading)

            Spacer(minLength: 0)

            Image("unranked")
                .resizable()
                .scaledToFit()
                .frame(width: 30.75 * s, height: 28.92 * s)
        }
        .padding(.leading, 10.0 * s)
        .padding(.trailing, 10.0 * s)
        .padding(.top, 5.6 * s)
        .padding(.bottom, 5.6 * s)
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

struct BestRankWidgetMedium: Widget {
    let kind: String = "BestRankWidgetMedium"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: BestRankWidgetMediumConfigurationIntent.self,
            provider: BestRankWidgetMediumProvider()
        ) { entry in
            BestRankWidgetMediumEntryView(entry: entry)
        }
        .supportedFamilies([.systemMedium])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemMedium) {
    BestRankWidgetMedium()
} timeline: {
    BestRankWidgetMediumEntry(date: .now, configuration: {
        var i = BestRankWidgetMediumConfigurationIntent()
        i.mode = .mascot
        return i
    }())

    BestRankWidgetMediumEntry(date: .now, configuration: {
        var i = BestRankWidgetMediumConfigurationIntent()
        i.mode = .minimal
        return i
    }())
}
