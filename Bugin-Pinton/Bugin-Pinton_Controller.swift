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
var previousNumber: UInt32? // used in randomNumber()

class Bugin_Pinton_Controller: UIViewController {
    //es 1
    @IBOutlet var dividendiLabel: Array<UILabel> = []
    @IBOutlet var risultatoTextField: Array<UITextField> = []
    @IBOutlet weak var controllaEnable: UIButton!
    //es 2
    @IBOutlet var divisoriLabel2: Array<UILabel> = []
    @IBOutlet var risultatiLabel2: Array<UILabel> = []
    @IBOutlet var dividendiLabel2: Array<UILabel> = []
    @IBOutlet var risultatoTextField2: Array<UITextField> = []
    //view vincita
    @IBOutlet weak var viewVincita: UIView!
    @IBOutlet weak var immagineStelle: UIImageView!
    @IBOutlet weak var labelPunteggio: UILabel!
    
    @IBOutlet var Zone: UIView!
    
    var punteggio = 0
    var ishidden = true
    var divisore = 0
    let numeri = CharacterSet.decimalDigits
    
    @IBAction func chiudiViewVincita(_ sender: Any) {
        viewVincita.isHidden = true
        if(punteggio != 42){
            controllaEnable.isEnabled = true
        }else{
            indietro((Any).self)
        }
    }
    
    @IBAction func indietro(_ sender: Any) {
        self.dismiss(animated: true) {}
    }
    
    @IBAction func controlla(_ sender: Any) {
        controllaEnable.isEnabled = false//es 1------------------------------------------------------------------------
        self.Zone.transform = CGAffineTransform.init(translationX: 0.0, y: 0.0)
        ishidden = true
        self.view.endEditing(true)
        var count = 0, controllo1 = true,appoggio = 0, appSbagliato = 0, punteggioSbagliato = 0
        for a in risultatoTextField
        {
            risultatoTextField[count].layer.borderWidth = 2
            risultatoTextField[count].layer.cornerRadius = 7
            if Int(a.text!) != nil{
                for i in a.text!.unicodeScalars{
                    if(numeri.contains(i))
                    {
                        if( (a.text == "") || (Int(dividendiLabel[count].text!)!/dividendiLabel[count].tag) != Int(a.text!)!){
                            risultatoTextField[count].layer.borderColor = UIColor.red.cgColor
                            appSbagliato += 1
                        }else{
                            risultatoTextField[count].layer.borderColor = UIColor.green.cgColor
                            risultatoTextField[count].isEnabled = false
                            controllo1 = true
                            appoggio += 1
                        }
                    }else{
                        a.layer.borderColor = UIColor.red.cgColor
                    }
                }
                if(appoggio == a.text?.count){
                    punteggio += 1
                }
                if (appSbagliato == a.text?.count){
                    punteggioSbagliato += 1
                }
                appoggio = 0
                appSbagliato = 0
            }
            count += 1
        }
        
        count = 0//es 2---------------------------------------------------------------------------------
        var controllo = false
        for a in risultatoTextField2{
            for i in a.text!.unicodeScalars{
                if(numeri.contains(i))
                {
                    controllo = true
                }else{
                    a.layer.borderColor = UIColor.red.cgColor
                }
            }
            if(controllo){
                switch (count){
                case 0...5:if(Int(a.text!) != dividendi[count]){
                    a.layer.borderColor = UIColor.red.cgColor
                    punteggioSbagliato += 1
                }else{
                    a.layer.borderColor = UIColor.green.cgColor
                    a.isEnabled = false
                    punteggio += 1
                }
                    break
                case 6...11:
                    if(Int(a.text!) != divisori[count]){
                        a.layer.borderColor = UIColor.red.cgColor
                        punteggioSbagliato += 1
                    }else{
                        a.layer.borderColor = UIColor.green.cgColor
                        a.isEnabled = false
                        punteggio += 1
                    }
                    break
                case 12...17:if(Int(a.text!) != risultati[count]){
                    a.layer.borderColor = UIColor.red.cgColor
                    punteggioSbagliato += 1
                }else{
                    a.layer.borderColor = UIColor.green.cgColor
                    a.isEnabled = false
                    punteggio += 1
                }
                    break
                    
                default: break
                }
            }
            controllo = false
            a.layer.borderWidth = 2
            a.layer.cornerRadius = 7
            count += 1
        }
        var img=""
        switch(punteggio){
        case 0...6: img = "stella_vuota"
            break
        case 6...11: img = "stella1"
            break
        case 11...17: img = "stella2"
            break
        case 18...23: img = "stella3"
            break
        case 24...29: img = "stella4"
            break
        case 30...35: img = "stella5"
            break
        case 36...42: img = "stella6"
            break
        default:break
        }
        labelPunteggio.text = "Il punteggio è: " + String(punteggio)
        immagineStelle.image = UIImage(named: img)
        immagineStelle.contentMode = .scaleAspectFit
        viewVincita.isHidden = false
        
        //Statistiche.aggiungi(forKey: .Due, num: punteggio)//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        punteggio = 0
        punteggioSbagliato = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}

func tastieraNumerica(risultatoTextField: Array<UITextField>,risultatoTextField2: Array<UITextField>){
    for a in risultatoTextField{
        a.keyboardType = UIKeyboardType.decimalPad
        a.layer.backgroundColor = UIColor.lightGray.cgColor
    }
    for a in risultatoTextField2{
        a.keyboardType = UIKeyboardType.decimalPad
        a.layer.backgroundColor = UIColor.lightGray.cgColor
    }
}

func carica(dividendiLabel: Array<UILabel>,divisoriLabel2: Array<UILabel>, risultatiLabel2: Array<UILabel>,dividendiLabel2: Array<UILabel>, risultatoTextField2: Array<UITextField> )
{
    var controllo = false //es 1------------------------------------------------------------------------
    var arr: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var countEs1 = 0, app = true
    
    for a in dividendiLabel
    {
        
       /* while(app){
            for b in 0...17{
                if(arr[b] == i && b != countEs1){
                    app = true
                    break
                }else{
                    app = false
                    arr[countEs1] = i
                    countEs1 += 1
                }
            }
            i = Int(arc4random_uniform(99)+1)
        }*/
        
        
            switch (a.tag){
            case 10: a.text = String(randomNumber()*10); break
            case 100: a.text = String(randomNumber()*100); break
            case 1000: a.text = String(randomNumber()*1000); break
            default: break
            }
        countEs1 += 1
    }
    var count = 0//es 2----------------------------------------------------------------------------------
    for _ in dividendi
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
    for a in divisoriLabel2{
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

func randomNumber() -> UInt32 {
    var randomNumber = arc4random_uniform(99)+1
    while previousNumber == randomNumber {
        randomNumber = arc4random_uniform(99)+1
    }
    previousNumber = randomNumber
    return randomNumber
}






