import WidgetKit
import SwiftUI
import AppIntents

enum WidgetMode: String, AppEnum {
    case minimal
    case mascot

    static var typeDisplayRepresentation: TypeDisplayRepresentation { "Mode" }

    static var caseDisplayRepresentations: [WidgetMode: DisplayRepresentation] {
        [
            .minimal: "Minimal",
            .mascot: "Mascot"
        ]
    }
}

struct NextRankUpConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Next Rank Up"
    static var description = IntentDescription("Widget mode")

    @Parameter(title: "Mode")
    var mode: WidgetMode?
}

struct MediumProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> MediumEntry {
        MediumEntry(date: .now, configuration: NextRankUpConfigurationIntent())
    }

    func snapshot(for configuration: NextRankUpConfigurationIntent, in context: Context) async -> MediumEntry {
        MediumEntry(date: .now, configuration: configuration)
    }

    func timeline(for configuration: NextRankUpConfigurationIntent, in context: Context) async -> Timeline<MediumEntry> {
        let entry = MediumEntry(date: .now, configuration: configuration)
        return Timeline(entries: [entry], policy: .after(.now.addingTimeInterval(60 * 60)))
    }
}

struct MediumEntry: TimelineEntry {
    let date: Date
    let configuration: NextRankUpConfigurationIntent
}

struct NextRankUpWidgetMediumEntryView: View {
    var entry: MediumProvider.Entry

    var body: some View {
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

            let iconW = 92.38 * s
            let iconH = 103.89 * s
            let iconX = originX + (50.62 * s)
            let iconY = originY + (27.0 * s)
            let iconCenterX = iconX + (iconW / 2.0)
            let iconCenterY = iconY + (iconH / 2.0)

            let starsW = 130.0 * s
            let starsX = originX + (36.0 * s)
            let starsY = originY + (28.0 * s)

            let jymboH = 112.0 * s
            let jymboX = originX + (0.0 * s)
            let jymboY = originY + (60.0 * s)

            let rightW = 177.6 * s
            let rightX = originX + (170.4 * s)
            let rightY = originY + (46.5 * s)

            let topLineFont = 14.0 * s

            let goldLineY = 17.0 * s
            let goldLineH = 24.0 * s
            let goldFont = 28.8 * s

            let progressX = 2.82 * s
            let progressY = 41.0 * s
            let progressW = 171.97 * s
            let progressH = 36.0 * s

            let badgeW = 34.97 * s
            let badgeH = 30.02 * s
            let badgeRightX = 137.0 * s

            let barX = 35.0 * s
            let barY = 10.0 * s
            let barW = 101.0 * s
            let barH = 13.0 * s
            let barFillW = 92.0 * s
            let barCorner = 10.0 * s

            let coreX = 75.0 * s
            let coreY = 24.0 * s
            let coreFont = 10.0 * s

            ZStack(alignment: .topLeading) {
                Image("silverGoldBg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: w, height: h)
                    .clipped()

                Image("icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconW, height: iconH)
                    .position(x: iconCenterX, y: iconCenterY)

                Image("stars")
                    .resizable()
                    .scaledToFit()
                    .frame(width: starsW)
                    .offset(x: starsX, y: starsY)

                if (entry.configuration.mode ?? .mascot) == .mascot {
                    Image("jymbo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: jymboH)
                        .offset(x: jymboX, y: jymboY)
                        .allowsHitTesting(false)
                }

                ZStack(alignment: .topLeading) {
                    Text("2 reps until")
                        .font(.custom("Figtree-SemiBold", size: topLineFont))
                        .foregroundStyle(Color.white)
                        .opacity(0.80)
                        .lineLimit(1)
                        .frame(width: rightW, alignment: .center)

                    Text("GOLD")
                        .font(.custom("Figtree-Bold", size: goldFont))
                        .foregroundStyle(
                            LinearGradient(
                                stops: [
                                    .init(color: Color(hex: 0xFFE37E), location: 0.0),
                                    .init(color: Color(hex: 0xE6AE08), location: 1.0)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .lineLimit(1)
                        .frame(width: rightW, height: goldLineH, alignment: .center)
                        .offset(x: 0, y: goldLineY)

                    ZStack(alignment: .topLeading) {
                        Image("silver")
                            .resizable()
                            .scaledToFit()
                            .frame(width: badgeW, height: badgeH)

                        Image("gold")
                            .resizable()
                            .scaledToFit()
                            .frame(width: badgeW, height: badgeH)
                            .offset(x: badgeRightX, y: 0)

                        RoundedRectangle(cornerRadius: barCorner, style: .continuous)
                            .fill(Color(hex: 0xD9D9D9).opacity(0.40))
                            .frame(width: barW, height: barH)
                            .offset(x: barX, y: barY)

                        RoundedRectangle(cornerRadius: barCorner, style: .continuous)
                            .fill(
                                LinearGradient(
                                    stops: [
                                        .init(color: Color(hex: 0xD3A313), location: 0.0),
                                        .init(color: Color(hex: 0xAEBEC2), location: 0.75)
                                    ],
                                    startPoint: .trailing,
                                    endPoint: .leading
                                )
                            )
                            .frame(width: barFillW, height: barH)
                            .offset(x: barX, y: barY)

                        RoundedRectangle(cornerRadius: barCorner, style: .continuous)
                            .fill(Color(hex: 0xD3A313))
                            .frame(width: 25.0 * s, height: 17.0 * s)
                            .blur(radius: 7.3 * s)
                            .offset(x: barX + barFillW - (20.0 * s), y: barY-2.0 * s)

                        Text("Core")
                            .font(.custom("Figtree-Medium", size: coreFont))
                            .foregroundStyle(Color.white)
                            .opacity(0.80)
                            .lineLimit(1)
                            .offset(x: coreX, y: coreY)
                    }
                    .frame(width: progressW, height: progressH, alignment: .topLeading)
                    .offset(x: progressX, y: progressY)
                }
                .frame(width: rightW, alignment: .topLeading)
                .offset(x: rightX, y: rightY)
            }
            .frame(width: w, height: h)
        }
        .containerBackground(for: .widget) { Color.clear }
    }
}

struct NextRankUpWidgetMedium: Widget {
    let kind: String = "NextRankUpWidgetMedium"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: NextRankUpConfigurationIntent.self, provider: MediumProvider()) { entry in
            NextRankUpWidgetMediumEntryView(entry: entry)
        }
        .supportedFamilies([.systemMedium])
        .contentMarginsDisabled()
    }
}

private extension Color {
    init(hex: UInt32) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

#Preview(as: .systemMedium) {
    NextRankUpWidgetMedium()
} timeline: {
    MediumEntry(date: .now, configuration: {
        var i = NextRankUpConfigurationIntent()
        i.mode = .mascot
        return i
    }())

    MediumEntry(date: .now, configuration: {
        var i = NextRankUpConfigurationIntent()
        i.mode = .minimal
        return i
    }())
}

