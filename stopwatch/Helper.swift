//
//  Helper.swift
//  stopwatch
//
//  Created by Wittmayer,Jack T on 1/9/20.
//  Copyright © 2020 Jack Wittmayer. All rights reserved.
//
import Foundation
import UIKit
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
func convertSecondsToMinutesWithoutMili(counter: Double) -> String
{
    var timeLabelTime = ""
    let minutes = Int(counter/60.0)
    let seconds = counter-Double(minutes*60)
    timeLabelTime += String(minutes) + ":"
    if seconds <= 10
    {
        timeLabelTime += "0"
    }
    timeLabelTime += String(format: "%.0f", seconds)
    return timeLabelTime
}

func convertDateToString(date: Date) -> String
{
    let dateFormatter = DateFormatter()

    dateFormatter.dateStyle = .full

    dateFormatter.timeStyle = .full

    let dateString = dateFormatter.string(from: date)
    return dateString
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

func routesAreEqual(route1: Route, route2: Route) -> Bool
{
    // if one route has walks and the other doesn't, return false
    if (route1.walks == nil && route2.walks != nil) || (route1.walks != nil && route2.walks == nil)
    {
        return false
    }

    else if let walks1 = route1.walks, let walks2 = route2.walks
    {
        if (walks1.count != walks2.count) //check that walk counts are equal
        {
            return false
        }
        // iterate through walk arrays and check each walks for equality
        for (index, walk) in walks1.enumerated()
        {
            if (!walksAreEqual(walk1: walk, walk2: walks2[index]))
            {
                return false
            }
        }
    }

    if (route1.name != route2.name) {return false}
    else if (route1.start != route2.start) {return false}
    else if (route1.end != route2.end) {return false}
    else if (route1.photo != route2.photo) {return false}
    else {return true}
}

func walksAreEqual(walk1: Walk, walk2: Walk) -> Bool
{
    if (walk1.name != walk2.name) {return false}
    else if (walk1.time != walk2.time) {return false}
    else if (walk1.vehicle != walk2.vehicle) {return false}
    else {return true}
}
