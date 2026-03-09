//
//  NextRankUpWidgetMediumLiveActivity.swift
//  NextRankUpWidgetMedium
//
//  Created by Khalid Ahammed on 6/3/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct NextRankUpWidgetMediumAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct NextRankUpWidgetMediumLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NextRankUpWidgetMediumAttributes.self) { context in
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

extension NextRankUpWidgetMediumAttributes {
    fileprivate static var preview: NextRankUpWidgetMediumAttributes {
        NextRankUpWidgetMediumAttributes(name: "World")
    }
}

extension NextRankUpWidgetMediumAttributes.ContentState {
    fileprivate static var smiley: NextRankUpWidgetMediumAttributes.ContentState {
        NextRankUpWidgetMediumAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: NextRankUpWidgetMediumAttributes.ContentState {
         NextRankUpWidgetMediumAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: NextRankUpWidgetMediumAttributes.preview) {
   NextRankUpWidgetMediumLiveActivity()
} contentStates: {
    NextRankUpWidgetMediumAttributes.ContentState.smiley
    NextRankUpWidgetMediumAttributes.ContentState.starEyes
}
