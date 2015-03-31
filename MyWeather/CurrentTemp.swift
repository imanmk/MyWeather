//
//  CurrentTemp.swift
//  MyWeather
//
//  Created by Iman Mk R on 1/14/15.
//  Copyright (c) 2015 Iman Mk. All rights reserved.
//

import Foundation
import UIKit

struct CurrentTempInfo {
    
    var currentTime: String?
    var temperature: Int
    var humidity : Double
    var precipProbability: Double
    var summary : String
    var icon : UIImage?
    
    init(weatherDictionary: NSDictionary) {
        
        let currentWeather = weatherDictionary["currently"] as NSDictionary
        let currentTimeIntValue = currentWeather["time"] as Int
        let imageString = currentWeather["icon"] as String
        temperature = currentWeather["temperature"] as Int
        humidity = currentWeather["humidity"] as Double
        precipProbability = currentWeather["precipProbability"] as Double
        summary = currentWeather["summary"] as String
        icon = imageFromString(imageString)
        currentTime = unixTimeToDateString(currentTimeIntValue)
    }
    func unixTimeToDateString(unixTime: Int) -> String {
        
        let timeInSecs = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSecs)
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        return dateFormatter.stringFromDate(weatherDate)
        
    }
    
    func imageFromString(stringIcon: String) -> UIImage {
        var imageName : String
        switch stringIcon {
        case "clear-day":
            imageName = "clear-day"
        case "clear-night":
            imageName = "clear-night"
        case "rain":
            imageName = "rain"
        case "snow":
            imageName = "snow"
        case "sleet":
            imageName = "sleet"
        case "wind":
            imageName = "wind"
        case "fog":
            imageName = "fog"
        case "cloudy":
            imageName = "cloudy"
        case "partly-cloudy-day":
            imageName = "partly-cloudy"
        case "partly-cloudy-night":
            imageName = "cloudy-night"
        default:
            imageName = "default"
        }
       var iconImage = UIImage(named: imageName)
        return iconImage!
    }
}