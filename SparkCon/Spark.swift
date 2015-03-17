//
//  Spark.swift
//  SparkCon
//
//  Created by Nicolas Ameghino on 3/17/15.
//  Copyright (c) 2015 Nicolas Ameghino. All rights reserved.
//

import Foundation
import UIKit

enum SparkPin: String {
    case Analog = "A"
    case Digital = "D"
    case Relay = "R"
}

enum SparkCommand {
    static let endpoint = NSURL(string: "https://api.spark.io")!
    
    case SetPin(SparkPin, Int, Int)
    case TimedPin(SparkPin, Int, Int)
    
    var functionName: String {
        get {
            switch self {
            case .SetPin(_, _, _):
                return "setPin"
            case .TimedPin(_, _, _):
                return "timedPin"
            }
        }
    }
    
    var stringValue: String {
        get {
            switch self {
            case .SetPin(let type, let pin, let level):
                return "\(type.rawValue)\(pin)@\(level)"
            case .TimedPin(let type, let pin, let millis):
                return "\(type.rawValue)\(pin)@\(millis)"
            }
        }
    }
    
    func request(token: String, coreId: String) -> NSURLRequest {
        let url = NSURL(string: "/v1/devices/\(coreId)/\(self.functionName)", relativeToURL: SparkCommand.endpoint)
        let r = NSMutableURLRequest(URL: url!)
        r.HTTPMethod = "POST"
        
        let data = NSJSONSerialization.dataWithJSONObject(["args": self.stringValue], options: NSJSONWritingOptions.allZeros, error: nil)
        
        r.HTTPBody = data
        r.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        r.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return r
    }
}

let r1on = SparkCommand.SetPin(.Relay, 0, 1)
let r1off = SparkCommand.SetPin(.Relay, 0, 0)

let coreId = "55ff71065075555338581687"
let authToken = "be564f2a4fd695c2c5c927e3a4c9e2777449547f"