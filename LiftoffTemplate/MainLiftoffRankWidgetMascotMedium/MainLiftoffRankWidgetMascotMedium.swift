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

struct MainLiftoffRankWidgetMascotMediumEntryView: View {
    var entry: Provider.Entry

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

            let panelX = originX + (187.0 * s)
            let panelY = originY + (25.0 * s)
            let panelW = 161.0 * s
            let panelH = 181.0 * s

            let glowW = 97.0 * s
            let glowH = 96.0 * s
            let glowBlur = 25.0 * s
            let glowX = originX + (38.5 * s)
            let glowY = originY + (26.0 * s)

            let badgeW = 183.2 * s
            let badgeH = 157.0 * s
            let badgeX = originX + (-4.5 * s)
            let badgeY = originY + (-4.0 * s)

            let jymboW = 157.34 * s
            let jymboH = 192.04 * s
            let jymboX = originX + (8.77 * s)
            let jymboY = originY + (40.0 * s)

            let jymboEffectW = 128.0 * s
            let jymboEffectX = originX + ((8.77 + ((157.34 - 128.0) / 2.0)) * s)
            let jymboEffectY = jymboY + 48.0

            let shadingW = baseW * s
            let shadingH = 105.0 * s
            let shadingX = originX + (0.0 * s)
            let shadingY = originY + (75.0 * s)

            let shading2W = baseW * s
            let shading2H = 86.0 * s
            let shading2X = originX + (0.0 * s)
            let shading2Y = originY + (95.0 * s)

            ZStack(alignment: .topLeading) {
                Color(hex: 0x261E24)

                LeaderboardPanel(scale: s)
                    .frame(width: panelW, height: panelH, alignment: .top)
                    .offset(x: panelX, y: panelY)

                Circle()
                    .fill(Color(hex: 0xFF8400))
                    .frame(width: glowW, height: glowH)
                    .blur(radius: glowBlur)
                    .offset(x: glowX, y: glowY)

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
                    .frame(width: jymboW, height: jymboH)
                    .offset(x: jymboX, y: jymboY)

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
                    .offset(x: jymboEffectX, y: jymboEffectY)
                    .allowsHitTesting(false)
            }
            .frame(width: w, height: h)
        }
        .containerBackground(for: .widget) { Color.clear }
    }
}

private struct FitText: View {
    let text: String
    let fontName: String
    let size: CGFloat
    let minScale: CGFloat
    let color: Color
    let opacity: Double

    var body: some View {
        if #available(iOS 16.0, *) {
            ViewThatFits(in: .horizontal) {
                Text(text)
                    .font(.custom(fontName, size: size))
                    .foregroundStyle(color)
                    .opacity(opacity)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .allowsTightening(true)

                Text(text)
                    .font(.custom(fontName, size: size * minScale))
                    .foregroundStyle(color)
                    .opacity(opacity)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .allowsTightening(true)
            }
        } else {
            Text(text)
                .font(.custom(fontName, size: size))
                .foregroundStyle(color)
                .opacity(opacity)
                .lineLimit(1)
                .truncationMode(.tail)
                .minimumScaleFactor(minScale)
                .allowsTightening(true)
        }
    }
}

private struct LeaderboardPanel: View {
    let scale: CGFloat

    var body: some View {
        let gap = 6.0
        let headerW = 111.0 * scale
        let headerH = 12.0 * scale
        let headerFont = 10.0 * scale

        VStack(spacing: gap) {
            Text("Check out those gains")
                .font(.custom("Figtree-SemiBold", size: headerFont))
                .foregroundStyle(Color.white)
                .opacity(0.80)
                .frame(width: headerW, height: headerH, alignment: .center)
                .frame(maxWidth: .infinity, alignment: .center)

            VStack(spacing: gap) {
                LeaderboardRowHighlighted(
                    rankText: "#492",
                    nameText: "You",
                    subtitleText: "Top 23% in the world!",
                    avatarAssetName: nil,
                    scale: scale
                )

                LeaderboardRowUnhighlighted(
                    rankText: "#493",
                    nameText: "khristian",
                    avatarAssetName: nil,
                    scale: scale,
                    rowOpacity: 0.80
                )

                LeaderboardRowUnhighlighted(
                    rankText: "#494",
                    nameText: "Tom Petrucci",
                    avatarAssetName: nil,
                    scale: scale,
                    rowOpacity: 0.60
                )

                LeaderboardRowUnhighlighted(
                    rankText: "#495",
                    nameText: "",
                    avatarAssetName: nil,
                    scale: scale,
                    rowOpacity: 0.40
                )
            }
        }
    }
}

private struct LeaderboardRowHighlighted: View {
    let rankText: String
    let nameText: String
    let subtitleText: String?
    let avatarAssetName: String?
    let scale: CGFloat

    var body: some View {
        let rowH = 46.0 * scale
        let corner = 8.0 * scale

        let padL = 10.0 * scale
        let padR = 6.0 * scale
        let padT = 6.0 * scale
        let padB = 6.0 * scale

        let innerGap = 4.0
        let avatarSize = 25.0 * scale

        let fillOpacity = 0.50
        let strokeW = 0.5 * scale
        let shadowBlur = 8.0 * scale

        let rankFont = 20.0 * scale
        let nameFont = 12.0 * scale
        let subtitleFont = 8.0 * scale

        let rankColor = Color(hex: 0xFAFAFA)
        let nameColor = Color(hex: 0xFFFFFF)
        let subtitleColor = Color(hex: 0xFFFFFF)

        ZStack {
            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: Color(hex: 0xEAB000).opacity(1.0), location: 0.0),
                            .init(color: Color(hex: 0xB86200).opacity(0.5), location: 1.0),
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .opacity(fillOpacity)
                .overlay(
                    RoundedRectangle(cornerRadius: corner, style: .continuous)
                        .stroke(
                            LinearGradient(
                                stops: [
                                    .init(color: Color(hex: 0xFFFAA0), location: 0.0),
                                    .init(color: Color(hex: 0xFFD65C), location: 1.0),
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: strokeW
                        )
                )
                .shadow(color: Color(hex: 0xFFB521).opacity(1.0), radius: shadowBlur, x: 0, y: 0)

            HStack(spacing: innerGap) {
                VStack(alignment: .leading) {
                    HStack(alignment: .center, spacing: innerGap) {
                        Text(rankText)
                            .font(.custom("Figtree-SemiBold", size: rankFont))
                            .foregroundStyle(rankColor)
                            .opacity(1.0)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .allowsTightening(true)
                            .layoutPriority(2)

                        FitText(
                            text: nameText,
                            fontName: "Figtree-SemiBold",
                            size: nameFont,
                            minScale: 0.90,
                            color: nameColor,
                            opacity: 0.80
                        )
                        .layoutPriority(1)
                    }

                    if let subtitleText {
                        FitText(
                            text: subtitleText,
                            fontName: "Figtree-SemiBold",
                            size: subtitleFont,
                            minScale: 0.90,
                            color: subtitleColor,
                            opacity: 0.80
                        )
                        .layoutPriority(1)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                AvatarCircle(assetName: avatarAssetName)
                    .frame(width: avatarSize, height: avatarSize)
            }
            .padding(.leading, padL)
            .padding(.trailing, padR)
            .padding(.top, padT)
            .padding(.bottom, padB)
        }
        .frame(height: rowH)
    }
}

private struct LeaderboardRowUnhighlighted: View {
    let rankText: String
    let nameText: String
    let avatarAssetName: String?
    let scale: CGFloat
    let rowOpacity: CGFloat

    var body: some View {
        let rowH = 33.0 * scale
        let corner = 8.0 * scale

        let padL = 10.0 * scale
        let padR = 5.0 * scale
        let padT = 4.0 * scale
        let padB = 4.0 * scale

        let innerGap = 4.0
        let avatarSize = 25.0 * scale

        let fillOpacity = 0.50
        let strokeW = 0.5 * scale

        let rankFont = 20.0 * scale
        let nameFont = 8.0 * scale

        let rankColor = Color(hex: 0xFAFAFA)
        let nameColor = Color(hex: 0xFFFFFF)

        ZStack {
            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: Color(hex: 0xEAB000).opacity(1.0), location: 0.0),
                            .init(color: Color(hex: 0xB86200).opacity(0.5), location: 1.0),
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .opacity(fillOpacity)
                .overlay(
                    RoundedRectangle(cornerRadius: corner, style: .continuous)
                        .stroke(
                            LinearGradient(
                                stops: [
                                    .init(color: Color(hex: 0xFFE37E), location: 0.0),
                                    .init(color: Color(hex: 0xE6AE08), location: 1.0),
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: strokeW
                        )
                )

            HStack(spacing: innerGap) {
                HStack(alignment: .center, spacing: innerGap) {
                    Text(rankText)
                        .font(.custom("Figtree-SemiBold", size: rankFont))
                        .foregroundStyle(rankColor)
                        .opacity(1.0)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)

                    FitText(
                        text: nameText,
                        fontName: "Figtree-SemiBold",
                        size: nameFont,
                        minScale: 0.92,
                        color: nameColor,
                        opacity: 0.80
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                AvatarCircle(assetName: avatarAssetName)
                    .frame(width: avatarSize, height: avatarSize)
            }
            .padding(.leading, padL)
            .padding(.trailing, padR)
            .padding(.top, padT)
            .padding(.bottom, padB)
        }
        .opacity(rowOpacity)
        .frame(height: rowH)
    }
}

private struct AvatarCircle: View {
    let assetName: String?

    var body: some View {
        Group {
            if let assetName {
                Image(assetName)
                    .resizable()
                    .scaledToFill()
            } else {
                Color.white.opacity(0.25)
            }
        }
        .clipShape(Circle())
    }
}

struct MainLiftoffRankWidgetMascotMedium: Widget {
    let kind: String = "MainLiftoffRankWidgetMascotMedium"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            MainLiftoffRankWidgetMascotMediumEntryView(entry: entry)
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
    MainLiftoffRankWidgetMascotMedium()
} timeline: {
    SimpleEntry(date: .now, configuration: ConfigurationAppIntent())
}
