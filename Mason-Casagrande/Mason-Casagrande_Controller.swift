//
//  ViewController.swift
//  Moltiplicazione
//
//  Created by BigHouse on 16/05/2018.
//  Copyright © 2018 BigHouse. All rights reserved.
//

import UIKit
import Foundation

class Mason_Casagrande_Controller: UIViewController {
    @IBOutlet var Zone: UIView!
    @IBOutlet weak var Stella1: UIImageView!
    @IBOutlet weak var Stella2: UIImageView!
    @IBOutlet weak var Stella3: UIImageView!
    @IBOutlet weak var Stella4: UIImageView!
    @IBOutlet weak var Stella5: UIImageView!
    @IBOutlet weak var Vittoria: UIView!
    @IBOutlet weak var Errories1: UILabel!
    @IBOutlet weak var Errories2: UILabel!
    
    @IBOutlet var arrayLabelD : Array<UILabel> = []
    @IBOutlet var arrayLabelC : Array<UILabel> = []
    @IBOutlet var arrayLabelM : Array<UILabel> = []
    
    @IBOutlet var arrayTextFieldD : Array<UITextField> = []
    @IBOutlet var arrayTextFieldC : Array<UITextField> = []
    @IBOutlet var arrayTextFieldM : Array<UITextField> = []
    
    @IBOutlet var arrayTextFieldQuizN : Array<UITextField> = []
    @IBOutlet var arrayTextFieldQuizMultiplier : Array<UITextField> = []
    @IBOutlet var arrayTextFieldQuizResult : Array <UITextField> = []
    
    var numero : [Int] = []
    var moltiplicatore : [Int] = []
    var result : [Int] = []
    var hiddenkeyboard = true
    var valorierraties1 = 0
    var valorierraties2 = 0
    var tentativies1 = 18
    var tentativies2 = 18
    var salvataggiovalories1 = true
    var salvataggiovalories2 = true
    var posizioneFinale : [CGPoint] = [
        CGPoint(x: 179, y: 213),
        CGPoint(x: 314, y: 213),
        CGPoint(x: 449, y: 213),
        CGPoint(x: 584, y: 213),
        CGPoint(x: 719, y: 213)
    ]
    var posizioneIniziale = CGPoint(x: 8, y: 647)
    
    @IBOutlet weak var Controlla: UIButton!
    @IBOutlet weak var Azzera: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        Vittoria.isHidden = true
        Controlla.isHidden = false
        self.AggiungiBottoneKeyboard()
        self.GeneraRandom()
        QuizRandom()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func AggiungiBottoneKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(Mason_Casagrande_Controller.ActionBottoneDone))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        var i = 0
        while i <= 5
        {
            self.arrayTextFieldD[i].inputAccessoryView = doneToolbar
            self.arrayTextFieldC[i].inputAccessoryView = doneToolbar
            self.arrayTextFieldM[i].inputAccessoryView = doneToolbar
            i = i + 1
        }
        
        i = 0
        while i<=17
        {
            self.arrayTextFieldQuizN[i].inputAccessoryView = doneToolbar
            self.arrayTextFieldQuizMultiplier[i].inputAccessoryView = doneToolbar
            self.arrayTextFieldQuizResult[i].inputAccessoryView = doneToolbar
            i = i + 1
        }
    }
    
    @objc func ActionBottoneDone() {
       
        var i = 0
        while i <= 5
        {
            self.arrayTextFieldD[i].resignFirstResponder()
            self.arrayTextFieldC[i].resignFirstResponder()
            self.arrayTextFieldM[i].resignFirstResponder()
            i = i + 1
        }
        i = 0
        while i<=17
        {
            self.arrayTextFieldQuizN[i].resignFirstResponder()
            self.arrayTextFieldQuizMultiplier[i].resignFirstResponder()
            self.arrayTextFieldQuizResult[i].resignFirstResponder()
            i = i + 1
        }
        if(hiddenkeyboard == false)
        {
            self.Zone.transform = CGAffineTransform.init(translationX: 0.0, y: 0.0)
            hiddenkeyboard = true
        }
        
    }
    
    func GeneraRandom()
    {
        var c = 0
        var numeriD : [Int] = [0,0,0,0,0,0]
        for item in arrayLabelD
        {
            var num = arc4random_uniform(1001)
            while (num == 0 || num == numeriD[0] || num == numeriD[1] || num == numeriD[2] || num == numeriD[3] || num == numeriD[4] || num == numeriD[5])
            {
                num = arc4random_uniform(1001)
            }
            numeriD[c] = Int(num)
            c = c + 1
            item.text = String(num)
        }
        c = 0
        var numeriC : [Int] = [0,0,0,0,0,0]
        for item in arrayLabelC
        {
            var num = arc4random_uniform(101)
            while (num == 0 || num == numeriC[0] || num == numeriC[1] || num == numeriC[2] || num == numeriC[3] || num == numeriC[4] || num == numeriC[5])
            {
                num = arc4random_uniform(101)
            }
            numeriC[c] = Int(num)
            c = c + 1
            item.text = String(num)
        }
        c = 0
        var numeriM : [Int] = [0,0,0,0,0,0]
        for item in arrayLabelM
        {
            var num = arc4random_uniform(11)
            while (num == 0 || num == numeriM[0] || num == numeriM[1] || num == numeriM[2] || num == numeriM[3] || num == numeriM[4] || num == numeriM[5])
            {
                num = arc4random_uniform(11)
            }
            numeriM[c] = Int(num)
            c = c + 1
            item.text = String(num)
        }
    }
    
    @IBAction func ControllaRis(_ sender: Any) {
        var cont = 0
        var randomD : [String] = ["","","","","",""]
        var randomC : [String] = ["","","","","",""]
        var randomM : [String] = ["","","","","",""]
        for item in arrayLabelD
        {
            randomD[cont] = item.text!
            cont = cont + 1
        }
        cont = 0
        for item in arrayLabelC
        {
            randomC[cont] = item.text!
            cont = cont + 1
        }
        cont = 0
        for item in arrayLabelM
        {
            randomM[cont] = item.text!
            cont = cont + 1
        }
        cont = 0
        
        var finaleD : [Int] = [0,0,0,0,0,0]
        var finaleC : [Int] = [0,0,0,0,0,0]
        var finaleM : [Int] = [0,0,0,0,0,0]
        for item in randomD
        {
            finaleD[cont] = (Int(item)! * 10)
            cont = cont + 1
        }
        cont = 0
        for item in randomC
        {
            finaleC[cont] = (Int(item)! * 100)
            cont = cont + 1
        }
        cont = 0
        for item in randomM
        {
            finaleM[cont] = (Int(item)! * 1000)
            cont = cont + 1
        }
        cont = 0
        
        var valoriD : [String] = ["","","","","",""]
        var valoriC : [String] = ["","","","","",""]
        var valoriM : [String] = ["","","","","",""]
        for item in arrayTextFieldD
        {
            valoriD[cont] = item.text!
            cont = cont + 1
        }
        cont = 0
        for item in arrayTextFieldC
        {
            valoriC[cont] = item.text!
            cont = cont + 1
        }
        cont = 0
        for item in arrayTextFieldM
        {
            valoriM[cont] = item.text!
            cont = cont + 1
        }
        cont = 0
        
        var sbagliato = false
        for item in valoriD
        {
            if (Int(item) != finaleD[cont])
            {
                if(item == "")
                {
                    sbagliato = true
                    arrayTextFieldD[cont].layer.borderWidth = 1
                    arrayTextFieldD[cont].layer.borderColor = UIColor.black.cgColor
                    cont = cont + 1
                }
                else
                {
                    sbagliato = true
                    arrayTextFieldD[cont].layer.borderWidth = 2
                    arrayTextFieldD[cont].layer.borderColor = UIColor.red.cgColor
                    cont = cont + 1
                    valorierraties1 = valorierraties1 + 1
                    tentativies1 = tentativies1 + 1
                }
            }
            else
            {
                arrayTextFieldD[cont].layer.borderWidth = 2
                arrayTextFieldD[cont].layer.borderColor = UIColor.green.cgColor
                cont = cont + 1
            }
        }
        cont = 0
        for item in valoriC
        {
            if (Int(item) != finaleC[cont])
            {
                if(item == "")
                {
                    sbagliato = true
                    arrayTextFieldC[cont].layer.borderWidth = 1
                    arrayTextFieldC[cont].layer.borderColor = UIColor.black.cgColor
                    cont = cont + 1
                }
                else
                {
                    sbagliato = true
                    arrayTextFieldC[cont].layer.borderWidth = 2
                    arrayTextFieldC[cont].layer.borderColor = UIColor.red.cgColor
                    cont = cont + 1
                    valorierraties1 = valorierraties1 + 1
                    tentativies1 = tentativies1 + 1
                }
            }
            else
            {
                arrayTextFieldC[cont].layer.borderWidth = 2
                arrayTextFieldC[cont].layer.borderColor = UIColor.green.cgColor
                cont = cont + 1
            }
        }
        cont = 0
        for item in valoriM
        {
            if (Int(item) != finaleM[cont])
            {
                if(item == "")
                {
                    sbagliato = true
                    arrayTextFieldM[cont].layer.borderWidth = 1
                    arrayTextFieldM[cont].layer.borderColor = UIColor.black.cgColor
                    cont = cont + 1
                }
                else
                {
                    sbagliato = true
                    arrayTextFieldM[cont].layer.borderWidth = 2
                    arrayTextFieldM[cont].layer.borderColor = UIColor.red.cgColor
                    cont = cont + 1
                    valorierraties1 = valorierraties1 + 1
                    tentativies1 = tentativies1 + 1
                }
            }
            else
            {
                arrayTextFieldM[cont].layer.borderWidth = 2
                arrayTextFieldM[cont].layer.borderColor = UIColor.green.cgColor
                cont = cont + 1
            }
        }
        Errories1.text = ("ERRORI: " + (String)(valorierraties1))
        if (sbagliato != true)
        {
            Errories1.text = ("ERRORI: " + (String)(valorierraties1) + " / " + (String)(tentativies1))
            Statistiche.aggiungiGiusto(.9,num: tentativies1 - valorierraties1)
            Statistiche.aggiungiSbagliato(.9,num: tentativies1 - 18)
            valorierraties1 = 0
            tentativies1 = 18
            Controlla.isHidden = true
            Azzera.isHidden = false
            Vittoria.isHidden = false
            Animazione()
        }
    }
    
    @IBAction func ChiudiFinestraVittoria(_ sender: UIButton) {
        Vittoria.isHidden = true
    }
    
    @IBAction func NuovoRandom(_ sender: Any) {
        Errories1.text = "ERRORI:"
        for item in arrayTextFieldD
        {
            item.layer.borderWidth = 0
            item.layer.borderColor = UIColor.black.cgColor
            item.text = ""
        }
        for item in arrayTextFieldC
        {
            item.layer.borderWidth = 0
            item.layer.borderColor = UIColor.black.cgColor
            item.text = ""
        }
        for item in arrayTextFieldM
        {
            item.layer.borderWidth = 0
            item.layer.borderColor = UIColor.black.cgColor
            item.text = ""
        }
        self.GeneraRandom()
        Controlla.isHidden = false
    }

func QuizRandom() //Creazione numeri randomici Es parti mancanti
{
    var moltiplicatori : [Int] = [10,100,1000];
    
    var i = 0
    while (i<=17)//numero del quiz
        
    {
        let randomNum = (Int)(arc4random_uniform(100)+1)
        numero.insert(randomNum, at: i)//vado ad inserirlo nell'array dei numeri
        let randomMolt = (Int)(arc4random_uniform(3)+0)
        moltiplicatore.insert(moltiplicatori[randomMolt], at: i)
        var risultato = randomNum * moltiplicatori[randomMolt]
        result.insert(risultato, at: i)
        if(i<=5)
        {
            arrayTextFieldQuizResult[i].text = (String)(result[i])
            arrayTextFieldQuizResult[i].isEnabled = false
            arrayTextFieldQuizMultiplier[i].text = (String)(moltiplicatore[i])
            arrayTextFieldQuizMultiplier[i].isEnabled = false
        }
        else if(i>5&&i<=11)
        {
            arrayTextFieldQuizResult[i].text = (String)(result[i])
            arrayTextFieldQuizResult[i].isEnabled = false
            arrayTextFieldQuizN[i].text = (String)(numero[i])
            arrayTextFieldQuizN[i].isEnabled = false
        }
        else if(i>11&&i<=17)
        {
            arrayTextFieldQuizN[i].text = (String)(numero[i])
            arrayTextFieldQuizN[i].isEnabled = false
            arrayTextFieldQuizMultiplier[i].text = (String)(moltiplicatore[i])
            arrayTextFieldQuizMultiplier[i].isEnabled = false
        }
        i = i + 1
    }
}
    
    @IBAction func checkButtonQuiz(_ sender: Any) { //Controllo risposte utente con i valori generati
        var  i = 0
        var controlla = false
        for item in arrayTextFieldQuizN
        {
            if(item.isEnabled == true)
            {
            if(item.text == (String)(numero[i]))
            {
                item.layer.borderWidth = 2
                item.layer.borderColor = UIColor.green.cgColor
            }
            else
            {
                if(item.text == "")
                {
                    item.layer.borderWidth = 1
                    item.layer.borderColor = UIColor.black.cgColor
                    controlla = true
                }
                else
                {
                    item.layer.borderWidth = 2
                    item.layer.borderColor = UIColor.red.cgColor
                    controlla = true
                    valorierraties2 = valorierraties2 + 1
                    tentativies2 = tentativies2 + 1
                }
            }
            }
            i = i + 1
        }
        i = 0
        
        for item in arrayTextFieldQuizMultiplier
        {
            if(item.isEnabled == true)
            {
            if(item.text == (String)(moltiplicatore[i]))
            {
                item.layer.borderWidth = 2
                item.layer.borderColor = UIColor.green.cgColor
            }
            else
            {
                if(item.text == "")
                {
                    item.layer.borderWidth = 1
                    item.layer.borderColor = UIColor.black.cgColor
                    controlla = true
                }
                else
                {
                    item.layer.borderWidth = 2
                    item.layer.borderColor = UIColor.red.cgColor
                    controlla = true
                    valorierraties2 = valorierraties2 + 1
                    tentativies2 = tentativies2 + 1
                }
            }
            }
            i = i + 1
        }
        i = 0
        for item in arrayTextFieldQuizResult
        {
            if(item.isEnabled == true)
            {
            if(item.text == (String)(result[i]))
            {
                item.layer.borderWidth = 2
                item.layer.borderColor = UIColor.green.cgColor
            }
            else
            {
                if(item.text == "")
                {
                    item.layer.borderWidth = 1
                    item.layer.borderColor = UIColor.black.cgColor
                    controlla = true
                }
                else
                {
                    item.layer.borderWidth = 2
                    item.layer.borderColor = UIColor.red.cgColor
                    controlla = true
                    valorierraties2 = valorierraties2 + 1
                    tentativies2 = tentativies2 + 1
                }
            }
            }
            i = i + 1
        }
        Errories2.text = ("ERRORI: " + (String)(valorierraties2))
        if(controlla != true)
        {
            Errories2.text = ("ERRORI: " + (String)(valorierraties2) + " / " + (String)(tentativies2))
            Statistiche.aggiungiGiusto(.9,num: tentativies2 - valorierraties2)
            Statistiche.aggiungiSbagliato(.9,num: tentativies2 - 18)
            valorierraties2 = 0
            tentativies2 = 18
            Vittoria.isHidden = false
            Animazione()
            buttonQuizNew.isHidden = false
            CheckButton.isHidden = true
        }
    }
    @IBOutlet weak var buttonQuizNew: UIButton!
    @IBOutlet weak var CheckButton: UIButton!
    
    @IBAction func buttonQuizNew(_ sender: Any) {
        Errories2.text = "ERRORI:"
        CheckButton.isHidden = false
        for item in arrayTextFieldQuizN
        {
            if(item.isEnabled == true)
            {
                item.text = nil
                item.isEnabled = true
                item.layer.borderWidth = 1
                item.layer.borderColor = UIColor.black.cgColor
            }
        }
        
        for item in arrayTextFieldQuizMultiplier
        {
            if(item.isEnabled == true)
            {
                item.text = nil
                item.isEnabled = true
                item.layer.borderWidth = 1
                item.layer.borderColor = UIColor.black.cgColor
            }
        }
        
        for item in arrayTextFieldQuizResult
        {
            if(item.isEnabled == true)
            {
                item.text = nil
                item.isEnabled = true
                item.layer.borderWidth = 1
                item.layer.borderColor = UIColor.black.cgColor
            }
        }
        numero.removeAll()
        moltiplicatore.removeAll()
        result.removeAll()
        QuizRandom()
    }
    
    @IBAction func MovetheView(_ sender: Any) {
        if(hiddenkeyboard == true)
        {
            self.Zone.transform = CGAffineTransform.init(translationX: 0.0, y: -400)
            hiddenkeyboard = false
        }
    }
    @objc func keyboardWillDisappear(_notification: NSNotification)
    {
        if(hiddenkeyboard == false)
        {
            self.Zone.transform = CGAffineTransform.init(translationX: 0.0, y: 0.0)
            hiddenkeyboard = true
        }
    }
   
    func Animazione() {
        Stella1.frame.origin = posizioneIniziale
        Stella2.frame.origin = posizioneIniziale
        Stella3.frame.origin = posizioneIniziale
        Stella4.frame.origin = posizioneIniziale
        Stella5.frame.origin = posizioneIniziale
        UIView.animate(withDuration: 1, animations: {
            self.Stella1.frame.origin = self.posizioneFinale[0]
            self.Stella2.frame.origin = self.posizioneFinale[1]
            self.Stella3.frame.origin = self.posizioneFinale[2]
            self.Stella4.frame.origin = self.posizioneFinale[3]
            self.Stella5.frame.origin = self.posizioneFinale[4]
        })
    }
    @IBAction func `return`(_ sender: Any) {
        self.dismiss(animated: true) {}
        
    }
    
}
