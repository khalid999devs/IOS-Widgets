//
//  MainLiftoffRankWidgetMascotLiveActivity.swift
//  MainLiftoffRankWidgetMascot
//
//  Created by Khalid Ahammed on 28/2/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MainLiftoffRankWidgetMascotAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MainLiftoffRankWidgetMascotLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MainLiftoffRankWidgetMascotAttributes.self) { context in
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

extension MainLiftoffRankWidgetMascotAttributes {
    fileprivate static var preview: MainLiftoffRankWidgetMascotAttributes {
        MainLiftoffRankWidgetMascotAttributes(name: "World")
    }
}

extension MainLiftoffRankWidgetMascotAttributes.ContentState {
    fileprivate static var smiley: MainLiftoffRankWidgetMascotAttributes.ContentState {
        MainLiftoffRankWidgetMascotAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MainLiftoffRankWidgetMascotAttributes.ContentState {
         MainLiftoffRankWidgetMascotAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: MainLiftoffRankWidgetMascotAttributes.preview) {
   MainLiftoffRankWidgetMascotLiveActivity()
} contentStates: {
    MainLiftoffRankWidgetMascotAttributes.ContentState.smiley
    MainLiftoffRankWidgetMascotAttributes.ContentState.starEyes
}
