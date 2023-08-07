//
//  OverviewViewController.swift
//  OnTheMap
//
//  Created by Guido Roos on 02/08/2023.
//

import Foundation
import UIKit

class OverviewViewController: BaseViewController {
    private var editItem: UIBarButtonItem!
    private var refreshItem: UIBarButtonItem!

    internal var userLocations: [UserLocation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.popViewController(animated: false)
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        editItem = UIBarButtonItem(image: UIImage(named: "icon_pin"), style: .plain, target: self, action: #selector(onTapLocationIcon))
        refreshItem = UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .plain, target: self, action: #selector(onTapUndoIcon))

        navigationItem.leftBarButtonItem = editItem
        navigationItem.rightBarButtonItem = refreshItem
        navigationItem.title = NSLocalizedString("app_title", comment: "")

        // Create the border view
        let borderView = UIView()
        borderView.backgroundColor = .gray
        borderView.translatesAutoresizingMaskIntoConstraints = false

        // Add the border view as a subview of the navigation bar
        navigationController?.navigationBar.addSubview(borderView)

        // Set the constraints for the border view
        NSLayoutConstraint.activate([
            borderView.leadingAnchor.constraint(equalTo: navigationController!.navigationBar.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: navigationController!.navigationBar.trailingAnchor),
            borderView.bottomAnchor.constraint(equalTo: navigationController!.navigationBar.bottomAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }

    @objc private func onTapLocationIcon() {
        navigatetoSaveLocationController()
    }

    @objc private func onTapUndoIcon() {
        let alert = TwoButtonAlert.create(
            title: NSLocalizedString("logout_confirmation_title", comment: ""),
            message: NSLocalizedString("logout_confirmation_message", comment: ""),
            actionLabel: NSLocalizedString("ok_button_text", comment: ""),
            action: {
                Task {
                    await self.logout()
                }
            }
        )

        present(alert, animated: true)
    }

    private func logout() async {
        defer {
            ApiClient.session = nil
            ApiClient.account = nil
            
            
            let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            
            navigationController?.viewControllers = [loginViewController]
            
            navigationController?.pushViewController(loginViewController, animated: true)
        }

        do {
            spinner?.startAnimating()

            try await SessionApi.deleteSession()

            spinner?.stopAnimating()

        } catch {
            spinner?.stopAnimating()

            let apiError = (error as? APIError)
            let description = apiError?.description ?? NSLocalizedString("unkown_error", comment: "")

            print(String(describing: apiError) + ": " + description)
        }
    }

    private func navigatetoSaveLocationController() {
        let saveLocationViewController = storyboard?.instantiateViewController(withIdentifier: "SaveLocationViewController") as! SaveLocationViewController

        saveLocationViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(saveLocationViewController, animated: true)
    }

    internal func getUserLocations(completion: @escaping () -> Void) {
        Task {
            do {
                spinner?.startAnimating()

                userLocations = try await LocationApi.getFilteredUserLocations(limit: 100).results

                spinner?.stopAnimating()
                completion()
            } catch {
                spinner?.stopAnimating()

                let apiError = (error as? APIError)
                let description = apiError?.description ?? NSLocalizedString("unkown_error", comment: "")

                let alert = TwoButtonAlert.create(
                    title: NSLocalizedString("get_locations_failure_title", comment: ""),
                    message: description,
                    actionLabel: NSLocalizedString("retry_button_text", comment: ""),
                    action: { [weak self] in
                        self?.getUserLocations(completion: completion)
                    }
                )

                present(alert, animated: true)

                print(String(describing: apiError) + ": " + description)
            }
        }
    }
}
