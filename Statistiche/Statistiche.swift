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
    
    static private let giusto = "Giusto"
    static private let sbagliato = "Sbagliato"

    // aggiunge valore Giusto o Sbagliato in base a "key" nell'esercizio "k"
    static private func aggiungi(_ num : Int, key: String, forKey k: EsercizioKey) {
        let def = UserDefaults.standard
        let str = key + k.rawValue
        let old = def.integer(forKey: str)
        def.set(old + num, forKey: str)
        def.synchronize()
    }
    
    static func aggiungiGiusto(_ num : Int, forKey key: EsercizioKey) {
        aggiungi(num, key: giusto, forKey: key)
    }
    
    static func aggiungiGiusto(forKey key: EsercizioKey) {
        aggiungiGiusto(1, forKey: key)
    }
    
    static func aggiungiSbagliato(_ num : Int, forKey key: EsercizioKey) {
        aggiungi(num, key: sbagliato, forKey: key)
    }
    
    static func aggiungiSbagliato(forKey key: EsercizioKey) {
        aggiungiSbagliato(1, forKey: key)
    }
    
    // aggiungi giusti e sbagliato ad esercizio "k"
    static func aggiungi(giusti: Int, sbagliati: Int, forKey k: EsercizioKey) {
        aggiungiGiusto(giusti, forKey: k)
        aggiungiSbagliato(sbagliati, forKey: k)
    }
    
    // ottiene valore Giusto o Sbagliato in base a "key" nell'esercizio "k"
    static private func get(key: String, forKey k: EsercizioKey) -> Int {
        let def = UserDefaults.standard
        return def.integer(forKey: key + k.rawValue)
    }
    
    static func getGiusto(forKey key : EsercizioKey) -> Int {
        return get(key: giusto, forKey: key)
    }
    
    static func getSbagliato(forKey key : EsercizioKey) -> Int {
        return get(key: sbagliato, forKey: key)
    }
    
    // pulisce valore Giusto o Sbagliato in base a "key" nell'esercizio "k"
    static private func clear(key: String, forKey k: EsercizioKey) {
        let def = UserDefaults.standard
        def.set(0, forKey: key + k.rawValue)
        def.synchronize()
    }
    
    static func clearGiusto(forKey key : EsercizioKey) {
        clear(key: giusto, forKey: key)
    }
    
    static func clearSbagliato(forKey key : EsercizioKey) {
        clear(key: sbagliato, forKey: key)
    }
    
    // ottiene percentuale giusti
    static func getPercentualeGiusto(forKey k : EsercizioKey) -> Int {
        let giusti = getGiusto(forKey: k)
        let sbagliati = getSbagliato(forKey: k)
        // (giusti * 100) / (giusti + sbagliati)
        return Int((giusti * 100) / (giusti + sbagliati))
    }
    
    // ottiene percentuale sbagliati facendo la sottrazione
    static func getPercentualeSbagliato(forKey k : EsercizioKey) -> Int {
        return 100 - getPercentualeGiusto(forKey: k)
    }
}
