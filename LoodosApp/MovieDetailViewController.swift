//
//  MovieDetailViewController.swift
//  LoodosApp
//
//  Created by Serkan Mehmet Malagiç on 27.01.2021.
//

import UIKit
import Firebase

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var yearLbl: UILabel!
    
    @IBOutlet weak var runtimeLbl: UILabel!
    
    @IBOutlet weak var genreLbl: UILabel!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var plotLbl: UILabel!
    
    @IBOutlet weak var releasedLbl: UILabel!
    
    var id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Analytics.logEvent("movie_name", parameters: nil)
        
        navigationItem.title = moviesResponseSt?.title
                
        setVariables()
        
    }
    
    func setVariables(){
        
        imgView.sd_setImage(with: URL(string: moviesResponseSt?.poster ?? ""))
        
        titleLbl.text = moviesResponseSt?.title
        
        yearLbl.text = moviesResponseSt?.year
        
        releasedLbl.text = moviesResponseSt?.released
        
        plotLbl.text = moviesResponseSt?.plot
        
        runtimeLbl.text = moviesResponseSt?.runtime
        
        genreLbl.text = moviesResponseSt?.genre
        
    }
}
