//
//  BestRankWidgetBundle.swift
//  BestRankWidget
//
//  Created by Khalid Ahammed on 9/3/26.
//

import WidgetKit
import SwiftUI

@main
struct BestRankWidgetBundle: WidgetBundle {
    var body: some Widget {
        BestRankWidget()
        BestRankWidgetControl()
        BestRankWidgetLiveActivity()
    }
}
