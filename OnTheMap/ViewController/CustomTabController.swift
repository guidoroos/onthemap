//
//  CustomTabController.swift
//  OnTheMap
//
//  Created by Guido Roos on 07/08/2023.
//

import Foundation
import UIKit

class CustomTabController : UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Clear the previous view controllers from the navigation stack
        navigationController?.viewControllers = [self]
    }
    
    
}
