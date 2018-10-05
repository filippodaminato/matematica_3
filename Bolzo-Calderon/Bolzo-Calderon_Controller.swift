//
//  Bolzo-Calderon_Controller.swift
//  matematica_3
//
//  Created by Alex on 19/05/18.
//  Copyright © 2018 Class_4AI. All rights reserved.
//

import UIKit
import Darwin

class Bolzo_Calderon_Controller: UIViewController {

    
//    Label
    @IBOutlet weak var num_rand: UILabel!
    @IBOutlet weak var lbl_result: UILabel!
    @IBOutlet weak var lbl_num: UILabel!
    @IBOutlet weak var lbl_denom: UILabel!
    //    text fields
    @IBOutlet weak var denominatore: UITextField!
    @IBOutlet weak var numeratore: UITextField!
//    buttons
    @IBAction func btn_check(_ sender: Any) {
        if(numeratore.text != "" && denominatore.text != ""){
            
            if(Double(numeratore.text!)! == num && Double(denominatore.text!)! == deno){
                lbl_result.text = "giusto"
            }
            else{
                lbl_result.text = "sbagliato"
            }
        }
    }
    
    var num:Double = 0
    var deno:Double = 0
    var startNumber:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        num = getNumeratore()
        deno = getDenominatore()
        lbl_num.text = String(num)
        lbl_denom.text = String(deno)
        startNumber = getStartNumber(numeratore: num, denominatore: deno)
        num_rand.text = String(startNumber)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ritorna intero che corrisponde al denominatore
    func getDenominatore() -> Double {
        let cases = [10,100,1000]
        return Double(cases[Int(arc4random_uniform(3))])
    }
    
    func getNumeratore() -> Double {
        return Double(arc4random_uniform(7000))+1
    }
    
    func getStartNumber(numeratore:Double,denominatore:Double) -> Double {
        
//        return Double(round(1000*numeratore)/1000)
        return Double(numeratore/denominatore) // Swift 3 version
    }
    

}
