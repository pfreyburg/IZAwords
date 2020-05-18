//
//  GlobalCDModel.swift
//  IZA-CoreData-1
//
//  Created by Martin Hruby on 19/03/2020.
//  Copyright © 2020 Martin Hruby FIT. All rights reserved.
//

import Foundation
import CoreData

// --------------------------------------------------------------------
// Datove operace provadime nad MOC, tak celkem dava smysl si o ne
// rozsirit MOC.
// --------------------------------------------------------------------
// Zasada 1: snazte se objekty alokovat na jednom miste v programu
// tj. system metod allocXY()
// Zasada 2: stoji za uvahu uplne nepovazovat MOC() za globalni prvek
// (muzeme obecne uvazovat praci viewcontrolleru v ruznych MOC)
// (lze zatim ignorovat...)
// Zasada 3: ...
extension NSManagedObjectContext {
    // ----------------------------------------------------------------
    
    // ----------------------------------------------------------------
    //
    func allocCustomer() -> Slovicko {
        //
        let _cust = Slovicko(initialized: self)
        
        //
        return _cust
    }
    
    func allocLekce() -> Lekce {
           //
           let _lekce = Lekce(initialized: self)
           
           //
           return _lekce
       }
    func allocSlovicko(lekce: Lekce) -> Slovicko {
             //
             let _slovicko = Slovicko(initialized: self)
             _slovicko.lekce = lekce
             
             //
             return _slovicko
         }
    
}
