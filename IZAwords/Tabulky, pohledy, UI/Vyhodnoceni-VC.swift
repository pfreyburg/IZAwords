//
//  Vyhodnoceni-VC.swift
//  IZAwords
//
//  Created by Petr Freyburg on 04/04/2020.
//  Copyright © Petr Freyburg. All rights reserved.
//

import Foundation
import CoreData
import MHCoreData
import SwiftUI
import UIKit

// struktura zodpovězeného slovíčka
struct Zodpovezene_slovicko : Hashable{
    let otazka : String
    let spravne : String
    let odpoved : String
}

// struktura informací o vyhodnoceném testu
struct Vyhodnoceni{
    let spatne : Int
    let nezodpovezeno : Int
    let vysledky : [Zodpovezene_slovicko]
}

class VyhodnoceniVC {
    
    let odpovedi : [String:String] // pole odpovědí o uživatele
    let typ_zkouseni_jazyk : typ_zkouseni // typ zkoušení (CZ -> EN nebo EN -> CZ)
    let slovicka : [Slovicko] // pole slovíček
    // init třídy s jejími parametry
    init(_odpovedi : [String : String], _typ_zkouseni_jazyk : typ_zkouseni, _slovicka : [Slovicko]) {
        
        self.odpovedi = _odpovedi
        self.typ_zkouseni_jazyk = _typ_zkouseni_jazyk
        self.slovicka = _slovicka
    }
    
    // provést vyhodnocení testu
    public func provest() -> Vyhodnoceni {
        
        var spatne = slovicka.count // nejdříve je vše špatně, pak se odečítají správné odpovědi
        var nezodpovezeno = slovicka.count
        var vysledky : [Zodpovezene_slovicko] = []
        for slovicko in self.slovicka {
            if self.typ_zkouseni_jazyk == typ_zkouseni.cz_en && odpovedi[slovicko.cz ?? ""] != nil{ // CZ -> EN
                nezodpovezeno -= 1
                if  odpovedi[slovicko.cz ?? ""]?.lowercased() == slovicko.en?.lowercased(){ // case insensitive
                    spatne -= 1
                }else { // špatně
                    vysledky.append(Zodpovezene_slovicko(otazka: slovicko.cz ?? "", spravne: slovicko.en ?? "", odpoved: odpovedi[slovicko.cz ?? ""]!))
                }
            }else if self.typ_zkouseni_jazyk == typ_zkouseni.en_cz && odpovedi[slovicko.en ?? ""] != nil  { // EN -> CZ
                 nezodpovezeno -= 1
                if odpovedi[slovicko.en ?? ""]?.lowercased() == slovicko.cz?.lowercased(){
                    spatne -= 1
                }else{ // špatně
                    vysledky.append(Zodpovezene_slovicko(otazka: slovicko.en ?? "", spravne: slovicko.cz ?? "", odpoved: odpovedi[slovicko.en ?? ""]!))
                }
            }
        }
        
        return Vyhodnoceni(spatne: spatne, nezodpovezeno: nezodpovezeno, vysledky: vysledky)
        
    }
}
