//
//  ViewController.swift
//  divisione_app_bambini
//
//  Created by Giulia Bugin on 05/05/18.
//  Copyright © 2018 Giulia Bugin. All rights reserved.
//

import UIKit

var dividendi: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
var divisori: [Int] =  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
var risultati: [Int] =  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
var divisoriDecimali: [Int] = [10,100,1000]
var appearkeyboard = false

class Bugin_Pinton_Controller: UIViewController {
    //es 1
    @IBOutlet var dividendiLabel: Array<UILabel> = []
    @IBOutlet var risultatoTextField: Array<UITextField> = []
    //es 2
    @IBOutlet var divisoriLabel2: Array<UILabel> = []
    @IBOutlet var risultatiLabel2: Array<UILabel> = []
    @IBOutlet var dividendiLabel2: Array<UILabel> = []
    @IBOutlet var risultatoTextField2: Array<UITextField> = []
    @IBOutlet var Zone: UIView!
    
    var ishidden = false
    var divisore = 0
    
    @IBAction func controlla(_ sender: Any) {
        //es 1------------------------------------------------------------------------
        var count = 0
        for var a in risultatoTextField
        {
            risultatoTextField[count].layer.borderWidth = 2
            risultatoTextField[count].layer.cornerRadius = 7
            if let n = Int(a.text!){
                
                if( (a.text == "") || (Int(dividendiLabel[count].text!)!/dividendiLabel[count].tag) != Int(a.text!)!){
                    risultatoTextField[count].layer.borderColor = UIColor.red.cgColor
                }else{
                    risultatoTextField[count].layer.borderColor = UIColor.green.cgColor
                    risultatoTextField[count].isEnabled = false
                }
            }
            count += 1
        }
        //es 2---------------------------------------------------------------------------------
        count = 0
        for var a in risultatoTextField2{
            switch (count){
            case 0...5:if(Int(a.text!) != dividendi[count]){
                a.layer.borderColor = UIColor.red.cgColor
            }else{
                a.layer.borderColor = UIColor.green.cgColor
                a.isEnabled = false
            }; break
            case 6...11:if(Int(a.text!) != divisori[count]){
                a.layer.borderColor = UIColor.red.cgColor
            }else{
                a.layer.borderColor = UIColor.green.cgColor
                a.isEnabled = false
            }; break
            case 12...17:if(Int(a.text!) != risultati[count]){
                a.layer.borderColor = UIColor.red.cgColor
            }else{
                a.layer.borderColor = UIColor.green.cgColor
                a.isEnabled = false
            }; break
            default: break
            }
            a.layer.borderWidth = 2
            a.layer.cornerRadius = 7
            count += 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view, typically from a nib.
        //risultatoTextField[0]
        
        carica(dividendiLabel: dividendiLabel, divisoriLabel2: divisoriLabel2,risultatiLabel2: risultatiLabel2, dividendiLabel2: dividendiLabel2, risultatoTextField2: risultatoTextField2)
        tastieraNumerica(risultatoTextField: risultatoTextField2,risultatoTextField2: risultatoTextField2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func keyboardWillAppear(_ sender: Any)
    {
        if(ishidden == true)
        {
            self.Zone.transform = CGAffineTransform.init(translationX: 0.0, y: -390)
            ishidden = false
        }
    }
    
    @objc func keyboardWillDisappear(_notification: NSNotification)
    {
        if(ishidden == false)
        {
            self.Zone.transform = CGAffineTransform.init(translationX: 0.0, y: 0.0)
            ishidden = true
        }
    }
    
}

func tastieraNumerica(risultatoTextField: Array<UITextField>,risultatoTextField2: Array<UITextField>){
    for var a in risultatoTextField{
        a.keyboardType = UIKeyboardType.decimalPad
        a.layer.backgroundColor = UIColor.lightGray.cgColor
    }
    for var a in risultatoTextField2{
        a.keyboardType = UIKeyboardType.decimalPad
        a.layer.backgroundColor = UIColor.lightGray.cgColor
    }
}

func carica(dividendiLabel: Array<UILabel>,divisoriLabel2: Array<UILabel>, risultatiLabel2: Array<UILabel>,dividendiLabel2: Array<UILabel>, risultatoTextField2: Array<UITextField> )
{
    //es 1------------------------------------------------------------------------
    var controllo = false
    for var a in dividendiLabel
    {
        var i = Int(arc4random_uniform(99)+1)
        switch (a.tag){
        case 10: a.text = String(i*10); break
        case 100: a.text = String(i*100); break
        case 1000: a.text = String(i*1000); break
        default: break
        }
    }
    //es 2----------------------------------------------------------------------------------
    var count = 0
    for var a in dividendi
    {
        divisori[count] = divisoriDecimali[Int(arc4random_uniform(3))]
        dividendi[count] = Int(arc4random_uniform(9989)+10)
        
        switch (divisori[count]){
        case 10:    if(dividendi[count] % 10 != 0){
            while(dividendi[count] % 10 != 0)
            {
                dividendi[count] = Int(arc4random_uniform(9989)+10)
            }
        }; break
        case 100:  if(dividendi[count] % 100 != 0){
            while(dividendi[count] % 100 != 0)
            {
                dividendi[count] = Int(arc4random_uniform(9989)+10)
            }
        }; break
        case 1000:if(dividendi[count] % 1000 != 0){
            while(dividendi[count] % 1000 != 0)
            {
                dividendi[count] = Int(arc4random_uniform(9989)+10)
            }
        }; break
        default: break
        }
        risultati[count] = dividendi[count] / divisori[count]
        count += 1
        usleep(2000)
    }
    count = 0
    for var a in divisoriLabel2{
        switch (count){
        case 0...5: a.text = a.text! + String(divisori[count])
        risultatiLabel2[count].text = risultatiLabel2[count].text! + String(risultati[count])
        dividendiLabel2[count].text = String(dividendi[count+6]) + dividendiLabel2[count].text!; break
        case 6...11: a.text = a.text! + String(divisori[count+6]);
        risultatiLabel2[count].text = risultatiLabel2[count].text! + String(risultati[count])
        dividendiLabel2[count].text = String(dividendi[count+6]) + dividendiLabel2[count].text!; break
        default: break
        }
        count += 1
    }
}







