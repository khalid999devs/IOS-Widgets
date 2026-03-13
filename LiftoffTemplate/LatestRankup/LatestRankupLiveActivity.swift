//
//  LatestRankupLiveActivity.swift
//  LatestRankup
//
//  Created by Khalid Ahammed on 12/3/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LatestRankupAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct LatestRankupLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LatestRankupAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension LatestRankupAttributes {
    fileprivate static var preview: LatestRankupAttributes {
        LatestRankupAttributes(name: "World")
    }
}

extension LatestRankupAttributes.ContentState {
    fileprivate static var smiley: LatestRankupAttributes.ContentState {
        LatestRankupAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: LatestRankupAttributes.ContentState {
         LatestRankupAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: LatestRankupAttributes.preview) {
   LatestRankupLiveActivity()
} contentStates: {
    LatestRankupAttributes.ContentState.smiley
    LatestRankupAttributes.ContentState.starEyes
}
