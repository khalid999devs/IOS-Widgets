import WidgetKit
import SwiftUI
import AppIntents

enum LatestRankupMode: String, AppEnum {
    case minimal
    case mascot

    static var typeDisplayRepresentation: TypeDisplayRepresentation { "Mode" }

    static var caseDisplayRepresentations: [LatestRankupMode: DisplayRepresentation] {
        [
            .minimal: "Minimal",
            .mascot: "Mascot"
        ]
    }
}

struct LatestRankupConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Latest Rankup"
    static var description = IntentDescription("Choose a widget mode")

    @Parameter(title: "Mode")
    var mode: LatestRankupMode?
}

struct LatestRankupProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> LatestRankupEntry {
        LatestRankupEntry(
            date: .now,
            configuration: LatestRankupConfigurationIntent()
        )
    }

    func snapshot(
        for configuration: LatestRankupConfigurationIntent,
        in context: Context
    ) async -> LatestRankupEntry {
        LatestRankupEntry(
            date: .now,
            configuration: configuration
        )
    }

    func timeline(
        for configuration: LatestRankupConfigurationIntent,
        in context: Context
    ) async -> Timeline<LatestRankupEntry> {
        let entry = LatestRankupEntry(
            date: .now,
            configuration: configuration
        )

        return Timeline(
            entries: [entry],
            policy: .after(.now.addingTimeInterval(60 * 60))
        )
    }
}

struct LatestRankupEntry: TimelineEntry {
    let date: Date
    let configuration: LatestRankupConfigurationIntent
}

struct LatestRankupEntryView: View {
    var entry: LatestRankupProvider.Entry

    var body: some View {
        let mode = entry.configuration.mode ?? .mascot

        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            let base: CGFloat = 170.0
            let s = min(w / base, h / base)

            let layoutW = base * s
            let layoutH = base * s
            let originX = (w - layoutW) / 2.0
            let originY = (h - layoutH) / 2.0

            let bottomShadeH = 108.0 * s

            let iconD = (mode == .mascot ? 98.0 : 111.15) * s
            let iconX = originX + ((mode == .mascot ? 9.5 : 29.43) * s)
            let iconY = originY + ((mode == .mascot ? 10.0 : 20.85) * s)
            let iconCenterX = iconX + (iconD / 2.0)
            let iconCenterY = iconY + (iconD / 2.0)
            let ringW = (mode == .mascot ? 2.0 : 2.15) * s
            let borderColor = Color(hex: 0xD3A313)

            let highlightW = (mode == .mascot ? 83.0 : 94.13) * s
            let highlightH = (mode == .mascot ? 70.0 : 79.39) * s
            let highlightX = iconX + ((mode == .mascot ? 1.0 : 22.04) * s)
            let highlightY = iconY + ((mode == .mascot ? -11.0 : -2.45) * s)
            let highlightCenterX = highlightX + (highlightW / 2.0)
            let highlightCenterY = highlightY + (highlightH / 2.0)
            let highlightRotation = 28.74
            let highlightBlur = (mode == .mascot ? 40.0 : 48.0) * s
            let highlightOpacity = mode == .mascot ? 0.60 : 0.50

            let minimalHighlight2W = 57.76 * s
            let minimalHighlight2H = 100.39 * s
            let minimalHighlight2X = originX + (50.93 * s)
            let minimalHighlight2Y = originY + (-8.0 * s)
            let minimalHighlight2CenterX = minimalHighlight2X + (minimalHighlight2W / 2.0)
            let minimalHighlight2CenterY = minimalHighlight2Y + (minimalHighlight2H / 2.0)
            let minimalHighlight2Rotation = 54.01
            let minimalHighlight2Blur = 52.0 * s
            let minimalHighlight2Opacity = 0.50

            let upperIconW = 41.0 * s
            let upperIconH = 64.42 * s
            let upperIconX = originX + (7.0 * s)
            let upperIconY = originY + (63.0 * s)
            let upperIconCenterX = upperIconX + (upperIconW / 2.0)
            let upperIconCenterY = upperIconY + (upperIconH / 2.0)

            ZStack(alignment: .topLeading) {
                Image(mode == .mascot ? "mascotBg" : "bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: w, height: h)
                    .clipped()

                LinearGradient(
                    stops: [
                        .init(color: Color(hex: 0xF8AF4D).opacity(0.0), location: 0.0),
                        .init(color: Color(hex: 0xD88E25), location: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: w, height: bottomShadeH)
                .frame(width: w, height: h, alignment: .bottom)
                .allowsHitTesting(false)

                ZStack {
                    Circle()
                        .fill(Color(hex: 0x151026))

                    ZStack {
                        Image("bodyFront")
                            .resizable()
                            .scaledToFit()

                        Image("bodyFrontMuscle")
                            .resizable()
                            .scaledToFit()

                        LinearGradient(
                            stops: [
                                .init(color: Color(hex: 0xFFE37E), location: 0.0),
                                .init(color: Color(hex: 0xE6AE08), location: 1.0)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .mask(
                            Image("chest")
                                .resizable()
                                .scaledToFit()
                        )
                    }
                    .padding(ringW * 0.4)
                }
                .frame(width: iconD, height: iconD)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(borderColor, lineWidth: ringW)
                )
                .position(x: iconCenterX, y: iconCenterY)

                Ellipse()
                    .fill(Color(hex: 0xF8C829))
                    .frame(width: highlightW, height: highlightH)
                    .rotationEffect(.degrees(highlightRotation))
                    .blur(radius: highlightBlur)
                    .blendMode(.plusLighter)
                    .opacity(highlightOpacity)
                    .position(x: highlightCenterX, y: highlightCenterY)
                    .allowsHitTesting(false)

                if mode == .minimal {
                    Ellipse()
                        .fill(Color(hex: 0xB98E00))
                        .frame(width: minimalHighlight2W, height: minimalHighlight2H)
                        .rotationEffect(.degrees(minimalHighlight2Rotation))
                        .blur(radius: minimalHighlight2Blur)
                        .blendMode(.plusLighter)
                        .opacity(minimalHighlight2Opacity)
                        .position(x: minimalHighlight2CenterX, y: minimalHighlight2CenterY)
                        .allowsHitTesting(false)

                    Image("upperIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: upperIconW, height: upperIconH)
                        .position(x: upperIconCenterX, y: upperIconCenterY)
                        .allowsHitTesting(false)
                    
                    Text("Check out those gains")
                        .font(.custom("Figtree-SemiBold", size: 10.0 * s))
                        .foregroundStyle(Color.black.opacity(0.80))
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
                        .frame( height: 12.0 * s)
                        .position(x: w / 2.0, y: originY + (142.0 * s) + ((12.0 * s) / 2.0))
                }else{
                    Text("Check out those gains")
                        .font(.custom("Figtree-SemiBold", size: 10.0 * s))
                        .foregroundStyle(Color.black.opacity(0.80))
                        .multilineTextAlignment(.trailing)
                        .frame(width: 32.0 * s)
                        .position(x: originX + (122.0 * s) + ((32.0 * s) / 2.0), y: originY + (16.0 * s) + ((52.0 * s) / 2.0))
                    
                    Image("jymbo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 170.0 * s)
                        .frame(width: w, height: h, alignment: .bottomTrailing)
                        .offset(x: -0.0, y: -0.0)
                        .allowsHitTesting(false)
                }
            }
            .frame(width: w, height: h)
        }
        .containerBackground(for: .widget) { Color.clear }
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

struct LatestRankup: Widget {
    let kind: String = "LatestRankup"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: LatestRankupConfigurationIntent.self,
            provider: LatestRankupProvider()
        ) { entry in
            LatestRankupEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    LatestRankup()
} timeline: {
    LatestRankupEntry(date: .now, configuration: {
        var i = LatestRankupConfigurationIntent()
        i.mode = .mascot
        return i
    }())

    LatestRankupEntry(date: .now, configuration: {
        var i = LatestRankupConfigurationIntent()
        i.mode = .minimal
        return i
    }())
}
