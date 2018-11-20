//
//  ViewController.swift
//  matematica_3
//
//  Created by Alex on 12/05/18.
//  Copyright © 2018 Class_4AI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBAction func btnOptions(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "OptionsBool")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

