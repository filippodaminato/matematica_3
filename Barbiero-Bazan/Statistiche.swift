//
//  Statistiche.swift
//  Barbiero-Bazan
//
//  Created by Giovanni Barbiero on 21/11/2018.
//  Copyright © 2018 Giovanni Barbiero. All rights reserved.
//

import UIKit

enum EsercizioKey : String {
    case Uno = "Esercizio1"
    case Due = "Esercizio2"
    case Tre = "Esercizio3"
    case Quattro = "Esercizio4"
    case Cinque = "Esercizio5"
    case Sei = "Esercizio6"
    case Sette = "Esercizio7"
    case Otto = "Esercizio8"
    case Nove = "Esercizio9"
}

class Statistiche {
    static func aggiungiGiusto(forKey key: EsercizioKey, num : Int) {
        let def = UserDefaults.standard
        let str = "Giusto" + key.rawValue
        let a = def.integer(forKey: str)
        def.set(a + num, forKey: str)
    }
    
    static func aggiungiGiusto(forKey key: EsercizioKey) {
        aggiungiGiusto(forKey: key, num: 1)
    }
    
    static func aggiungiSbagliato(forKey key: EsercizioKey, num : Int) {
        let def = UserDefaults.standard
        let str = "Sbagliato" + key.rawValue
        let a = def.integer(forKey: str)
        def.set(a + num, forKey: str)
    }
    
    static func aggiungiSbagliato(forKey key: EsercizioKey) {
        aggiungiSbagliato(forKey: key, num: 1)
    }
    
    static func getGiusti(forKey key : EsercizioKey) -> Int {
        let def = UserDefaults.standard
        return def.integer(forKey: "Giusto" + key.rawValue)
    }
    
    static func getSbagliati(forKey key : EsercizioKey) -> Int {
        let def = UserDefaults.standard
        return def.integer(forKey: "Sbagliato" + key.rawValue)
    }
}
