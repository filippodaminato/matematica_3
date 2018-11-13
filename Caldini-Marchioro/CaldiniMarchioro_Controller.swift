//
//  ViewController.swift
//  AppFranzi-Marchioro_Caldini
//
//  Created by Enrico Caldini on 26/09/18.
//  Copyright © 2018 Enrico Caldini. All rights reserved.
//

import UIKit

class CaldiniMarchioro_Controller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        createExcercises()
    }
    
    @IBOutlet var es4sx: UIView!
    
    //I segna posto servono ad ottenere posizione, larghezza e altezza del primo UIExcercise
    @IBOutlet weak var topLeftPlaceholder: UILabel!
    @IBOutlet weak var topRightPlaceholder: UILabel!
    @IBOutlet weak var botLeftPlaceholder: UILabel!
    
    private var _excercises : [UIExcercise] = []
    
    @IBAction func reset(_ sender: Any) {
        for ex in _excercises
        {
            ex.resetValues()
        }
    }
    
    @IBAction func check(_ sender: Any) {
        for ex in _excercises
        {
            ex.check()
        }
    }
    @IBAction func back(_ sender: Any) {
         self.dismiss(animated: true) {}
    }
    
    private func createExcercises() -> Void
    {
        let n = 8 //Numero di esercizi
        
        let leftOffset : CGFloat = topLeftPlaceholder.frame.minX //Distanza dal bordo sinistro
        var topOffset : CGFloat = topLeftPlaceholder.frame.minY  //Distanza dal bordo superiore
        
        //La larghezza è data dalla distanza tra i due segnaposto
        let width : CGFloat = topRightPlaceholder.frame.minX - topLeftPlaceholder.frame.minX
        let height : CGFloat = topLeftPlaceholder.frame.height
        
        //Distanza tra un UIExcercise ed un altro
        //Calcolata dividendo lo spazio vuoto tra il segnaposto superiore ed inferiore per il numero
        //di esercizi da creare - 1 (ci sono n - 1 "spazi vuoti" tra un esercizio e l'altro)
        let vertOffset =
            (botLeftPlaceholder.frame.maxY - topLeftPlaceholder.frame.minY - (height * CGFloat(n)))
                / CGFloat(n-1)
        
        for _ in 0..<n
        {
            let uiEx = UIExcercise(x: leftOffset, y: topOffset, width: width, height: height)
            uiEx.addToUIView(view: view)
            
            _excercises.append(uiEx)
            
            topOffset += uiEx.getHeight() + vertOffset
        }
    }
    
}

