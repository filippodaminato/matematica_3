//
//  ViewController.swift
//  Trova Multipli
//
//  Created by Mello on 16/05/2018.
//  Copyright © 2018 MelloCompany. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var listaNumeri = [9, 13, 56, 18, 36, 6, 2, 52]
    var base = 9
    var contatoreMultipliCorretti = 0
    var contatoreBottoniGiusti = 0
    var numeriIndovinati = 0
    var punteggio = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        riempiInsieme()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func generaRandom()
    {
        base = Int(arc4random()%12)
        while base == 0 {
            base = Int(arc4random()%12)
        }
        
        outletPunteggio.text = String(punteggio)
        outletNumeroGenerato.text = String(base)
        for i in 0 ..< 8 {
            var numero = Int(arc4random()%9)
            while numero == 0 {
                numero = Int(arc4random()%9)
            }
            listaNumeri[i] = numero
        }
        
        for i in 0 ..< 4 {
            var posizione = Int(arc4random() % 8)
            if(posizione == 0)
            {
                listaNumeri[posizione] = base * 2
            }
            else
            {
                listaNumeri[posizione] = base * posizione
            }
        }
        riempiInsieme()
        quantiMultipli()
    }
    
    func quantiMultipli()
    {
        for i in 0 ..< 8 {
            if(listaNumeri[i] % base == 0)
            {
                contatoreMultipliCorretti += 1
            }
        }
    }
    
    func riempiInsieme()
    {
        outletNumeroGenerato.text = String(base)
        outlet1.setTitle(String(listaNumeri[0]), for: .normal)
        outlet1.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        outlet1.tag = listaNumeri[0]
        outlet2.setTitle(String(listaNumeri[1]), for: .normal)
        outlet2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        outlet2.tag = listaNumeri[1]
        outlet3.setTitle(String(listaNumeri[2]), for: .normal)
        outlet3.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        outlet3.tag = listaNumeri[2]
        outlet4.setTitle(String(listaNumeri[3]), for: .normal)
        outlet4.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        outlet4.tag = listaNumeri[3]
        outlet5.setTitle(String(listaNumeri[4]), for: .normal)
        outlet5.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        outlet5.tag = listaNumeri[4]
        outlet6.setTitle(String(listaNumeri[5]), for: .normal)
        outlet6.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        outlet6.tag = listaNumeri[5]
        outlet7.setTitle(String(listaNumeri[6]), for: .normal)
        outlet7.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        outlet7.tag = listaNumeri[6]
        outlet8.setTitle(String(listaNumeri[7]), for: .normal)
        outlet8.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        outlet8.tag = listaNumeri[7]
    }
    
    func verificaImmissione(numero: Int, bottone: UIButton)
    {
        if(numero % base == 0)
        {
            bottone.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            contatoreBottoniGiusti += 1
        }
        else
        {
            let messaggio = String(format: "Il numero che hai toccato non era un multiplo di %2d", base)
            let alert = UIAlertController(title: "Attento...", message: messaggio, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok, riproviamo", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            generaRandom()
        }
        if(contatoreMultipliCorretti == contatoreBottoniGiusti)
        {
            let alert = UIAlertController(title: "Bravo!", message: "Sei passato al prossimo round...", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            punteggio += 1
            outletPunteggio.text = String(punteggio)
            generaRandom()
        }
    }
    
    func selezionato(bottone : UIButton, numero : Int)
    {
        bottone.backgroundColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
        bottone.tag = numero
    }

    @IBAction func num1(_ sender: UIButton) {
        verificaImmissione(numero: sender.tag, bottone: sender)
    }
    @IBAction func num2(_ sender: UIButton) {
        verificaImmissione(numero: sender.tag, bottone: sender)
    }
    @IBAction func num3(_ sender: UIButton) {
        verificaImmissione(numero: sender.tag, bottone: sender)
    }
    @IBAction func num4(_ sender: UIButton) {
        verificaImmissione(numero: sender.tag, bottone: sender)
    }
    @IBAction func num5(_ sender: UIButton) {
        verificaImmissione(numero: sender.tag, bottone: sender)
    }
    @IBAction func num6(_ sender: UIButton) {
        verificaImmissione(numero: sender.tag, bottone: sender)
    }
    @IBAction func num7(_ sender: UIButton) {
        verificaImmissione(numero: sender.tag, bottone: sender)
    }
    @IBAction func num8(_ sender: UIButton) {
        verificaImmissione(numero: sender.tag, bottone: sender)
    }
    
    @IBOutlet weak var outletNumeroGenerato: UILabel!
    @IBOutlet weak var outletPunteggio: UILabel!
    @IBOutlet weak var outlet1: UIButton!
    @IBOutlet weak var outlet2: UIButton!
    @IBOutlet weak var outlet3: UIButton!
    @IBOutlet weak var outlet4: UIButton!
    @IBOutlet weak var outlet5: UIButton!
    @IBOutlet weak var outlet6: UIButton!
    @IBOutlet weak var outlet7: UIButton!
    @IBOutlet weak var outlet8: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

