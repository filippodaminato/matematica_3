//
//  ViewController.swift
//  GiocoMatematica
//
//  Created by Danilo on 11/05/2018.
//  Copyright © 2018 UominiEDonne. All rights reserved.
//

import UIKit

var level = 2
var poss = 2
var arrayImm : [DraggableImageView] = []
var arrayImm2 : [UIImageView] = []
var arrayImm3 : [UIImageView] = []
var ImageViewSimbolini : [UIImageView] = []
var arrayChar : [String] = ["k", "h", "da", "u", "d", "c", "m"]
var risposte : [Bool] = [false, false, false, false, false, false, false]
var offset = 0
var lblGiusti : UILabel = UILabel.init()
var lblLivello : UILabel = UILabel.init()
var giafatto = false
var virgola : UIImageView = UIImageView.init()
var contErrori=0
var contGiustiTotali = 0
var width = CGFloat(0)
var height = CGFloat(0)

func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
    return CGRect(x: x, y: y, width: width, height: height)
}

func CGPointMake(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
    return CGPoint(x: x, y: y)
}

class ViewController: UIViewController{
    
    @IBOutlet weak var ErroriView: UIView!
    @IBOutlet weak var GiusteView: UIView!
    @IBOutlet weak var sfondoOutlet: UIImageView!
    @IBOutlet weak var lblGiuste: UILabel!
    @IBOutlet weak var lblErrori: UILabel!
    
    @IBAction func btnCheck(_ sender: Any) {
        
        for i in offset...level + offset - 1{
            if(!risposte[i]){
                contErrori+=1
                lblErrori.text = "Errori: " + String(contErrori)
                for i in 0...6{
                    risposte[i] = false
                }
                DisponiNumeri()
                return
            }
        }
        for i in 0...6{
            risposte[i] = false
        }
        contGiustiTotali+=1
        lblGiusti.text = "Giuste: " + String(contGiustiTotali)
        DisponiNumeri()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblGiusti = lblGiuste
        
        width = UIScreen.main.bounds.width
        height = UIScreen.main.bounds.height
        
        var numerino = 9
        
        if(UIApplication.shared.statusBarOrientation.isLandscape){
            numerino = 18
        }
        
        
        var pezzettino = (width * 13 / 100)
        
        var x = width / 9
        
        var lab : UIImageView = UIImageView.init()
        
        for i in 0...6{
            lab = UIImageView(frame: CGRectMake(0, 0, width * 9 / 100, height * 11 / 60))
            lab.center = CGPointMake(CGFloat(x), height * 7 / 10)
            self.view.addSubview(lab)
            ImageViewSimbolini.insert(lab, at: i)
            x = x + pezzettino
        }
        DisponiNumeri()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func corresponding(charr : String) -> Int{
        switch(charr){
        case "k": return 0;
        case "h": return 1;
        case "da": return 2;
        case "u": return 3;
        case "d": return 4;
        case "c": return 5;
        default: return 6;
        }
    }
    
    func DisponiNumeri(){
        
        if(giafatto)
        {
            for i in 0...level - 1{
                if(arrayImm[i] != nil){
                    arrayImm[i].isHidden = true
                    arrayImm2[i].isHidden = true
                    arrayImm3[i].isHidden = true
                }
            }
            virgola.isHidden = true
        }
        giafatto = true
        
        
        level = Int(arc4random_uniform(UInt32(7))) + 1
        
        if(level < 5){
            offset = (Int(arc4random_uniform(UInt32(poss))) + 4 - level)
        }
        else{
            offset = (Int(arc4random_uniform(UInt32(8-level))))
        }
        
        var array : [Int] = [0, 0, 0, 0, 0, 0, 0]
        
        array.insert(Int(arc4random_uniform(9) + 1), at: offset)
        if(level != 1){
            for i in offset + 1...(level + offset - 1)
            {
                array.insert(Int(arc4random_uniform(10)), at: Int(i))
            }
        }
        var a = 0, b = 0, c = ""
        
        for i in 0...99{
            a = Int(arc4random_uniform(7))
            b = Int(arc4random_uniform(7))
            c = arrayChar[a]
            arrayChar[a] = arrayChar[b]
            arrayChar[b] = c
        }
        
        var x = width / 4 + width / 10 * CGFloat(offset)
        
        var cont = 0
        
        for i in offset...offset + level - 1{
            if(i==4){
                virgola = UIImageView.init(frame: CGRectMake(0, 0, width / 1000 * 13, height / 1000 * 36))
                virgola.image = UIImage(named: "virgola.png")
                virgola.center = CGPointMake(CGFloat(Float(x)) - width / 97 * 5, height / 3)
                self.view.addSubview(virgola)
            }
            let label2 = UIImageView.init(image: UIImage(named: "retro.png"))
            label2.frame = CGRectMake(0, 0, width / 100 * 9, height / 100 * 16)
            label2.center = CGPointMake(CGFloat(Float(x)), height / 10 * 3)
            self.view.addSubview(label2)
            arrayImm3.insert(label2, at: cont)
            let label1 = UIImageView.init(image: (UIImage(named: String(array[i]) + ".png")))
            label1.frame = CGRectMake(0, 0, width / 100 * 7, height / 100 * 9)
            label1.center = CGPointMake(CGFloat(Float(x)), height / 10 * 3)
            self.view.addSubview(label1)
            arrayImm2.insert(label1, at: cont)
            let label = DraggableImageView.init(image: (UIImage(named: String(array[i]) + ".png")))
            label.frame = CGRectMake(0, 0, width / 100 * 7, height / 100 * 9)
            label.center = CGPointMake(CGFloat(Float(x)), height / 10 * 3)
            label.image = UIImage(named: String(array[i]) + ".png")
            label.tag = i
            self.view.addSubview(label)
            arrayImm.insert(label, at: cont)
            cont+=1
            x += width / 11
        }
        
        for i in 0...6{
            ImageViewSimbolini[i].image = UIImage(named: arrayChar[i] + ".png")
            ImageViewSimbolini[i].tag = corresponding(charr : arrayChar[i])
        }
    }
}

