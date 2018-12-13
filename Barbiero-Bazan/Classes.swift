//
//  Classes.swift
//  matematica_3
//
//  Created by Giovanni Barbiero on 07/12/2018.
//  Copyright © 2018 Class_4AI. All rights reserved.
//

import UIKit

extension UIView {
    func GetFrameInRootView(rootView: UIView) -> CGRect{
        let newOrigin = GetOriginInRootView(rootView: rootView)
        return CGRect(x: newOrigin.x, y: newOrigin.y, width: self.frame.width, height: self.frame.height)
    }
    
    func GetOriginInRootView(rootView: UIView) -> CGPoint{
        return rootView.convert(self.frame.origin, from: self.superview)
    }
    
    func GetCenterInRootView(rootView: UIView) -> CGPoint{
        return rootView.convert(self.center, from: self.superview)
    }
    
    func AnimateTextWithImage(text s : String, image img : UIImage, time t : Double) {
        let view = UIView()
        view.frame = self.frame
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        self.addSubview(view)
        let label = UILabel()
        label.font = UIFont(name: "Noteworthy", size: 200)
        label.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        label.center = self.center
        label.textAlignment = .center
        label.text = s
        self.addSubview(label)
        label.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        view.alpha = 0
        label.alpha = 0
        
        UIView.animate(withDuration: 0.2, animations: {
            view.alpha = 1
            label.alpha = 1
        }) { (true) in
            UIView.animate(withDuration: t * (2 / 6), delay: 0, options: .curveLinear, animations: {
                label.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }) { (true) in
                UIView.animate(withDuration: t / 3, delay: 0, options: .curveLinear, animations: {
                    label.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }, completion: { (true) in
                    UIView.animate(withDuration: t * (2 / 6), delay: 0, options: .curveLinear, animations: {
                        label.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
                        label.alpha = 0
                    }, completion: { (true) in
                        UIView.animate(withDuration: 0.2, animations: {
                            view.alpha = 0
                        }, completion: { (true) in
                            label.removeFromSuperview()
                            view.removeFromSuperview()
                        })
                    })
                })
            }
        }
    }
}

enum StatoMano : String {
    case Aperta = "Hold"
    case Chiusa = "Drag"
    case Indice = "Select"
    case Click = "Click"
}

class Passaggio {
    let destinationView : UIView?
    let tempo : Double
    
    init(destinazione d : UIView?, tempo t : Double) {
        destinationView = d
        tempo = t
    }
    
    init() {
        destinationView = UIView()
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

class DragNumberImageView : UIImageView {
    
    var num : Int = 0
    
    var rootView = UIView()
    
    // view di origine del drag
    var originView = UIView()
    
    var destinationView = UIView()
    
    var currentView : UIView? = nil
    
    var isPickedUp = false
    
    var borderColor = UIColor.white
    
    init(originView origin: UIView, destinationView dest: UIView, rootView root: UIView, value n: Int) {
        super.init(frame: .zero)
        rootView = root
        originView = origin
        destinationView = dest
        num = n
        self.frame = originView.frame
        isPickedUp = true
        self.contentMode = .scaleAspectFill
        self.autoresizesSubviews = true
        self.layer.cornerRadius = 40
        self.clipsToBounds = true
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        rootView.addSubview(self)
        rootView.bringSubviewToFront(self)
        Move(toView: originView, withDuration: 0, withDelay: 0)
    }
    
    convenience init(originView origin: UIView, destinationView dest: UIView, rootView root: UIView, value n: Int, color c: UIColor) {
        self.init(originView: origin, destinationView: dest, rootView: root, value: n)
        borderColor = c
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func UpdateColor() {
        self.layer.borderWidth = 5
        self.layer.borderColor = borderColor.cgColor
    }
    
    func ClearColor() {
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    func Move(toView view: UIView, withDuration dur: Double, withDelay del: Double) {
        currentView = view
        UIView.animate(withDuration: dur, delay: del, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [],  animations: {
            self.center = view.GetCenterInRootView(rootView: self.rootView)
        }) { (true) in
            self.AnimateDrop()
        }
    }
    
    func AnimatePickUp() {
        if !isPickedUp {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
                self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.UpdateColor()
            }) { (true) in
                self.isPickedUp = true
            }
        }
    }
    
    func AnimateDrop() {
        if isPickedUp {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.8)
            currentView?.isHidden = true
            if currentView == originView {
                ClearColor()
            }
            else {
                UpdateColor()
            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
                self.transform = .identity
            }){ (true) in
                self.isPickedUp = false
                self.currentView?.isHidden = false
                self.AnimationEnded()
            }
        }
    }
    
    func AnimationEnded() {
        if !BarbieroBazan.instance!.helpViewOpen {
            BarbieroBazan.instance?.CheckIfAllDragged()
        }
    }
    
    func Duplicate() -> DragNumberImageView {
        return DragNumberImageView(originView: originView, destinationView: destinationView, rootView: rootView, value: num, color: borderColor)
    }
}
