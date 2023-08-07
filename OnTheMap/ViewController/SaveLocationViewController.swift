//
//  SaveLocationViewController.swift
//  OnTheMap
//
//  Created by Guido Roos on 01/08/2023.
//

import Foundation
import UIKit

class SaveLocationViewController: SetPinFlowViewController {

    
    @IBOutlet weak var titleLabelP1: UILabel!
    @IBOutlet weak var titleLabelP2: UILabel!
    @IBOutlet weak var titleLabelP3: UILabel!

    @IBOutlet weak var locationTextInput: TextFieldWithPadding!
    
    @IBOutlet weak var findLocationButton: UIButton!
    
    @IBAction func findLocationButtonClicked(_ sender: Any) {
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let shareLocationVC = storyboard.instantiateViewController(withIdentifier: "ShareLinkViewController") as! ShareLinkViewController
        shareLocationVC.hidesBottomBarWhenPushed = true
        
        shareLocationVC.locationString = locationTextInput.text ?? ""
        
        
        // Navigate to the ShareLocationViewController
        navigationController?.pushViewController(shareLocationVC, animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    
    
    private func setupUI () {
        titleLabelP1.attributedText = NSAttributedString(
            string: NSLocalizedString("save_location_title_p1", comment: ""),
            attributes: TextStyles.header(color: .onBackground).attributes
        )
        titleLabelP2.attributedText = NSAttributedString(
            string: NSLocalizedString("save_location_title_p2", comment: ""),
            attributes: TextStyles.headerBold(color: .onBackground).attributes
        )
        titleLabelP3.attributedText = NSAttributedString(
            string: NSLocalizedString("save_location_title_p3", comment: ""),
            attributes: TextStyles.header(color: .onBackground).attributes
        )
        locationTextInput.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("enter_location_label", comment: ""),
            attributes: TextStyles.subheader(color: .onPrimary).attributes
        )
        
        locationTextInput.textColor = .onPrimary
        locationTextInput.backgroundColor = .primary
        locationTextInput.contentVerticalAlignment = .top
        locationTextInput.textAlignment = .center
        
        
        
        findLocationButton.apply(style: MyButtonStyle.standardButtonStyle())
        findLocationButton.setTitle(NSLocalizedString("find_location_button_text", comment: ""), for: .normal)
         
        
    }
    
    


}
