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

            ZStack(alignment: .topLeading) {
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: w, height: h)
                    .clipped()

                if mode == .mascot {
                    EmptyView()
                }
            }
            .frame(width: w, height: h)
        }
        .containerBackground(for: .widget) { Color.clear }
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
