//
//  BaseViewController.swift
//  OnTheMap
//
//  Created by Guido Roos on 07/08/2023.
//

import UIKit

class BaseViewController: UIViewController {
    var spinner: UIActivityIndicatorView?
    
    override func viewDidLoad() {
            super.viewDidLoad()

            // Create a new UIActivityIndicatorView
            spinner = UIActivityIndicatorView(style: .large)
            spinner?.center = view.center
            spinner?.hidesWhenStopped = true
            view.addSubview(spinner!)
        }
}
