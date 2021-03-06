//
//  Spark.swift
//  SparkCon
//
//  Created by Nicolas Ameghino on 3/17/15.
//  Copyright (c) 2015 Nicolas Ameghino. All rights reserved.
//

import Foundation
import UIKit

let GLB_CORE3_IDENTIFIER = "55ff71065075555338581687"
let AuthorizationToken = "be564f2a4fd695c2c5c927e3a4c9e2777449547f"

typealias JSONDictionary = [String:AnyObject]
typealias SparkCoreCommandCallback = ((NSError!, JSONDictionary) -> Void)?

enum SparkPin: String {
    case Analog = "A"
    case Digital = "D"
    case Relay = "R"
}

enum LogicLevel: Int {
    case Low = 0
    case High = 1
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

class SparkCore: NSObject, NSCoding {
    let identifier: String
    let authToken: String
    
    var pinState: [LogicLevel] = [.Low, .Low, .Low, .Low, .Low, .Low, .Low, .Low]
    
    init(identifier: String, authToken: String) {
        self.identifier = identifier
        self.authToken = authToken
    }
    
    required init(coder aDecoder: NSCoder) {
        self.identifier = aDecoder.decodeObjectForKey("identifier") as! String
        self.authToken = aDecoder.decodeObjectForKey("authToken") as! String
        let pins = aDecoder.decodeObjectForKey("pinState") as! [Int]
        self.pinState = pins.map({ LogicLevel(rawValue: $0)! })
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.identifier, forKey: "identifier")
        aCoder.encodeObject(self.authToken, forKey: "authToken")
        aCoder.encodeObject(self.pinState.map({ $0.rawValue }), forKey: "pinState")
    }
    
    func setPin(pin: Int, level: LogicLevel) {
        self.setPin(pin, level: level, callback: nil)
    }
    
    func setPin(pin: Int, level: LogicLevel, callback: SparkCoreCommandCallback) {
        let command = SparkCommand.SetPin(.Digital, pin, level.rawValue)
        sendCommand(command) {
            [unowned self] (error, response) -> Void in
            
            
            if error != nil {
                NSLog("Error: \(error.localizedDescription)")
                if let cb = callback { cb(error, [:]) }
                return
            }
            
            NSLog("Response dict:\n\(response)")
            self.pinState[pin] = level
            
            if let cb = callback { cb(nil, response) }
        }
    }
    
    func togglePin(pin: Int) {
        self.togglePin(pin, callback: nil)
    }
    
    func togglePin(pin: Int, callback: SparkCoreCommandCallback) {
        switch pinState[pin] {
        case .Low:
            self.setPin(pin, level: .High, callback: callback)
        case .High:
            self.setPin(pin, level: .Low, callback: callback)
        }
    }
    
    private func sendCommand(command: SparkCommand, callback: SparkCoreCommandCallback) {
        let session = NSURLSession.sharedSession()
        let request = command.request(self.authToken, coreId: self.identifier)
        NSLog("will hit: \(request.URL?.absoluteString)")
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) in
            if let cb = callback {
                if error != nil {
                    cb(error, [:])
                } else {
                    var jsonError: NSError?
                    if let jdict = NSJSONSerialization.JSONObjectWithData(data,
                        options: NSJSONReadingOptions.allZeros,
                        error: &jsonError) as? JSONDictionary {
                            cb(nil, jdict)
                    } else {
                        cb(jsonError!, [:])
                    }
                    
                }
            }
        }
        task.resume()
    }
}
