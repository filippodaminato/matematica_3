//
//  UIEsercizio.swift
//  AppFranzi-Marchioro_Caldini
//
//  Created by Enrico Caldini on 03/10/18.
//  Copyright © 2018 Enrico Caldini. All rights reserved.
//

import Foundation
import UIKit

class UIExcercise {
    private var _numSx : UILabel
    private var _segno : UIButton
    private var _numDx : UILabel
    private var _imgRisultato : UIImageView //Corretto.png - Sbagliato.png
    
    private var _width : CGFloat
    private var _height : CGFloat
    
    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        _width = width
        _height = height
        
        //Immagine e bottone devono essere quadrate
        let imgWidth = _height
        let btnWidth = _height
        
        //Distanza tra bottone e una label
        let btnDistance : CGFloat = 10
        
        //Visto che l'immagine ed il bottone hanno larghezza fissa,
        //divido la larghezza totale solo per 2 elementi (invece di 4), ovvero le Label
        //In questo modo le Label si comportano da "fill" per lo spazio rimanente
        let elementWidth = (width - imgWidth - btnWidth - btnDistance * 2) / 2
        
        _numSx = UILabel(frame: CGRect(x: x, y: y, width: elementWidth, height: height))
        _numSx.backgroundColor = UIColor.white
        _numSx.textAlignment = NSTextAlignment.center
        _numSx.layer.cornerRadius = 10
        _numSx.layer.masksToBounds = true
        
        _segno =
            UIButton(frame: CGRect(x: _numSx.frame.maxX + btnDistance, y: y, width: btnWidth, height: height))
        _segno.backgroundColor = UIColor.orange
        _segno.layer.cornerRadius = 7
        _segno.layer.masksToBounds = true
        _segno.contentMode = UIView.ContentMode.scaleToFill
        
        _numDx =
            UILabel(frame: CGRect(x: _segno.frame.maxX + btnDistance, y: y, width: elementWidth, height: height))
        _numDx.backgroundColor = UIColor.white
        _numDx.textAlignment = NSTextAlignment.center
        _numDx.layer.cornerRadius = 10
        _numDx.layer.masksToBounds = true
        
        _imgRisultato =
            UIImageView(frame: CGRect(x: _numDx.frame.maxX, y: y, width: imgWidth, height: height))
        
        _segno.addTarget(self, action: #selector(changeSign_OnButtonClick(sender:)), for: UIControl.Event.touchUpInside)
        
        //Assegna valori a label e bottone; nascondi UIImageView
        resetValues()
    }
    
    public func getHeight() -> CGFloat
    {
        return _height
    }
    
    public func getWidth() -> CGFloat
    {
        return _width
    }
    
    public func resetValues() -> Void
    {
        //Aggiorna valori di label, segni, nascondi UIImageView (RESET)
        _numSx.text = String(Int.random(in: 0...100))
        _numDx.text = String(Int.random(in: 0...100))
        
        _segno.setTitle("<", for: UIControl.State.normal)
        
        _imgRisultato.isHidden = true
    }
    
    public func check() -> Bool
    {
        //Controlla la correttezza del segno selezionato e mostra all'utente se è
        //corretto o meno tramite l'UIImageView
        
        //Il testo è sicuramente un numero, non sono necessari controlli
        let nSx = Int(_numSx.text!)
        let nDx = Int(_numDx.text!)
        let segno = _segno.currentTitle
        var corretto : Bool = false
        
        switch segno {
        case ">":
            corretto = nSx! > nDx!
        case "<":
            corretto = nSx! < nDx!
        case "=":
            corretto = nSx! == nDx!
        default:
            corretto = false
        }
        
        let image = corretto ? UIImage(named: "corretto_cm.png") : UIImage(named: "sbagliato_cm.png")
        _imgRisultato.image = image
        _imgRisultato.isHidden = false
        
        return corretto
    }
    
    public func addToUIView(view: UIView) -> Void
    {
        //Aggiungi tutte le subview tramite view.AddSubview(roba)
        view.addSubview(_numSx)
        view.addSubview(_segno)
        view.addSubview(_numDx)
        view.addSubview(_imgRisultato)
    }
    
    @objc private func changeSign_OnButtonClick(sender: UIButton) -> Void
    {
        //Cambia il segno in maniera circolare tra '>', '=' e '<'
        //ogni volta che il bottone viene cliccato
        switch sender.currentTitle {
        case ">":
            sender.setTitle("<", for: UIControl.State.normal)
        case "<":
            sender.setTitle("=", for: UIControl.State.normal)
        case "=":
            sender.setTitle(">", for: UIControl.State.normal)
        default:
            sender.setTitle("impossibile", for: UIControl.State.normal)
        }
    }
    
}
