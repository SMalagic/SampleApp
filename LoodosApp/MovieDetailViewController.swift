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
                        
        fetchData()
        
    }
    
    func setVariables(){
        
    }
    
    func fetchData(){
        
        self.showWaitOverlayWithText("Getting movie information")
        
        GetMovieDetailRequest().getMovieDetail(id: "&i=" + id) { (movieDetailSt, error) in
            
            self.removeAllOverlays()
            
            if error != nil {
                self.showAlert(alertString: "Error when fetching data")
            }else{
                
                self.imgView.sd_setImage(with: URL(string: movieDetailSt?.poster ?? ""))
                
                self.titleLbl.text = movieDetailSt?.title
                
                self.yearLbl.text = movieDetailSt?.year
                
                self.releasedLbl.text = movieDetailSt?.released
                
                self.plotLbl.text = movieDetailSt?.plot
                
                self.runtimeLbl.text = movieDetailSt?.runtime
                
                self.genreLbl.text = movieDetailSt?.genre
                
                self.navigationItem.title = movieDetailSt?.title
                
            }
        }
        
    }
}
