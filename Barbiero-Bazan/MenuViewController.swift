//
//  MenuViewController.swift
//  matematica_3
//
//  Created by Giovanni Barbiero on 11/12/2018.
//  Copyright © 2018 Class_4AI. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func btnEsciClick(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    
    @IBAction func btnSfidaClick(_ sender: Any) {
    }
    
    @IBAction func btnAllenamentoClick(_ sender: Any) {
    }
}
