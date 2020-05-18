//
//  Lekce-viewcontrollers.swift
//  IZAwords
//
//  Created by Petr Freyburg on 30/03/2020.
//  Copyright © 2020 Petr Freyburg. All rights reserved.
//

import Foundation
import CoreData
import MHCoreData
import SwiftUI

enum typ_zkouseni : Int {
    case cz_en = 0
    case en_cz = 1
}

// --------------------------------------------------------------------
//


extension Lekce {
    //
    var detailVC: LekceDetailTable {
        //
        LekceDetailTable.Detail(forLekce: self)
    }
    
    //
    static var listVC: LekceEvidence {
        //
        LekceEvidence.List(.listOfElements)
    }
    
    //
    static var selectVC: LekceEvidence {
        //
        LekceEvidence.List(.selectionFromElements)
    }
    
    
}


// --------------------------------------------------------------------
//
class LekceBasicCell: MHTableCell {
    //
    override func selfConfig(with: Any) {
        //
        guard let _obj = with as? Lekce else { fatalError() }
        
        //
        textLabel?.text = _obj.name ?? "???"
    }
}

// --------------------------------------------------------------------
//
class LekceDetailTable : MHDetailTable {
    //
    var lekce: Lekce!
    
    //
    static func Detail(forLekce: Lekce) -> LekceDetailTable {
        //
        let table = LekceDetailTable(sections: [])
        
        //
        table.lekce = forLekce
        
        //
        return table
    }
    
    
    //
    @MHPublished(label: "Název", defaultValue: "Lekce") var name
    @MHPublished(label: "Slovíčka", defaultValue: "") var slovicka // otevře seznam slovíček dané lekce
    @MHPublished(label: "CZ -> EN", defaultValue: "") var zkouseniCZ_EN // spustí zkoušení CZ do EN slovíček
    @MHPublished(label: "EN -> CZ", defaultValue: "") var zkouseniEN_CZ // spustí zkoušení EN do CZ slovíček
    
    //
    override var definedSections: [MHSectionDriver] {
        //
        [MHSectionDriver(staticCells: [_name.asERow], header: "Název lekce"), // editovalný název lekce
         MHSectionDriver(staticCells: [_slovicka.asRow], header: "Seznam slovíček"),
         MHSectionDriver(staticCells: [_zkouseniCZ_EN.asRow], header: "Zkoušení"),
         MHSectionDriver(staticCells: [_zkouseniEN_CZ.asRow])
        ]
    }
    
    //
    override func buttonOKAction() {
        //
        lekce.name = name
        
        APP().saveContext()
    }
    
    override func detailStarted() {
        //
        name = lekce.name ?? ""
    }
    override func event(selected: MHSectionDriver, ip: IndexPath) {
        //
        switch ip.section {
        case 1:
            run(Slovicko.listVC(_lekce: lekce))
        case 2: // příprava zkoušení slovíček CZ -> EN
            fallthrough
        case 3: // EN -> CZ
            // získání všech slovíček dané lekce
            let moc = (UIApplication.shared.delegate as!
                AppDelegate).persistentContainer.viewContext
            // konstrukce dotazu -> template, vysledek [Student]
            let fetchr = NSFetchRequest<Slovicko>(entityName: "Slovicko") // provedeni dotazu
            fetchr.predicate = Slovicko._byLekcePredicate(lekce: lekce)
            if let _results = try? moc.fetch(fetchr) {
                //
                var slovicka : [String] = [] // pole slovíček
                var slovicka_vsechny : [Slovicko] = []
                let typ_zkouseni_p = ip.section == 2 ? typ_zkouseni.cz_en : typ_zkouseni.en_cz
                for slovicko in _results{
                   
                    slovicka_vsechny.append(slovicko)
                  
                    if ip.section == 2{ // CZ -> EN
                        if let _cz = slovicko.cz {
                            slovicka.append(_cz)
                        }
                    }else{ // EN -> CZ
                        if let _en = slovicko.en  {
                            slovicka.append(_en)
                        }
                    }
                }
                
                if slovicka.isEmpty { // pokud nejsou v lekci žádná slovíčka, zobrazí se alert
                    let a = UIAlertController(title: "Žádná slovíčka", message: "Musíte nejdříve přidat slovíčka!", preferredStyle: .alert)
                    a.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    present(a, animated: true)
                }else{ // jinak pokračujeme
                    
                    slovicka.shuffle() // zamichat slovicka
                    var vc : UIViewController
                    
                    vc = UIHostingController(rootView: Zkouseni(lekce_name: lekce.name ?? "", slovicka: slovicka, typ_zkouseni_jazyk: typ_zkouseni_p, slovicka_vsechny: slovicka_vsechny)) // příprava VC
                    
                    present(vc, animated: true, completion: nil) // zobrazeni VC
                }
            }
            
            
            
        default:
            ()
            
        }
    }
    // spust vc
    func run(_ vc: MHTable) {
        // nastavuju sebe na vcdelegata, tj pak dostanu zpravu
        // o vybrane polozce
        vc.vcDelegate = self
        
        // spusteni vc pres navigation-vc
        // slo by i modalne
        // present(vc, animated: true)
        // pak je treba ale nejak zajistit moznost ukoncit VC bez
        // navratove hodnoty
        push(vc)
    }
}



// --------------------------------------------------------------------
// Seznam všech lekcí
class LekceEvidence: MHTable {
    //
    override func event(selectedObject: Any?, section: MHSectionDriver,
                        ip: IndexPath)
    {
        //
        guard let _lekce = selectedObject as? Lekce else {
            //
            return
        }
        
        //
        if config.purpose == .selectionFromElements {
            //
            quitMe(responseToDelegate: .selected(_lekce))
        } else {
            //
            push(_lekce.detailVC)
        }
    }
    
    
    
    override func buttonAddAction() {
        //
        let nc = MOC().allocLekce()
        
        //
        nc.name = "Noname"
        
        //
        push(nc.detailVC);
    }
    
    //
    static func List(_ purpose: MHTablePurpose) -> LekceEvidence {
        //
        let frc = MHFRC<Lekce>(moc: MOC())
        let frcDatasource = MHFRCSectionDriver(frc, cellPrototype: "lekce")!
        
        //
        let cfg = MHTableConfig(forPurpose: purpose)
        
        //
        let table = LekceEvidence(sections: [frcDatasource], cfg: cfg)
        
        //
        table.tableView.register(LekceBasicCell.self,
                                 forCellReuseIdentifier: "lekce")
        
        //
        return table
    }
}

