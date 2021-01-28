//
//  MovieDetailViewController.swift
//  LoodosApp
//
//  Created by Serkan Mehmet Malagiç on 27.01.2021.
//

import UIKit
import Firebase

class MovieDetailViewController: UIViewController {

    var id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Analytics.logEvent("movie_name", parameters: nil)
        
        navigationItem.title = "Batman Dark Knight"
        
    }
    
}
