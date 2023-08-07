//
//  SetPinFlowViewController.swift
//  OnTheMap
//
//  Created by Guido Roos on 06/08/2023.
//

import UIKit

class SetPinFlowViewController: BaseViewController {
    private var cancelItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
        
    }
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        
        cancelItem = UIBarButtonItem(title: NSAttributedString(
            string: NSLocalizedString("cancel_button_text", comment: "")).string,
                                     style: .plain,
                                     target: self,
                                     action: #selector(onTapCancel)
        )
        
        navigationItem.rightBarButtonItem = cancelItem
        
        
    }
    
    @objc private func onTapCancel() {
        if let navigationController = navigationController {
            for viewController in navigationController.viewControllers {
                if let mapViewController = viewController as? MapViewController {
                    
                    // Pop to the destination view controller
                    navigationController.popToViewController(mapViewController, animated: true)
                    break
                } else if let listViewController = viewController as? ListViewController {
                    
                    // Pop to the destination view controller
                    navigationController.popToViewController(listViewController, animated: true)
                    break
                }
            }
        }
    }
}
