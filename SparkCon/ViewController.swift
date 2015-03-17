//
//  ViewController.swift
//  SparkCon
//
//  Created by Nicolas Ameghino on 3/17/15.
//  Copyright (c) 2015 Nicolas Ameghino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    var turnOn = true
    let core = SparkCore(
        identifier: GLB_CORE3_IDENTIFIER,
        authToken: AuthorizationToken
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.addTarget(self, action: "hitIt:", forControlEvents: .TouchUpInside)
    }
    
    func hitIt(sender: UIControl) {
        let session = NSURLSession.sharedSession()
        
        let command = SparkCommand.SetPin(.Relay, 0, (turnOn ? 1 : 0))
        turnOn = !turnOn
        
        core.sendCommand(command) {
            (data, response, error) in
            return
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

