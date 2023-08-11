//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Guido Roos on 01/08/2023.
//

import Foundation
import UIKit

class ListViewController: OverviewViewController, UITableViewDelegate, UITableViewDataSource {
    
    var data : [UserLocation] = []

    @IBOutlet var tableView: UITableView!

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! UserCell

        let user = data[indexPath.row]
        cell.image.image = UIImage(named: "icon_pin")
        cell.titleLabel.text = user.fullName

        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = data[indexPath.row]
        if let mediaURL = user.mediaURL {
            var urlString = mediaURL
            if !urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") {
                urlString = "https://" + urlString
            }
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserCell.self, forCellReuseIdentifier: "CellIdentifier")

        super.getUserLocations {
            // on completion
            self.data = StudentsData.sharedInstance().students
                
        
            self.tableView.reloadData()
        }
    }
}
