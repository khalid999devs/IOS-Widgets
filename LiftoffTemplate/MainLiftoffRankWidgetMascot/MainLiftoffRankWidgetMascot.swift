import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        .init(date: .now, configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        .init(date: .now, configuration: configuration)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let entry = SimpleEntry(date: .now, configuration: configuration)
        let next = Calendar.current.date(byAdding: .minute, value: 30, to: .now) ?? .now.addingTimeInterval(1800)
        return Timeline(entries: [entry], policy: .after(next))
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct MainLiftoffRankWidgetMascotEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        GeometryReader { geo in
            let side = min(geo.size.width, geo.size.height)

            let d = side * (97.0 / 170.0)
            let blur = side * (25.0 / 170.0)

            let shadingW = side * (172.0 / 170.0)
            let shadingH = side * (105.0 / 170.0)
            let shadingX = side * (-1.0 / 170.0)
            let shadingY = side * (65.0 / 170.0)

            let badgeW = side * (184.0 / 170.0)
            let badgeH = side * (158.0 / 170.0)
            let badgeX = side * (-7.0 / 170.0)
            let badgeY = side * (1.0 / 170.0)

            let jymboW = side * (157.34 / 170.0)
            let jymboBottomPadding = side * (0.0 / 170.0)

            let shading2W = side * (172.0 / 170.0)
            let shading2H = side * (86.0 / 170.0)
            let shading2X = side * (-2.0 / 170.0)
            let shading2Y = side * (90.0 / 170.0)

            let titleW = side * (111.0 / 170.0)
            let titleH = side * (12.0 / 170.0)
            let titleFont = side * (10.0 / 170.0)

            let titleTopY = side * (16.0 / 170.0)
            let titleCenterY = titleTopY + (titleH / 2.0)

            let shadowBlur = side * (4.0 / 170.0)

        
            let jymboEffectW = side * (128.0 / 170.0)

            ZStack(alignment: .topLeading) {
                Color(hex: 0x261E24)

                Circle()
                    .fill(Color(hex: 0xFF8400))
                    .frame(width: d, height: d)
                    .blur(radius: blur)
                    .position(x: geo.size.width / 2.0, y: geo.size.height / 2.0)

                Image("gold")
                    .resizable()
                    .scaledToFit()
                    .frame(width: badgeW, height: badgeH)
                    .offset(x: badgeX, y: badgeY)

                Rectangle()
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: Color(hex: 0xFBA651).opacity(0.0), location: 0.0),
                                .init(color: Color(hex: 0x9F8181).opacity(1.0), location: 1.0),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: shadingW, height: shadingH)
                    .offset(x: shadingX, y: shadingY)
                    .blendMode(.multiply)

                Image("jymbo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: jymboW)
                    .padding(.bottom, jymboBottomPadding)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .bottom)

                Rectangle()
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: Color(hex: 0xEDE0D2).opacity(0.0), location: 0.0),
                                .init(color: Color(hex: 0x9F8181).opacity(1.0), location: 1.0),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: shading2W, height: shading2H)
                    .offset(x: shading2X, y: shading2Y)
                    .blendMode(.multiply)

                Image("jymboEffect")
                    .resizable()
                    .scaledToFit()
                    .frame(width: jymboEffectW)
                    .padding(.bottom, jymboBottomPadding)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .bottom)
                    .allowsHitTesting(false)

                Text("Check out those gains")
                    .font(.custom("Figtree-SemiBold", size: titleFont))
                    .foregroundStyle(Color.white)
                    .opacity(0.80)
                    .shadow(color: Color.black.opacity(1.0), radius: shadowBlur, x: 0, y: 0)
                    .frame(width: titleW, height: titleH, alignment: .center)
                    .position(x: geo.size.width / 2.0, y: titleCenterY)
            }
        }
        .containerBackground(for: .widget) { Color.clear }
    }
}

struct MainLiftoffRankWidgetMascot: Widget {
    let kind: String = "MainLiftoffRankWidgetMascot"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            MainLiftoffRankWidgetMascotEntryView(entry: entry)
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
    MainLiftoffRankWidgetMascot()
} timeline: {
    SimpleEntry(date: .now, configuration: ConfigurationAppIntent())
}
