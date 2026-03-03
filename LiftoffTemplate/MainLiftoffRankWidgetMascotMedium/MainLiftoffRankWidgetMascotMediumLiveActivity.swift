//
//  MainLiftoffRankWidgetMascotMediumLiveActivity.swift
//  MainLiftoffRankWidgetMascotMedium
//
//  Created by Khalid Ahammed on 28/2/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MainLiftoffRankWidgetMascotMediumAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MainLiftoffRankWidgetMascotMediumLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MainLiftoffRankWidgetMascotMediumAttributes.self) { context in
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

extension MainLiftoffRankWidgetMascotMediumAttributes {
    fileprivate static var preview: MainLiftoffRankWidgetMascotMediumAttributes {
        MainLiftoffRankWidgetMascotMediumAttributes(name: "World")
    }
}

extension MainLiftoffRankWidgetMascotMediumAttributes.ContentState {
    fileprivate static var smiley: MainLiftoffRankWidgetMascotMediumAttributes.ContentState {
        MainLiftoffRankWidgetMascotMediumAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MainLiftoffRankWidgetMascotMediumAttributes.ContentState {
         MainLiftoffRankWidgetMascotMediumAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: MainLiftoffRankWidgetMascotMediumAttributes.preview) {
   MainLiftoffRankWidgetMascotMediumLiveActivity()
} contentStates: {
    MainLiftoffRankWidgetMascotMediumAttributes.ContentState.smiley
    MainLiftoffRankWidgetMascotMediumAttributes.ContentState.starEyes
}
