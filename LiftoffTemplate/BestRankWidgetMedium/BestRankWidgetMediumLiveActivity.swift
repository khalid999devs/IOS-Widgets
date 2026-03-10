//
//  BestRankWidgetMediumLiveActivity.swift
//  BestRankWidgetMedium
//
//  Created by Khalid Ahammed on 11/3/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct BestRankWidgetMediumAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct BestRankWidgetMediumLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BestRankWidgetMediumAttributes.self) { context in
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

extension BestRankWidgetMediumAttributes {
    fileprivate static var preview: BestRankWidgetMediumAttributes {
        BestRankWidgetMediumAttributes(name: "World")
    }
}

extension BestRankWidgetMediumAttributes.ContentState {
    fileprivate static var smiley: BestRankWidgetMediumAttributes.ContentState {
        BestRankWidgetMediumAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: BestRankWidgetMediumAttributes.ContentState {
         BestRankWidgetMediumAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: BestRankWidgetMediumAttributes.preview) {
   BestRankWidgetMediumLiveActivity()
} contentStates: {
    BestRankWidgetMediumAttributes.ContentState.smiley
    BestRankWidgetMediumAttributes.ContentState.starEyes
}
