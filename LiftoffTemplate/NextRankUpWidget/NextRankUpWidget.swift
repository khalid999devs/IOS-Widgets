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

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: .now, configuration: NextRankUpConfigurationIntent())
    }

    func snapshot(for configuration: NextRankUpConfigurationIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: .now, configuration: configuration)
    }

    func timeline(for configuration: NextRankUpConfigurationIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let entry = SimpleEntry(date: .now, configuration: configuration)
        return Timeline(entries: [entry], policy: .after(.now.addingTimeInterval(60 * 60)))
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: NextRankUpConfigurationIntent
}

struct NextRankUpWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            let base: CGFloat = 170.0
            let s = min(w / base, h / base)

            let layoutW = base * s
            let layoutH = base * s
            let originX = (w - layoutW) / 2.0
            let originY = (h - layoutH) / 2.0

            let starsW = 125.0 * s
            let starsH = 100.0 * s
            let starsX = originX + (12.0 * s)
            let starsY = originY + (29.0 * s)

            let titleW = 111.0 * s
            let titleH = 14.0 * s
            let titleFont = 12.0 * s
            let titleTopY = originY + (16.0 * s)
            let titleCenterX = originX + (layoutW / 2.0)
            let titleCenterY = titleTopY + (titleH / 2.0)

            let iconW = 92.38 * s
            let iconH = 103.89 * s
            let iconX = originX + (38.62 * s)
            let iconY = originY + (38.38 * s)
            let iconCenterX = iconX + (iconW / 2.0)
            let iconCenterY = iconY + (iconH / 2.0)

            let jymboW = 133.0 * s
            let jymboH = 110.0 * s
            let jymboX = originX + (37.47 * s)
            let jymboY = originY + (61.84 * s)
            let jymboCenterX = jymboX + (jymboW / 2.0)
            let jymboCenterY = jymboY + (jymboH / 2.0)

            ZStack(alignment: .topLeading) {
                Image("champTitanBg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: w, height: h)
                    .clipped()

                Image("icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconW, height: iconH)
                    .position(x: iconCenterX, y: iconCenterY)

                Text("Rank up soon?")
                    .font(.custom("Figtree-SemiBold", size: titleFont))
                    .foregroundStyle(Color.white)
                    .opacity(0.80)
                    .lineLimit(1)
                    .frame(width: titleW, height: titleH, alignment: .center)
                    .position(x: titleCenterX, y: titleCenterY)

                Image("stars")
                    .resizable()
                    .scaledToFit()
                    .frame(width: starsW, height: starsH)
                    .offset(x: starsX, y: starsY)

                if (entry.configuration.mode ?? .mascot) == .mascot {
                    Image("jymbo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: jymboW, height: jymboH)
                        .position(x: jymboCenterX, y: jymboCenterY)
                        .allowsHitTesting(false)
                }
            }
            .frame(width: w, height: h)
        }
        .containerBackground(for: .widget) { Color.clear }
    }
}

struct NextRankUpWidget: Widget {
    let kind: String = "NextRankUpWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: NextRankUpConfigurationIntent.self, provider: Provider()) { entry in
            NextRankUpWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    NextRankUpWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: {
        var i = NextRankUpConfigurationIntent()
        i.mode = .mascot
        return i
    }())

    SimpleEntry(date: .now, configuration: {
        var i = NextRankUpConfigurationIntent()
        i.mode = .minimal
        return i
    }())
}
