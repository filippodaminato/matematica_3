//
//  ViewController.swift
//  Math_FrazioniComplementari
//
//  Created by a on 11/05/18.
//  Copyright © 2018 xia. All rights reserved.
//

import UIKit

class Bonaldo_Xia_ViewController: UIViewController {

    /*@IBAction func insNum(_ sender: Any) {
    }
    @IBAction func insDenom(_ sender: Any) {
    }
    @IBAction func insEuro(_ sender: Any) {
    }*/
    
    //usare array di label e textboc
    //es1
    @IBOutlet var numeratori: [UILabel]!
    @IBOutlet var denominatori: [UILabel]!
    @IBOutlet var numeratoriRisultato: [UILabel]!
    @IBOutlet var denominatoreRisultato: [UILabel]!
    @IBOutlet var numeratoriUtente: [UITextField]!
    @IBOutlet var denominatoreUtente: [UITextField]!
    @IBOutlet var resultImg1: [UIImageView]!
    //es2
    @IBOutlet var addendo: [UILabel]!
    @IBOutlet var addendoUtente: [UITextField]!
    @IBOutlet var somma: [UILabel]!
    @IBOutlet var resultImg2: [UIImageView]!
    //bottoni
    @IBOutlet weak var rResult: UILabel! //forse non serve
    @IBOutlet weak var lblPuntgg: UILabel!
    @IBOutlet weak var checkControl: UIButton!
    
    @IBAction func back(_ sender: Any) {
         self.dismiss(animated: true) {}
    }
    @IBAction func chkControllo(_ sender: Any) {//controllo
        pts = 0
        errori = 0
       
        for i in 0...5
        {
            if(Int(numeratori[i].text!)! + Int(numeratoriUtente[i].text!)! == Int(denominatori[i].text!)! && Int(denominatori[i].text!)! == Int(denominatoreUtente[i].text!)!)
            {
                resultImg1[i].image = UIImage(named: "yup.png")
                corretto();
            }
            else
            {
                resultImg1[i].image = UIImage(named: "nope.png")
                errore();
            }
            resultImg1[i].isHidden = false
        }
        
        for j in 0...8
        {
            if(Double(addendo[j].text!)! + Double(addendoUtente[j].text!)! == Double(somma[j].text!)!)
            {
                resultImg2[j].image = UIImage(named: "yup.png")
                corretto();
            }
            else
            {
                resultImg2[j].image = UIImage(named: "nope.png")
                errore();
            }
            resultImg2[j].isHidden = false
        }
    }
    
    
    @IBAction func ricomincia(_ sender: Any) {
        pulisci()
        creaNuovo()
        creaNuovo2()
    }
    
    var insDen = [Int]()
    var n = 0
    var pts = 0
    var errori = 0;
    var insSoldi = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        insDen.append(10)
        insDen += [100, 1000]
        
        insSoldi.append(1.00)
        insSoldi += [2.00, 5.00]
        
        creaNuovo()
        creaNuovo2()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func creaNuovo(){
        for i in 0...5
        {
            n = Int(arc4random_uniform(3))
            denominatori[i].text = String(insDen[n])
            numeratori[i].text = String(arc4random_uniform(UInt32(denominatori[i].text!)!))
            numeratoriRisultato[i].text = denominatori[i].text
            denominatoreRisultato[i].text = denominatori[i].text
            //numeratoriUtente[i].text = String(Int(numeratoriRisultato[i].text!)! - Int(numeratori[i].text!)!)
            //denominatoreUtente[i].text = String(Int(denominatori[i].text!)!)
        }
    }
    
    func creaNuovo2(){ //0.31+0.69=1 //rimettere i numeri dopo lo zero
        for i in 0...8
        {
            let app = Int(arc4random_uniform(100))
            let rand = Int(arc4random_uniform(UInt32(app)))
            somma[i].text = String(app)
            addendo[i].text = String(rand)
            //addendoUtente[i].text = String(Double(somma[i].text!)! - Double(addendo[i].text!)!)
        }
    }
    
    func pulisci(){
        pts = 0
        errori = 0
        lblPuntgg.text = "_______________";
        
        for i in 0...5
        {
            denominatoreUtente[i].text = "0"
            numeratoriUtente[i].text = "0"
            resultImg1[i].isHidden = true
        }
        for i in 0...8
        {
            addendoUtente[i].text = "0"
            resultImg2[i].isHidden = true
        }
    }
    
    func randomDouble(min: Double, max: Double) -> Double {
        return (Double(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
    
    func corretto()
    {
        //rResult.text = "CORRETTO!"
        pts = pts + 1
        lblPuntgg.text = ("Corretti "+String(pts) + " Sbagliati " + String(errori))
    }
    
    func errore()
    {
        //rResult.text = "Ops, sbagliato"
        errori = errori + 1
        lblPuntgg.text = ("Corretti "+String(pts) + " Sbagliati " + String(errori))
    }
}
