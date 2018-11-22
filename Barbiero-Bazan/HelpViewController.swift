//
//  HelpViewController.swift
//  Barbiero-Bazan
//
//  Created by Giovanni Barbiero on 21/11/2018.
//  Copyright © 2018 Giovanni Barbiero. All rights reserved.
//

import UIKit

enum StatoMano : String {
    case Aperta = "Hold"
    case Chiusa = "Drag"
    case Indice = "Select"
    case Click = "Click"
}

class Passaggio {
    let destination : CGPoint
    let tempo : Double
    
    init(destinazione d : CGPoint, tempo t : Double) {
        destination = d
        tempo = t
    }
    
    init() {
        destination = CGPoint.zero
        tempo = 0
    }
}

class PassaggioMano {
    let passaggio : Passaggio
    let state : StatoMano
    
    init(passaggio p : Passaggio, stato s : StatoMano) {
        passaggio = p
        state = s
    }
    
    init() {
        passaggio = Passaggio()
        state = StatoMano.Aperta
    }
    
}

class Percorso {
    static var mano : [PassaggioMano] = {
        var per = [PassaggioMano]()
        // sposta mano su numero
        per.append(PassaggioMano())
        // prendi numero
        per.append(PassaggioMano())
        // sposta numero e mano su destinazione
        per.append(PassaggioMano())
        // lascia numero
        per.append(PassaggioMano())
        return per
    }()
    static var numero : [Passaggio] = {
        var per = [Passaggio]()
        // sposta mano su numero
        per.append(Passaggio())
        // prendi numero
        per.append(Passaggio())
        // sposta numero e mano su destinazione
        per.append(Passaggio())
        // lascia numero
        per.append(Passaggio())
        return per
    }()
}

class HelpViewController: UIViewController {

    @IBOutlet weak var handImageView: UIImageView!
    
    var numView = [DragNumberImageView]()
    
    var padre : BarbieroBazan?
    
    var working = true
    
    var currentAnimationIndex = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handImageView.alpha = 0
    }
    
    func addNumView(numView v : DragNumberImageView) {
        numView.append(v)
        v.layer.borderWidth = 3
        v.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(v)
        self.view.bringSubviewToFront(handImageView)
        
        handImageView.frame = CGRect(x: 0, y: 0, width: v.frame.width / 2, height: v.frame.height / 2)
        handImageView.center = self.view.center
    }
    
    func StartAnimation() {
        if working {
            // blur in di mano e numero
            UIView.animate(withDuration: 0.5, animations: {
                self.handImageView.alpha = 1
                //self.numView?.alpha = 1
            }) { (true) in
                self.Animate()
            }
        }
    }
    
    func Animate() {
        let per = Percorso.mano[currentAnimationIndex]
        currentAnimationIndex += 1
        
        UIView.animate(withDuration: per.passaggio.tempo, delay: 0.5, animations: {
            self.handImageView.center = per.passaggio.destination
            //self.numView?.center = per.passaggio.destination
            self.handImageView.image = UIImage(named: per.state.rawValue)
        }) { (true) in
            if self.currentAnimationIndex != Percorso.mano.count {
                self.Animate()
            }
            else {
                self.currentAnimationIndex = 0
                self.EndAnimation()
            }
        }
    }
    
    func EndAnimation() {
        // blur out e completed metti mano in posizione centrale e numero in posizione iniziale
        UIView.animate(withDuration: 0.5, animations: {
            self.handImageView.alpha = 0
            //self.numView?.alpha = 0
        }) { (true) in
            self.handImageView.center = self.view.center
            //self.numView?.center = (self.numView?.originView!.GetCenterInRootView(rootView: self.padre!.view))!
            self.StartAnimation()
        }
        
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        padre!.DismissHelpView()
    }
}
