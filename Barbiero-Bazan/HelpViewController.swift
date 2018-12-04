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
    let destinationCenter : CGPoint?
    let tempo : Double
    
    init(destinazione d : CGPoint?, tempo t : Double) {
        destinationCenter = d
        tempo = t
    }
    
    init() {
        destinationCenter = CGPoint.zero
        tempo = 0
    }
}

class PassaggioMano {
    let passaggio : Passaggio
    let state : StatoMano
    let trasporta : DragNumberImageView?
    
    init(passaggio p : Passaggio, stato s : StatoMano, trasporta t : DragNumberImageView?) {
        passaggio = p
        state = s
        trasporta = t
    }
    
    init() {
        passaggio = Passaggio()
        state = StatoMano.Aperta
        trasporta = nil
    }
}

class Percorso {
    static var mano = [PassaggioMano]()
}

class HelpViewController: UIViewController {

    @IBOutlet weak var handImageView: UIImageView!
    
    var numView = [DragNumberImageView]()
    
    var padre : BarbieroBazan?
    
    var working = false
    
    var currentAnimationIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handImageView.alpha = 0
    }
    
    func addNumView(numView v : DragNumberImageView) {
        numView.append(v)
        self.view.addSubview(v)
        self.view.bringSubviewToFront(handImageView)
        
        if !working {
            working = true
            handImageView.frame = CGRect(x: 0, y: 0, width: v.frame.width / 2, height: v.frame.height / 2)
            handImageView.center = self.view.center
        }
    }
    
    func StartAnimation() {
        if working {
            for v in numView {
                v.layer.borderWidth = 3
                v.layer.borderColor = UIColor.black.cgColor
            }
            // blur in di mano e numero
            UIView.animate(withDuration: 0.5, animations: {
                self.handImageView.alpha = 1
                for v in self.numView {
                    v.alpha = 1
                }
            }) { (true) in
                self.Animate()
            }
        }
    }
    
    func Animate() {
        let per = Percorso.mano[currentAnimationIndex]
        currentAnimationIndex += 1
        
        UIView.animate(withDuration: per.passaggio.tempo, delay: 0.5, animations: {
            if let c = per.passaggio.destinationCenter {
                self.handImageView.center = c
                if let v = per.trasporta {
                    v.center = c
                }
            }
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
            for v in self.numView {
                v.alpha = 0
            }
        }) { (true) in
            self.handImageView.center = self.view.center
            for v in self.numView {
                v.center = (v.originView?.GetCenterInRootView(rootView: self.padre!.view))!
            }
            self.StartAnimation()
        }
        
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        padre!.DismissHelpView()
    }
}
