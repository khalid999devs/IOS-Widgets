import WidgetKit
import SwiftUI
import AppIntents

enum WidgetMode: String, AppEnum {
    case minimal
    case mascot

    static var typeDisplayRepresentation: TypeDisplayRepresentation { "aMode" }

    static var caseDisplayRepresentations: [WidgetMode: DisplayRepresentation] {
        [
            .minimal: "Minimal",
            .mascot: "Mascot"
        ]
    }
}

struct BestRankConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Best Rank"
    static var description = IntentDescription("Choose a widget mode")

    @Parameter(title: "Mode")
    var mode: WidgetMode?
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: .now, configuration: BestRankConfigurationIntent())
    }

    func snapshot(for configuration: BestRankConfigurationIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: .now, configuration: configuration)
    }

    func timeline(for configuration: BestRankConfigurationIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let entry = SimpleEntry(date: .now, configuration: configuration)
        return Timeline(entries: [entry], policy: .after(.now.addingTimeInterval(60 * 60)))
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: BestRankConfigurationIntent
}

enum MascotBodyPart: String {
    case legs = "Legs"
    case arms = "Arms"
    case back = "Back"
    case core = "Core"
    case chest = "Chest"
    case shoulders = "Shoulders"
    
    var title: String {
         switch self {
         case .legs:
             return "Leg"
         case .arms:
             return "Arm"
         case .shoulders:
             return "Shoulder"
         default:
             return rawValue
         }
     }

    var assetName: String {
        "jymbo/\(rawValue)"
    }

    var config: MascotBodyPartConfig {
        switch self {
        case .legs:
            return .init(width: 110.16, height: 115.3, rightInset: 0.0, topY: 38.0)
        case .arms:
            return .init(width: 96.0, height: 94.0, rightInset: 0.0, topY: 60.0)
        case .back:
            return .init(width: 128.0, height: 170.0, rightInset: -2.0, topY: 0.0)
        case .core:
            return .init(width: 284, height: 170, rightInset: -80.0, topY: 0.0)
        case .chest:
            return .init(width: 268.0, height: 170.0, rightInset: -78.0, topY: 0.0)
        case .shoulders:
            return .init(width: 124.0, height: 170.0, rightInset: -2.0, topY: 0.0)
        }
    }
}

struct MascotBodyPartConfig {
    let width: CGFloat
    let height: CGFloat
    let rightInset: CGFloat
    let topY: CGFloat
}

struct MascotBodyPartView: View {
    let part: MascotBodyPart
    let scale: CGFloat
    let originY: CGFloat
    let widgetWidth: CGFloat

    var body: some View {
        let config = part.config
        let partW = config.width * scale
        let partH = config.height * scale
        let centerX = widgetWidth - (config.rightInset * scale) - (partW / 2.0)
        let topY = originY + (config.topY * scale)
        let centerY = topY + (partH / 2.0)

        Image(part.assetName)
            .resizable()
            .scaledToFit()
            .frame(width: partW)
            .position(x: centerX, y: centerY)
            .allowsHitTesting(false)
    }
}

struct BestRankWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        let mode = entry.configuration.mode ?? .mascot
        let mascotPart: MascotBodyPart = .legs

        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            let base: CGFloat = 170.0
            let s = min(w / base, h / base)

            let layoutW = base * s
            let layoutH = base * s
            let originX = (w - layoutW) / 2.0
            let originY = (h - layoutH) / 2.0

            let rankW = 93.62 * s
            let rankH = 105.28 * s
            let rankX = originX + ((mode == .mascot ? 16.0 : 38.19) * s)
            let rankY = originY + (16.0 * s)
            let rankCenterX = rankX + (rankW / 2.0)
            let rankCenterY = rankY + (rankH / 2.0)

            let starW = 124.0 * s
            let starX = originX + (8.0 * s)
            let starY = originY + (6.0 * s)
            let starCenterX = starX + ((starW * 1.0) / 2.0)
            let starCenterY = starY + ((126.0 * s) / 2.0)

            let minStarW = 128.0 * s
            let minStarX = originX + (14.0 * s)
            let minStarY = originY + (16.0 * s)
            let minStarCenterX = minStarX + (minStarW / 2.0)
            let minStarCenterY = minStarY + ((124.0 * s) / 2.0)

            let lightW = 94.79 * s
            let lightH = 79.94 * s
            let lightX = originX + (-9.0 * s)
            let lightY = originY + (-19.0 * s)
            let lightCenterX = lightX + (lightW / 2.0)
            let lightCenterY = lightY + (lightH / 2.0)
            let lightRotation = 28.74
            let lightBlur = 50.0 * s

            let textX = originX + (16.0 * s)
            let textY = originY + (130.0 * s)
            let textW = 100.0 * s
            let textH = 24.0 * s
            let textFont = 10.0 * s
            let lineSpacing = 0.0 * s

            let minTextY = originY + (124.0 * s)
            let minTextW = 138.0 * s
            let minTextH = 30.0 * s
            let minBoldTextFont = 14.0 * s
            let minLineSpacing = 2.0 * s

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

                Ellipse()
                    .fill(Color(hex: 0x83A2C0))
                    .frame(width: lightW, height: lightH)
                    .rotationEffect(.degrees(lightRotation))
                    .blur(radius: lightBlur)
                    .blendMode(.plusLighter)
                    .opacity(0.70)
                    .position(x: lightCenterX, y: lightCenterY)
                    .allowsHitTesting(false)

                if mode == .mascot {
                    MascotBodyPartView(
                        part: mascotPart,
                        scale: s,
                        originY: originY,
                        widgetWidth: w
                    )

                    Image("star")
                        .resizable()
                        .scaledToFit()
                        .frame(width: starW)
                        .position(x: starCenterX, y: starCenterY)
                        .allowsHitTesting(false)

                    VStack(alignment: .leading, spacing: lineSpacing) {
                        Text("Been hitting")
                            .font(.custom("Figtree-Medium", size: textFont))
                            .foregroundStyle(Color.white)
                            .lineLimit(1)

                        HStack(spacing: 0) {
                            Text("those ")
                                .font(.custom("Figtree-Medium", size: textFont))
                                .foregroundStyle(Color.white)
                                .lineLimit(1)

                            Text(mascotPart.title)
                                .font(.custom("Figtree-Bold", size: textFont))
                                .foregroundStyle(Color.white)
                                .lineLimit(1)

                            Text(" days")
                                .font(.custom("Figtree-Medium", size: textFont))
                                .foregroundStyle(Color.white)
                                .lineLimit(1)
                        }
                    }
                    .frame(width: textW, height: textH, alignment: .topLeading)
                    .position(x: textX + (textW / 2.0), y: textY + (textH / 2.0))
                    .opacity(0.80)

                } else {
                    Image("starMM")
                        .resizable()
                        .scaledToFit()
                        .frame(width: minStarW)
                        .position(x: minStarCenterX, y: minStarCenterY)
                        .allowsHitTesting(false)

                    VStack(alignment: .leading, spacing: minLineSpacing) {
                        Text("Legs")
                            .font(.custom("Figtree-Bold", size: minBoldTextFont))
                            .foregroundStyle(Color.white)
                            .lineLimit(1)

                        Text("Best Muscle Group")
                            .font(.custom("Figtree-Medium", size: textFont))
                            .foregroundStyle(Color.white)
                            .lineLimit(1)
                    }
                    .frame(width: minTextW, height: minTextH, alignment: .topLeading)
                    .position(x: textX + (minTextW / 2.0), y: minTextY + (minTextH / 2.0))
                    .opacity(0.80)
                }
            }
            .frame(width: w, height: h)
        }
        .containerBackground(for: .widget) { Color.clear }
    }
}

struct BestRankWidget: Widget {
    let kind: String = "BestRankWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: BestRankConfigurationIntent.self, provider: Provider()) { entry in
            BestRankWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
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

#Preview(as: .systemSmall) {
    BestRankWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: {
        var i = BestRankConfigurationIntent()
        i.mode = .mascot
        return i
    }())

    SimpleEntry(date: .now, configuration: {
        var i = BestRankConfigurationIntent()
        i.mode = .minimal
        return i
    }())
}
