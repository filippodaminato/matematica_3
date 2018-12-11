//
//  HelpViewController.swift
//  Barbiero-Bazan
//
//  Created by Giovanni Barbiero on 21/11/2018.
//  Copyright © 2018 Giovanni Barbiero. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    let helpTime = 1.5
    let solutionTime = 1.0

    @IBOutlet weak var handImageView: UIImageView!
    
    @IBOutlet weak var lblTitolo: UILabel!
    @IBOutlet weak var lblDescrizione: UILabel!
    
    let titoloText = ["Come si gioca?", "Soluzione corretta"]
    let descrizioneText = ["Prendi i numeri e mettili nelle posizioni giuste.", "Così è come l'esercizio avrebbe dovuto essere svolto."]
    
    var numView = [DragNumberImageView]()
    
    var working = true
    
    var currentAnimationIndex = 0
    
    var percorso = [PassaggioMano]()
    
    var initialViews = [UIView]()
    
    let instance = BarbieroBazan.instance!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if instance.gameEnded {
            lblTitolo.text = titoloText[1]
            lblDescrizione.text = descrizioneText[1]
            
        }
        else {
            lblTitolo.text = titoloText[0]
            lblDescrizione.text = descrizioneText[0]
            
        }
        CreatePersonalDragImageViews()
        UpdatePercorsi()
        EndAnimation()
    }
    
    func CreatePersonalDragImageViews() {
        for i in 0...3 {
            let v = instance.numbersViews[i].Duplicate()
            v.image = UIImage(named: "\(v.num)")
            numView.append(v)
            if instance.gameEnded {
                v.currentView = instance.numbersViews[i].currentView
//                if v.currentView == v.destinationView {
//                    v.UpdateColor()
//                }
//                else {
//                    v.ClearColor()
//                }
            }
            self.view.addSubview(v)
            initialViews.append(v.currentView!)
            v.center = (v.currentView?.GetCenterInRootView(rootView: instance.view))!
        }
        instance.ClearNumbersArray()
        handImageView.frame = CGRect(x: 0, y: 0, width: numView[0].frame.width / 2, height: numView[0].frame.height / 2)
        handImageView.center = self.view.center
        self.view.bringSubviewToFront(handImageView)
    }
    
    /**
     Creates the path that `helpView.handImageView` has to follow
     
     - Parameter c: is the current instance of `HelpViewController`
     */
    func UpdatePercorsi() {
        var retry = false
        for i in 0...3 {
            if instance.gameEnded {
                // creare percorso giusto per sistemare errori
                let val = UpdatePercorsiGiusti(index: i, tempo: solutionTime)
                if val {
                    retry = val
                }
            }
            else {
                UpdatePercorsiNumberView(index: i, tempo: helpTime)
            }
        }
        if retry {
            UpdatePercorsi()
        }
    }
    
    func UpdatePercorsiGiusti(index i : Int, tempo t: Double) -> Bool{
        var val = false
        if numView[i].currentView != numView[i].destinationView {
            // sposta mano su numero
            var tempo = t
            percorso.append(PassaggioMano(passaggio: Passaggio(destinazione: numView[i].currentView, tempo: tempo), stato: .Aperta, trasporta: nil))
            // prendi numero
            tempo = 0.2
            percorso.append(PassaggioMano(passaggio: Passaggio(destinazione: nil, tempo: tempo), stato: .Chiusa, trasporta: nil))
            tempo = t
            // check if destination is free
            if IsDestinationFree(destination: numView[i].destinationView) {
                // destination free, move there
                percorso.append(PassaggioMano(passaggio: Passaggio(destinazione: numView[i].destinationView, tempo: tempo), stato: .Chiusa, trasporta: numView[i]))
                numView[i].currentView = numView[i].destinationView
            }
            else {
                // destination occupied, return to origin
                percorso.append(PassaggioMano(passaggio: Passaggio(destinazione: numView[i].originView, tempo: tempo), stato: .Chiusa, trasporta: numView[i]))
                numView[i].currentView = numView[i].originView
                val = true
            }
            // lascia numero
            tempo = 0.2
            percorso.append(PassaggioMano(passaggio: Passaggio(destinazione: nil, tempo: tempo), stato: .Aperta, trasporta: nil))
        }
        return val
    }
    
    /**
     Adds the path that `helpView.handImageView` has to follow to move a number view
     
     - Parameters:
     - i: is the index to get the `DragImageView` instance from `c.numView`
     - c: is the current instance of `HelpViewController`
     */
    private func UpdatePercorsiNumberView(index i : Int, tempo t: Double) {
        // sposta mano su numero
        var tempo = t
        percorso.append(PassaggioMano(passaggio: Passaggio(destinazione: numView[i].currentView, tempo: tempo), stato: .Aperta, trasporta: nil))
        // prendi numero
        tempo = 0.2
        percorso.append(PassaggioMano(passaggio: Passaggio(destinazione: nil, tempo: tempo), stato: .Chiusa, trasporta: nil))
        // sposta numero e mano su destinazione
        tempo = t
        percorso.append(PassaggioMano(passaggio: Passaggio(destinazione: numView[i].destinationView, tempo: tempo), stato: .Chiusa, trasporta: numView[i]))
        // lascia numero
        tempo = 0.2
        percorso.append(PassaggioMano(passaggio: Passaggio(destinazione: nil, tempo: tempo), stato: .Aperta, trasporta: nil))
    }
    
    private func StartAnimation() {
        if working {
            // blur in di mano e numero
            UIView.animate(withDuration: 0.5, animations: {
                self.handImageView.alpha = 1
                for v in self.numView {
                    v.alpha = 1
                }
            }) { (true) in
                self.Animate(transporting: false, view: nil)
            }
        }
    }
    
    private func Animate(transporting : Bool, view : DragNumberImageView?) {
        var transp = false
        var transpView : DragNumberImageView? = nil
        let per = percorso[currentAnimationIndex]
        currentAnimationIndex += 1
        
        if let v = per.trasporta {
            self.view.bringSubviewToFront(v)
            v.AnimatePickUp()
            transp = true
            transpView = v
        }
        else if transporting {
            view?.AnimateDrop()
        }
        self.view.bringSubviewToFront(handImageView)
        
        UIView.animate(withDuration: per.passaggio.tempo, delay: 0.5, animations: {
            if let c = per.passaggio.destinationView {
                self.handImageView.center = c.GetCenterInRootView(rootView: self.instance.view)
                if let v = per.trasporta {
                    v.center = c.GetCenterInRootView(rootView: self.instance.view)
                    v.currentView = c
                }
            }
            self.handImageView.image = UIImage(named: per.state.rawValue)
        }) { (true) in
            if self.currentAnimationIndex != self.percorso.count {
                self.Animate(transporting: transp, view: transpView)
            }
            else {
                self.currentAnimationIndex = 0
                self.EndAnimation()
            }
        }
    }
    
    private func EndAnimation() {
        // blur out e completed metti mano in posizione centrale e numero in posizione iniziale
        UIView.animate(withDuration: 0.5, animations: {
            self.handImageView.alpha = 0
            for v in self.numView {
                v.alpha = 0
            }
        }) { (true) in
            self.handImageView.center = self.view.center
            for i in 0...3 {
                self.numView[i].center = self.initialViews[i].GetCenterInRootView(rootView: self.instance.view)
                self.numView[i].currentView = self.initialViews[i]
                if self.numView[i].currentView != self.numView[i].originView{
                    self.numView[i].UpdateColor()
                }
                else {
                    self.numView[i].ClearColor()
                }
            }
            self.StartAnimation()
        }
        
    }
    
    func IsDestinationFree(destination v : UIView) -> Bool{
        for i in 0...3 {
            if numView[i].currentView == v {
                return false
            }
        }
        return true
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        instance.DismissHelpView()
    }
}
