import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: .now, configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: .now, configuration: configuration)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let entry = SimpleEntry(date: .now, configuration: configuration)
        return Timeline(entries: [entry], policy: .after(.now.addingTimeInterval(60 * 60)))
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct NextRankUpWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            let baseW: CGFloat = 170.0
            let baseH: CGFloat = 170.0

            let s = min(w / baseW, h / baseH)
            let layoutW = baseW * s
            let layoutH = baseH * s
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

            ZStack(alignment: .topLeading) {
                Image("champTitanBg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: w, height: h)
                    .clipped()

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
            }
            .frame(width: w, height: h)
        }
        .containerBackground(for: .widget) { Color.clear }
    }
}

struct NextRankUpWidget: Widget {
    let kind: String = "NextRankUpWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            NextRankUpWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    NextRankUpWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: ConfigurationAppIntent())
}
