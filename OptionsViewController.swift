//
//  Options_ViewController.swift
//  matematica_3
//
//  Created by Filippo Daminato on 20/11/2018.
//  Copyright © 2018 Class_4AI. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {

    @IBAction func back(_ sender: Any) {
         self.dismiss(animated: true) {}
    }
    @IBAction func text_name(_ sender: UITextField) {
        let defaults = UserDefaults.standard
        defaults.set(sender.text, forKey: "NomeBimbo")
    }

    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var btn_enter_outlet: UIButton!
    @IBOutlet weak var text_name_outlet: UITextField!
    @IBOutlet weak var btn_back: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if(defaults.bool(forKey: "OptionsBool")){
            //enter form button
            //nascondere label e button enter
            //mostrare textfield e back button
            defaults.set(false, forKey: "OptionsBool")
            lbl_name.isHidden = true
            btn_enter_outlet.isHidden = true
            text_name_outlet.isHidden = false
            btn_back.isHidden = false
            
            if let stringOne = defaults.string(forKey: "NomeBimbo") {
                text_name_outlet.text = stringOne
            }
        }
        else{
           //enter from launch
            //mostrare label e button enter
            //nascondere textfield e back button
            lbl_name.isHidden = false
            btn_enter_outlet.isHidden = false
            text_name_outlet.isHidden = true
            btn_back.isHidden = true
            
            
            if let stringOne = defaults.string(forKey: "NomeBimbo") {
                lbl_name.text = stringOne
            }
        }
        
        print(defaults.bool(forKey: "OptionsBool"))

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
