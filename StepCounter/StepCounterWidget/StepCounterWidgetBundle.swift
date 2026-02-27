//
//  StepCounterWidgetBundle.swift
//  StepCounterWidget
//
//  Created by Khalid Ahammed on 26/2/26.
//

import WidgetKit
import SwiftUI

@main
struct StepCounterWidgetBundle: WidgetBundle {
    var body: some Widget {
        StepCounterWidget()
        StepCounterWidgetControl()
        StepCounterWidgetLiveActivity()
    }
}
