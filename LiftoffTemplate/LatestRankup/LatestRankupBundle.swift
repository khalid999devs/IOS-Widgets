//
//  LatestRankupBundle.swift
//  LatestRankup
//
//  Created by Khalid Ahammed on 12/3/26.
//

import WidgetKit
import SwiftUI

@main
struct LatestRankupBundle: WidgetBundle {
    var body: some Widget {
        LatestRankup()
        LatestRankupControl()
        LatestRankupLiveActivity()
    }
}
