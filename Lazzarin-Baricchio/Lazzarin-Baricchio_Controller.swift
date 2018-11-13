//
//  Lazzarin-Baricchio_Controller.swift
//  matematica_3
//
//  Created by Alex on 19/05/18.
//  Copyright © 2018 Class_4AI. All rights reserved.
//

import UIKit

class Lazzarin_Baricchio_Controller: UIViewController {

    var numero : Int = 0, nDiv : Int = 0
    var dividibili : [Int] = [], nonDivisori : [Int] = []
    var numeriSelezionati : [UIButton] = []
    
    @IBOutlet weak var numeroDaTrovare: UILabel!
    @IBOutlet weak var divisoriMancanti: UILabel!
    @IBOutlet var divisori: [UIButton]!
    @IBOutlet weak var tabella: UITableView!
    @IBOutlet weak var conclusione: UIView!
    
    @IBAction func back(_ sender: Any) {
         self.dismiss(animated: true) {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tabella.delegate = self
        tabella.dataSource = self
        caricaValori()
        tabella.backgroundColor = UIColor.lightGray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nuovaPartita(_ sender: Any) {
        caricaValori()
        numeriSelezionati.removeAll()
        tabella.reloadData()
        conclusione.isHidden = true
    }
    
    @IBAction func azioneDivisori(_ sender: Any) {
        let bottone = sender as! UIButton
        if !numeriSelezionati.contains(bottone){
            numeriSelezionati.insert(bottone, at: 0)
        }
        if(dividibili.contains(Int(bottone.title(for: .normal)!)!)){
            bottone.setBackgroundImage(#imageLiteral(resourceName: "Circle green"), for: .normal)
        }else{
            bottone.setBackgroundImage(#imageLiteral(resourceName: "Circle red"), for: .normal)
        }
        if(controllo()){
            conclusione.isHidden = false
        }
        divisoriMancantiFunc()
        tabella.reloadData()
    }
    
    private func controllo() -> Bool{
        for i in 0...divisori.count - 1{
            if(dividibili.contains(Int(divisori[i].title(for: .normal)!)!) && divisori[i].backgroundImage(for: .normal) == #imageLiteral(resourceName: "Circle blue")){
                return false
            }
        }
        return true
    }
    
    private func caricaValori(){
        nDiv = 0
        for i in 0...divisori.count - 1{
            divisori[i].setTitle("0", for: .normal)
            divisori[i].setBackgroundImage(#imageLiteral(resourceName: "Circle blue"), for: .normal)
        }
        dividibili.removeAll()
        nonDivisori.removeAll()
        var numeroDeiDivisori  = 0
        repeat{
            decidiValori()
            numeroDaTrovare.text = String(numero)
            numeroDeiDivisori = Int(arc4random_uniform(UInt32(dividibili.count - 2)) + 2)
            while 16 - numeroDeiDivisori == 0 {
                numeroDeiDivisori = Int(arc4random_uniform(UInt32(dividibili.count - 2)) + 2)
            }
        } while nonDivisori.count < 16 - numeroDeiDivisori
        carica(numero: numeroDeiDivisori, array: dividibili)
        carica(numero : 16 - numeroDeiDivisori, array: nonDivisori)
        divisoriMancantiFunc()
    }
    
    private func divisoriMancantiFunc(){
        var trovati = 0
        for item in divisori{
            if item.backgroundImage(for: .normal) == #imageLiteral(resourceName: "Circle green"){
                trovati += 1
            }
        }
        divisoriMancanti.text = String(nDiv - trovati)
    }
    
    private func decidiValori(){
        numero = Int(arc4random_uniform(84) + 16)
        for i in 1...numero{
            if(numero % i == 0){
                dividibili.append(i)
            }else{
                nonDivisori.append(i)
            }
        }
    }
    
    private func carica(numero : Int, array : [Int]){
        var array = array
        for _ in 1...numero{
            var pos = Int(arc4random_uniform(UInt32(array.count)))
            let valore = array[pos]
            array.remove(at: pos)
            pos  = Int(arc4random_uniform(UInt32(divisori.count)))
            while Int((divisori[pos].title(for: .normal))!) != 0{
                pos  = Int(arc4random_uniform(UInt32(divisori.count)))
            }
            divisori[pos].setTitle(String(valore), for: .normal)
            if dividibili.contains(valore){
                nDiv += 1
            }
        }
    }
}

//gestione della tabella delle statistiche
extension Lazzarin_Baricchio_Controller: UITableViewDelegate, UITableViewDataSource{
    
    //scelta numero righe
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numeriSelezionati.count
    }
    
    //carico delle celle
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabella.dequeueReusableCell(withIdentifier: "Cella") as! Cella
        //colore di background
        if numeriSelezionati[indexPath.row].backgroundImage(for: .normal) == #imageLiteral(resourceName: "Circle red"){
            cell.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.6)
        }else{
            cell.backgroundColor = UIColor(red: 0, green: 255, blue: 0, alpha: 0.6)
        }
        //carico elementi della cella
        let denominatore = Int(numeriSelezionati[indexPath.row].titleLabel!.text!)!
        cell.denominatore.text = String(denominatore)
        cell.numeratore.text = String(numero)
        cell.risulatato.text = String(numero / denominatore)
        cell.resto.text = String(numero % denominatore)
        return cell
    }
    
}
