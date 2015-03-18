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
        core.togglePin(0)
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

