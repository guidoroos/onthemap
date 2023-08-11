//
//  ShareLinkViewController.swift
//  OnTheMap
//
//  Created by Guido Roos on 04/08/2023.
//

import Foundation

import Foundation
import MapKit
import UIKit

class ShareLinkViewController: SetPinFlowViewController {
    var locationString: String = ""
    var location: CLLocation?

    @IBOutlet var shareLinkInputField: TextFieldWithPadding!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var submitButton: UIButton!

    @IBAction func onTapSubmitButton() {
        submitUserLocation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if !locationString.isEmpty {
            spinner?.startAnimating()
            findLocation(value: locationString)
            spinner?.stopAnimating()
        }
    }

    private func submitUserLocation() {
        Task {
            spinner?.startAnimating()

            let request = await createUserLocationRequest()

            do {
                let postUserLocationResponse = try await LocationApi.postUserLocation(userLocation: request)
                print (postUserLocationResponse)
                
                spinner?.stopAnimating()
                
                let alert = OneButtonAlert.create(
                    title: NSLocalizedString("save_location_success_title", comment: ""),
                    message: "",
                    action: {
                            self.navigateBackToOverview()
                    }
                )

                present(alert, animated: true)
                
                navigateBackToOverview()

            } catch {
                spinner?.stopAnimating()
                
                let apiError = (error as? APIError)
                let description = apiError?.description ?? NSLocalizedString("unkown_error", comment: "")

                let alert = TwoButtonAlert.create(
                    title: NSLocalizedString("save_location_failed_title", comment: ""),
                    message: "",
                    actionLabel: NSLocalizedString("continue_button_text", comment: ""),
                    action: {
                        Task {
                            self.navigateBackToOverview()
                        }
                    }
                )

                present(alert, animated: true)

                print(String(describing: apiError) + ": " + description)
            }
        }
    }

    private func createUserLocationRequest() async -> UserLocationRequest {
        var userLocationRequest = UserLocationRequest()
        let account = ApiClient.account
        let user = try? await getPersonalData()

        userLocationRequest.firstName = user?.firstName
        userLocationRequest.lastName = user?.lastName
        userLocationRequest.latitude = location?.coordinate.latitude
        userLocationRequest.longitude = location?.coordinate.longitude
        userLocationRequest.mapString = locationString
        userLocationRequest.mediaURL = shareLinkInputField.text
        userLocationRequest.uniqueKey = account?.key

        return userLocationRequest
    }

    private func getPersonalData() async throws -> User {
        guard let key = ApiClient.account?.key else {
          
            throw APIError.invalidRequest(description: "no user id found")
        }

        do {
            let data = try await LocationApi.getUserData(ID: key)
            return data
        } catch {
            let apiError = (error as? APIError)
            let description = apiError?.description ?? NSLocalizedString("unkown_error", comment: "")

            print(String(describing: apiError) + ": " + description)

            throw apiError ?? APIError.unknownError(description: "unkown_error")
        }
    }

    private func findLocation(value: String) {
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(value) { placemarks, _ in
            guard let placemark = placemarks?.first, let location = placemark.location else {
                let alert = OneButtonAlert.create(
                    title: NSLocalizedString("geocoding_failed", comment: ""),
                    message: ""
                )
                return
            }

            self.location = location
            let mkPlacemark = MKPlacemark(placemark: placemark)

            // Add the placemark as an annotation to the map view
            DispatchQueue.main.async {
                self.mapView.addAnnotation(mkPlacemark)
                self.mapView.showAnnotations([mkPlacemark], animated: true)
            }
        }
    }

    private func setupUI() {
        shareLinkInputField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("share_label", comment: ""),
            attributes: TextStyles.subheader(color: .onPrimary).attributes
        )

        shareLinkInputField.textColor = .onPrimary
        shareLinkInputField.backgroundColor = .primary
        shareLinkInputField.contentVerticalAlignment = .top
        shareLinkInputField.textAlignment = .center

        submitButton.apply(style: MyButtonStyle.standardButtonStyle())
        submitButton.setTitle(NSLocalizedString("submit_button_text", comment: ""), for: .normal)
    }

    private func navigateBackToOverview() {
        if let navigationController = navigationController {
            for viewController in navigationController.viewControllers {
                if let mapViewController = viewController as? MapViewController {
                    navigationController.popToViewController(mapViewController, animated: true)
                    break
                } else if let listViewController = viewController as? ListViewController {
                    navigationController.popToViewController(listViewController, animated: true)
                    break
                }
            }
        }
    }
}
