//
//  SaveLocationViewController.swift
//  OnTheMap
//
//  Created by Guido Roos on 01/08/2023.
//

import Foundation
import MapKit
import UIKit

class SaveLocationViewController: SetPinFlowViewController {
    @IBOutlet var titleLabelP1: UILabel!
    @IBOutlet var titleLabelP2: UILabel!
    @IBOutlet var titleLabelP3: UILabel!

    @IBOutlet var locationTextInput: TextFieldWithPadding!

    @IBOutlet var findLocationButton: UIButton!

    @IBAction func findLocationButtonClicked(_: Any) {
        findLocationAndNavigate(value: locationTextInput?.text ?? "")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func findLocationAndNavigate(value: String) {
        spinner?.startAnimating()
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(value) { placemarks, _ in
            guard let placemark = placemarks?.first, let location = placemark.location else {
                self.spinner?.stopAnimating()

                let alert = OneButtonAlert.create(
                    title: NSLocalizedString("geocoding_failed", comment: ""),
                    message: ""
                )
                self.present(alert, animated: true)
                return
            }

            self.spinner?.stopAnimating()

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let shareLocationVC = storyboard.instantiateViewController(withIdentifier: "ShareLinkViewController") as! ShareLinkViewController
            shareLocationVC.hidesBottomBarWhenPushed = true

            shareLocationVC.placemark = placemark
            shareLocationVC.location = location

            // Navigate to the ShareLocationViewController
            self.navigationController?.pushViewController(shareLocationVC, animated: true)
        }
    }

    private func setupUI() {
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
