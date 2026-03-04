//
//  NextRankUpWidgetLiveActivity.swift
//  NextRankUpWidget
//
//  Created by Khalid Ahammed on 4/3/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct NextRankUpWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct NextRankUpWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NextRankUpWidgetAttributes.self) { context in
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

extension NextRankUpWidgetAttributes {
    fileprivate static var preview: NextRankUpWidgetAttributes {
        NextRankUpWidgetAttributes(name: "World")
    }
}

extension NextRankUpWidgetAttributes.ContentState {
    fileprivate static var smiley: NextRankUpWidgetAttributes.ContentState {
        NextRankUpWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: NextRankUpWidgetAttributes.ContentState {
         NextRankUpWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: NextRankUpWidgetAttributes.preview) {
   NextRankUpWidgetLiveActivity()
} contentStates: {
    NextRankUpWidgetAttributes.ContentState.smiley
    NextRankUpWidgetAttributes.ContentState.starEyes
}
