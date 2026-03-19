import WidgetKit
import SwiftUI

struct BodyGraphWidget1Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> BodyGraphWidget1Entry {
        BodyGraphWidget1Entry(date: .now, configuration: ConfigurationAppIntent())
    }

    func snapshot(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> BodyGraphWidget1Entry {
        BodyGraphWidget1Entry(date: .now, configuration: configuration)
    }

    func timeline(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> Timeline<BodyGraphWidget1Entry> {
        let entry = BodyGraphWidget1Entry(date: .now, configuration: configuration)
        return Timeline(
            entries: [entry],
            policy: .after(.now.addingTimeInterval(60 * 60))
        )
    }
}

struct BodyGraphWidget1Entry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct BodyGraphWidget1EntryView: View {
    var entry: BodyGraphWidget1Provider.Entry

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

            let rankGroupX = originX + (12.0 * s)
            let rankGroupY = originY + (16.0 * s)
            let rankGroupW = 190.0 * s
            let rankGroupH = 60.0 * s

            let statsGroupX = originX + (16.0 * s)
            let statsGroupY = originY + (76.0 * s)
            let statsGroupW = 169.0 * s
            let statsGroupH = 85.0 * s

            let bodyGraphX = originX + (203.85 * s)
            let bodyGraphY = originY + (15.14 * s)
            let bodyGraphW = 142.3 * s
            let bodyGraphH = 138.79 * s
            let bodyFigureW = 61.14 * s

            ZStack(alignment: .topLeading) {
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: w, height: h)
                    .clipped()

                HStack(alignment: .center, spacing: 2.08 * s) {
                    Image("champion")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 78.92 * s, height: 67.77 * s)
                        .offset(y: -8.0 * s)
                        .frame(width: 78.92 * s, height: rankGroupH, alignment: .top)

                    VStack(alignment: .leading, spacing: 0) {
                        Text("CHAMPION III")
                            .font(.custom("Figtree-Bold", size: 14.0 * s))
                            .foregroundStyle(Color(hex: 0xF8A6FF))
                            .lineLimit(1)

                        Text("35 LP")
                            .font(.custom("Figtree-Medium", size: 14.0 * s))
                            .foregroundStyle(Color(hex: 0xBA5ED0))
                            .lineLimit(1)
                    }
                    .frame(maxHeight: .infinity, alignment: .center)

                    Spacer(minLength: 0)
                }
                .frame(width: rankGroupW, height: rankGroupH, alignment: .leading)
                .position(
                    x: rankGroupX + (rankGroupW / 2.0),
                    y: rankGroupY + (rankGroupH / 2.0)
                )

                VStack(alignment: .leading, spacing: 2.0 * s) {
                    Text("Last 7 Days")
                        .font(.custom("Figtree-Medium", size: 10.0 * s))
                        .foregroundStyle(Color(hex: 0xFAFAFA).opacity(0.8))
                        .frame(width: statsGroupW, height: 16.0 * s, alignment: .leading)

                    HStack(alignment: .top, spacing: 4.0 * s) {
                        metricCard(
                            title: "Duration",
                            mainValue: "2h23",
                            unitValue: "m",
                            iconName: "upIcon",
                            deltaText: "28%",
                            scale: s
                        )

                        metricCard(
                            title: "Volume",
                            mainValue: "358",
                            unitValue: "Lb",
                            iconName: "equalIcon",
                            deltaText: "0%",
                            scale: s
                        )

                        metricCard(
                            title: "Reps",
                            mainValue: "39",
                            unitValue: nil,
                            iconName: "downIcon",
                            deltaText: "8%",
                            scale: s
                        )
                    }
                    .frame(width: statsGroupW, height: 67.0 * s, alignment: .leading)
                }
                .frame(width: statsGroupW, height: statsGroupH, alignment: .topLeading)
                .position(
                    x: statsGroupX + (statsGroupW / 2.0),
                    y: statsGroupY + (statsGroupH / 2.0)
                )

                HStack(alignment: .top, spacing: 20.0 * s) {
                    Image("bodyFront")
                        .resizable()
                        .scaledToFit()
                        .frame(width: bodyFigureW, height: bodyGraphH)

                    Image("bodyBack")
                        .resizable()
                        .scaledToFit()
                        .frame(width: bodyFigureW, height: bodyGraphH)
                }
                .frame(width: bodyGraphW, height: bodyGraphH, alignment: .topLeading)
                .position(
                    x: bodyGraphX + (bodyGraphW / 2.0),
                    y: bodyGraphY + (bodyGraphH / 2.0)
                )
            }
            .frame(width: w, height: h)
        }
        .containerBackground(for: .widget) { Color.clear }
    }
}

private func metricCard(
    title: String,
    mainValue: String,
    unitValue: String?,
    iconName: String,
    deltaText: String,
    scale s: CGFloat
) -> some View {
    VStack(alignment: .center, spacing: 0) {
        RoundedRectangle(cornerRadius: 8.0 * s, style: .continuous)
            .fill(Color(hex: 0x252031))
            .overlay(
                VStack(alignment: .center, spacing: 5.0 * s) {
                    Text(title)
                        .font(.custom("Figtree-Medium", size: 10.0 * s))
                        .foregroundStyle(Color(hex: 0xFAFAFA).opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .center)

                    metricValueText(
                        mainValue: mainValue,
                        unitValue: unitValue,
                        scale: s
                    )
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.leading, 4.0 * s)
                .padding(.trailing, 4.0 * s)
                .padding(.top, 4.0 * s)
                .padding(.bottom, 10.0 * s)
            )
            .frame(width: 53.67 * s, height: 51.0 * s)

        HStack(alignment: .center, spacing: 1.0 * s) {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 8.5 * s, height: 8.5 * s)

            Text(deltaText)
                .font(.custom("Figtree-Medium", size: 10.0 * s))
                .foregroundStyle(Color(hex: 0xFFFFFF).opacity(0.5))
                .lineLimit(1)
        }
        .frame(width: 53.67 * s, height: 16.0 * s, alignment: .center)
    }
    .frame(width: 53.67 * s, height: 67.0 * s, alignment: .top)
}

private func metricValueText(
    mainValue: String,
    unitValue: String?,
    scale s: CGFloat
) -> some View {
    Group {
        if let unitValue {
            HStack(alignment: .bottom, spacing: 0) {
                Text(mainValue)
                    .font(.custom("Figtree-Medium", size: 14.0 * s))
                    .foregroundStyle(Color(hex: 0x59B9F9))

                Text(unitValue)
                    .font(.custom("Figtree-Medium", size: 10.0 * s))
                    .foregroundStyle(Color(hex: 0x59B9F9))
                    .padding(.bottom, 1.0 * s)
            }
        } else {
            Text(mainValue)
                .font(.custom("Figtree-Medium", size: 14.0 * s))
                .foregroundStyle(Color(hex: 0x59B9F9))
        }
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

struct BodyGraphWidget1: Widget {
    let kind: String = "BodyGraphWidget1"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntent.self,
            provider: BodyGraphWidget1Provider()
        ) { entry in
            BodyGraphWidget1EntryView(entry: entry)
        }
        .supportedFamilies([.systemMedium])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemMedium) {
    BodyGraphWidget1()
} timeline: {
    BodyGraphWidget1Entry(
        date: .now,
        configuration: ConfigurationAppIntent()
    )
}
