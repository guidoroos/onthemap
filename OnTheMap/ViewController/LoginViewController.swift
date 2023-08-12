//
//  ViewController.swift
//  OnTheMap
//
//  Created by Guido Roos on 01/08/2023.
//

import UIKit

class LoginViewController: BaseViewController {
    @IBOutlet var loginLabel: UILabel!
    @IBOutlet var noAccountButton: UIButton!
    @IBOutlet var emailInputField: UITextField!
    @IBOutlet var passwordInputField: UITextField!
    @IBOutlet var loginButton: UIButton!

    @IBAction func onTapLoginButton() {
        createSession()
    }

    @IBAction func onTapNoAccountButton() {
        if let url = URL(string: "https://auth.udacity.com/sign-up?next=https://learn.udacity.com") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)

        tabBarController?.tabBar.isHidden = true

        setupUI()
    }

    private func setupUI() {
        loginLabel.attributedText = NSAttributedString(
            string: NSLocalizedString("login_label", comment: ""),
            attributes: TextStyles.subheader(color: .onBackground).attributes
        )

        emailInputField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("email_label", comment: ""),
            attributes: TextStyles.caption(color: .onSecondary).attributes
        )

        passwordInputField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("password_label", comment: ""),
            attributes: TextStyles.caption(color: .onSecondary).attributes
        )

        noAccountButton.setTitle(NSLocalizedString("no_account_label", comment: ""), for: .normal)

        loginButton.apply(style: MyButtonStyle.standardButtonStyle())

        loginButton.setTitle(NSLocalizedString("login_button_text", comment: ""), for: .normal)
    }

    private func navigatetoMapViewController() {
        performSegue(withIdentifier: "TabControllerSeque", sender: tabBarController)
    }

    private func createSession() {
        let username = emailInputField.text
        let password = passwordInputField.text

        let loginRequest = UdacityLoginRequest(
            udacity: UdacityCredentials(
                username: username,
                password: password
            )
        )

        Task {
            do {
                spinner?.startAnimating()

                let sessionResponse = try await SessionApi.postSession(
                    loginRequest: loginRequest
                )

                defer { spinner?.stopAnimating() }

                ApiClient.session = sessionResponse.session
                ApiClient.account = sessionResponse.account
                navigatetoMapViewController()
            } catch {
                spinner?.stopAnimating()

                let apiError = (error as? APIError)
                let description = apiError?.description ?? NSLocalizedString("unkown_error", comment: "")

                let alert = OneButtonAlert.create(
                    title: NSLocalizedString("login_failure_title", comment: ""),
                    message: description
                )

                present(alert, animated: true)

                print(String(describing: apiError) + ": " + description)
            }
        }
    }
}
