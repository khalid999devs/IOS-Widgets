import WidgetKit
import SwiftUI
import AppIntents

enum MainLiftoffRankMode: String, AppEnum {
    case minimal
    case mascot

    static var typeDisplayRepresentation: TypeDisplayRepresentation { "Mode" }

    static var caseDisplayRepresentations: [MainLiftoffRankMode: DisplayRepresentation] {
        [
            .minimal: "Minimal",
            .mascot: "Mascot"
        ]
    }
}

struct MainLiftoffRankConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Main Liftoff Rank"
    static var description = IntentDescription("Choose a widget mode")

    @Parameter(title: "Mode")
    var mode: MainLiftoffRankMode?
}

struct MainLiftoffRankProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> MainLiftoffRankEntry {
        .init(date: .now, configuration: MainLiftoffRankConfigurationIntent())
    }

    func snapshot(
        for configuration: MainLiftoffRankConfigurationIntent,
        in context: Context
    ) async -> MainLiftoffRankEntry {
        .init(date: .now, configuration: configuration)
    }

    func timeline(
        for configuration: MainLiftoffRankConfigurationIntent,
        in context: Context
    ) async -> Timeline<MainLiftoffRankEntry> {
        let entry = MainLiftoffRankEntry(date: .now, configuration: configuration)
        let next = Calendar.current.date(byAdding: .minute, value: 30, to: .now) ?? .now.addingTimeInterval(1800)
        return Timeline(entries: [entry], policy: .after(next))
    }
}

struct MainLiftoffRankEntry: TimelineEntry {
    let date: Date
    let configuration: MainLiftoffRankConfigurationIntent
}

struct MainLiftoffRankWidgetEntryView: View {
    var entry: MainLiftoffRankProvider.Entry

    var body: some View {
        let mode = entry.configuration.mode ?? .mascot
        let isUnranked = false

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
            let badgeY = side * ((mode == .mascot ? 1.0 : 6.0) / 170.0)

            let titleW = side * (111.0 / 170.0)
            let titleH = side * (12.0 / 170.0)
            let titleFont = side * (10.0 / 170.0)

            let titleTopY = side * (16.0 / 170.0)
            let titleCenterY = titleTopY + (titleH / 2.0)

            let shadowBlur = side * (4.0 / 170.0)

            let jymboW = side * (157.34 / 170.0)
            let jymboBottomPadding = side * (0.0 / 170.0)

            let shading2W = side * (172.0 / 170.0)
            let shading2H = side * (86.0 / 170.0)
            let shading2X = side * (-2.0 / 170.0)
            let shading2Y = side * (90.0 / 170.0)

            let jymboEffectW = side * (128.0 / 170.0)

            let ridgeW = side * (108.54 / 170.0)
            let ridgeH = side * (125.71 / 170.0)
            let ridgeX = side * (31.0 / 170.0)
            let ridgeY = side * ((mode == .mascot ? 20.0 : 22.0) / 170.0)
            let ridgeCenterX = ridgeX + (ridgeW / 2.0)
            let ridgeCenterY = ridgeY + (ridgeH / 2.0)
            let ridgeBlur = side * (25.0 / 170.0)

            ZStack(alignment: .topLeading) {
                Color(hex: 0x261E24)

                if !isUnranked {
                    Circle()
                        .fill(Color(hex: 0xFF8400))
                        .frame(width: d, height: d)
                        .blur(radius: blur)
                        .position(x: geo.size.width / 2.0, y: geo.size.height / 2.0)
                } else {
                    RidgeGlowShape()
                        .fill(
                            AngularGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color(hex: 0xFF1519), location: 0.00),
                                    .init(color: Color(hex: 0xD049FF), location: 0.17),
                                    .init(color: Color(hex: 0x6278FF), location: 0.32),
                                    .init(color: Color(hex: 0x36FFD2), location: 0.50),
                                    .init(color: Color(hex: 0xFFCB12), location: 0.67),
                                    .init(color: Color(hex: 0xD7F8F9), location: 0.82),
                                    .init(color: Color(hex: 0xFF6826), location: 1.00)
                                ]),
                                center: .center,
                                startAngle: .degrees(90),
                                endAngle: .degrees(450)
                            )
                        )
                        .frame(width: ridgeW, height: ridgeH)
                        .blur(radius: ridgeBlur)
                        .position(x: ridgeCenterX, y: ridgeCenterY)
                        .allowsHitTesting(false)
                }

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
                                .init(color: Color(hex: 0x9F8181).opacity(1.0), location: 1.0)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: shadingW, height: shadingH)
                    .offset(x: shadingX, y: shadingY)
                    .blendMode(.multiply)

                if mode == .mascot {
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
                                    .init(color: Color(hex: 0x9F8181).opacity(1.0), location: 1.0)
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
                }

                Text(isUnranked ? "Discover your rank?" : "Check out those gains")
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

private struct RidgeGlowShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.height * 0.22))
        path.addLine(to: CGPoint(x: rect.width * 0.50, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.height * 0.22))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.height * 0.78))
        path.addLine(to: CGPoint(x: rect.width * 0.50, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.height * 0.78))
        path.closeSubpath()

        return path
    }
}

struct MainLiftoffRankWidgetMascot: Widget {
    let kind: String = "MainLiftoffRankWidgetMascot"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: MainLiftoffRankConfigurationIntent.self,
            provider: MainLiftoffRankProvider()
        ) { entry in
            MainLiftoffRankWidgetEntryView(entry: entry)
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
    MainLiftoffRankEntry(date: .now, configuration: {
        var i = MainLiftoffRankConfigurationIntent()
        i.mode = .mascot
        return i
    }())

    MainLiftoffRankEntry(date: .now, configuration: {
        var i = MainLiftoffRankConfigurationIntent()
        i.mode = .minimal
        return i
    }())
}
