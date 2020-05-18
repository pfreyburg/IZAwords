//
//  Slovicko-viewcontrollers.swift
//  IZAwords
//
//  Created by Petr Freyburg on 24/03/2020.
//  Copyright © 2020 Petr Freyburg. All rights reserved.
//

import Foundation
import CoreData
import MHCoreData
import UIKit

// --------------------------------------------------------------------
//
extension Slovicko {
    
    //
    var detailVC: SlovickoDetailTable {
        //
        SlovickoDetailTable.Detail(forSlovicko: self)
    }
    
    static func listVC(_lekce: Lekce) -> SlovickoEvidence {
        return SlovickoEvidence.List(.listOfElements, _lekce: _lekce)
    }
}


// --------------------------------------------------------------------
//

class SlovickoBasicCell: MHTableCell {
    //
    override func selfConfig(with: Any) {
        //
        guard let _obj = with as? Slovicko else { fatalError() }
        
        //
        textLabel?.text = _obj.cz ?? "???"
    }
}

// --------------------------------------------------------------------
//
class SlovickoDetailTable : MHDetailTable {
    //
    var slovicko: Slovicko!
    var lekce : Lekce!
    
    //
    static func Detail(forSlovicko: Slovicko) -> SlovickoDetailTable {
        //
        let table = SlovickoDetailTable(sections: [])
        
        //
        table.slovicko = forSlovicko
        table.lekce = forSlovicko.lekce
        
        //
        return table
    }
    
    //
    @MHPublished(label: "Česky", defaultValue: "slovicko") var cz
    @MHPublished(label: "Anglicky", defaultValue: "word") var en
    
    //
    override var definedSections: [MHSectionDriver] {
        //
        [MHSectionDriver(staticCells:  [_cz.asERow]), MHSectionDriver(staticCells: [_en.asERow])]
    }
  
    //
    override func buttonOKAction() {
        //
        
        slovicko.cz = cz
        slovicko.en = en
        slovicko.lekce = lekce
        
        APP().saveContext()
    }
    
    override func detailStarted() {
        //
        cz = slovicko.cz ?? "slovicko"
        en = slovicko.en ?? "word"
    }
}



// --------------------------------------------------------------------
//
class SlovickoEvidence: MHTable {
    //
    public var lekce : Lekce!
    public var sections : [MHSectionDriver] = []
    public var slovicka : [Slovicko] = []
    
    override func event(selectedObject: Any?, section: MHSectionDriver,
                        ip: IndexPath)
    {
        //
        guard let _slovicko = selectedObject as? Slovicko else {
            //
            return
        }
        
        //
        if config.purpose == .selectionFromElements {
            //
            quitMe(responseToDelegate: .selected(_slovicko))
        } else {
            //
            push(_slovicko.detailVC)
        }
    }
    
    //
    override func buttonAddAction() {
        //
        let nc = MOC().allocSlovicko(lekce: lekce)
        
        //
        nc.cz = "slovicko"
        
        //
        push(nc.detailVC);
    }
    
    //
    static func List(_ purpose: MHTablePurpose, _lekce : Lekce!) -> SlovickoEvidence {
        //
        
        let fetchRequest = Slovicko.basicFRCFetch
        
        fetchRequest.predicate = Slovicko._byLekcePredicate(lekce: _lekce)
        let frc = MHFRC<Slovicko>(moc: MOC(),fetchRequest)
        let frcDatasource = MHFRCSectionDriver(frc, cellPrototype: "slovicko")!
        
        let fetchr = NSFetchRequest<Slovicko>(entityName: "Slovicko") // provedeni dotazu
        fetchr.predicate = Slovicko._byLekcePredicate(lekce: _lekce)
        
        let moc = MOC()
        var slovicka : [Slovicko] = []
        if let _results = try? moc.fetch(fetchr) {
            //
            for slovicko in _results{
                slovicka.append(slovicko) // uložení seznamu slovíček na později
            }
        }
        
        //
        let cfg = MHTableConfig(forPurpose: purpose)
        
        //
        let table = SlovickoEvidence(sections: [frcDatasource], cfg: cfg)
        table.slovicka = slovicka
        table.lekce = _lekce
        //
        table.tableView.register(SlovickoBasicCell.self,
                                 forCellReuseIdentifier: "slovicko")
        
        //
        return table
    }
    // mazání slovíček
    open override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            MOC().delete(self.slovicka[indexPath.row])
            try? MOC().save()
            tableView.reloadData()
            
            
        }
    }
}
