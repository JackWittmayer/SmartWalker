//
//  Helper.swift
//  stopwatch
//
//  Created by Wittmayer,Jack T on 1/9/20.
//  Copyright © 2020 Jack Wittmayer. All rights reserved.
//
func convertSecondsToMinutes(counter: Double) -> String
{
    var timeLabelTime = ""
    let minutes = Int(counter/60.0)
    let seconds = counter-Double((minutes*60))
    timeLabelTime += String(minutes) + ":"
    if seconds <= 10
    {
        timeLabelTime += "0"
    }
    timeLabelTime += String(format: "%.1f", seconds)
    return timeLabelTime
}
