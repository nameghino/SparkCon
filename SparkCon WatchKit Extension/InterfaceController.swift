//
//  InterfaceController.swift
//  SparkCon WatchKit Extension
//
//  Created by Nicolas Ameghino on 3/17/15.
//  Copyright (c) 2015 Nicolas Ameghino. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    let core = SparkCore(identifier: GLB_CORE3_IDENTIFIER, authToken: AuthorizationToken)
    
    @IBOutlet weak var greenButton: WKInterfaceButton!
    @IBOutlet weak var yellowButton: WKInterfaceButton!
    @IBOutlet weak var redButton: WKInterfaceButton!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func greenButtonAction() { self.handleButton(greenButton) }
    @IBAction func yellowButtonAction() { self.handleButton(yellowButton) }
    @IBAction func redButtonAction() { self.handleButton(redButton) }
    
    func handleButton(button: WKInterfaceButton!) {
        let pin: Int
        switch button {
        case yellowButton:
            pin = 1
        case redButton:
            pin = 2
        default:
            pin = 0
            break
        }
        
        core.setPin(0, level: .High)
    }
    
}
