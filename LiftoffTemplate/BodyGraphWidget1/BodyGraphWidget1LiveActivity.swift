//
//  BodyGraphWidget1LiveActivity.swift
//  BodyGraphWidget1
//
//  Created by Khalid Ahammed on 13/3/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct BodyGraphWidget1Attributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct BodyGraphWidget1LiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BodyGraphWidget1Attributes.self) { context in
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

extension BodyGraphWidget1Attributes {
    fileprivate static var preview: BodyGraphWidget1Attributes {
        BodyGraphWidget1Attributes(name: "World")
    }
}

extension BodyGraphWidget1Attributes.ContentState {
    fileprivate static var smiley: BodyGraphWidget1Attributes.ContentState {
        BodyGraphWidget1Attributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: BodyGraphWidget1Attributes.ContentState {
         BodyGraphWidget1Attributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: BodyGraphWidget1Attributes.preview) {
   BodyGraphWidget1LiveActivity()
} contentStates: {
    BodyGraphWidget1Attributes.ContentState.smiley
    BodyGraphWidget1Attributes.ContentState.starEyes
}
