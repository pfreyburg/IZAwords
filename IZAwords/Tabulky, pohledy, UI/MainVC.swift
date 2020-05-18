//
//  MainVC.swift
//  IZA-CoreData-1
//
//  Created by Martin Hruby on 19/03/2020.
//  Copyright © 2020 Martin Hruby FIT. All rights reserved.
//

import Foundation
import UIKit
import MHCoreData
import SwiftUI


// --------------------------------------------------------------------
// si tu odlozim takovou zkratku....
extension UIViewController {
    //
    func push(_ vc: UIViewController) {
        //
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// --------------------------------------------------------------------
// Kody pro jednotlive obrazovky (tabs) aplikace
enum AppTabs : Int {
    //
    case lekce = 0
    case about = 1
}

// --------------------------------------------------------------------
// Hlavni VC aplikace. Je to TabBar - rozdelovnik vsech funkci
// --------------------------------------------------------------------
class MainVC: UITabBarController {
    // ----------------------------------------------------------------
    //
    override func viewDidLoad() {
        // alokace VC pro taby. Hned se zapouzdri do NAV
        let tabLekce = Lekce.listVC.embedInNav()
        let vc = UIHostingController(rootView: AboutView())
        let tabAbout = UINavigationController(rootViewController: vc)
        
        
        tabLekce.add(tabBarItem: "Lekce", tag: AppTabs.lekce.rawValue)
        tabAbout.add(tabBarItem: "O aplikaci", tag: AppTabs.about.rawValue)
        // konfigurace TabBar, definuju jeho taby
        viewControllers = [tabLekce, tabAbout]
    }
}
