//
//  MainLiftoffRankWidgetLiveActivity.swift
//  MainLiftoffRankWidget
//
//  Created by Khalid Ahammed on 27/2/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MainLiftoffRankWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MainLiftoffRankWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MainLiftoffRankWidgetAttributes.self) { context in
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

extension MainLiftoffRankWidgetAttributes {
    fileprivate static var preview: MainLiftoffRankWidgetAttributes {
        MainLiftoffRankWidgetAttributes(name: "World")
    }
}

extension MainLiftoffRankWidgetAttributes.ContentState {
    fileprivate static var smiley: MainLiftoffRankWidgetAttributes.ContentState {
        MainLiftoffRankWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MainLiftoffRankWidgetAttributes.ContentState {
         MainLiftoffRankWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: MainLiftoffRankWidgetAttributes.preview) {
   MainLiftoffRankWidgetLiveActivity()
} contentStates: {
    MainLiftoffRankWidgetAttributes.ContentState.smiley
    MainLiftoffRankWidgetAttributes.ContentState.starEyes
}
