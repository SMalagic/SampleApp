//
//  ViewController.swift
//  LoodosApp
//
//  Created by Serkan Mehmet Malagiç on 27.01.2021.
//

import UIKit
import Network
import SwiftOverlays

class ViewController: UIViewController {
    
    @IBOutlet weak var searchHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    let monitor = NWPathMonitor()
    
    lazy   var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))

    
    var t = "Serkan"
    var y = "1122"
    var i = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = "Your placeholder"
        var leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        tableView.delegate = self
        tableView.dataSource = self
        
        checkNetworkConn()
        
        fetchMovies()
        
        UIView.transition(with: view ,duration: 5,options: .transitionCrossDissolve,animations: {
            self.searchHeight.constant = 0
            self.view.layoutIfNeeded()
        })
        
    }
    
    func checkNetworkConn(){
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Connected Established")
            } else {
                DispatchQueue.main.async {
                    
                    let alertController = UIAlertController(title: "Warning", message: "Please check your internet connection", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        exit(0)
                    }
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
            
            //Bu kısım hücresel veya hotspot üzerinden gelen bir bağlantı ise true döner
            print(path.isExpensive)
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    func fetchMovies(){
        
        GetMoviesRequest().getMovies(title: t, year: y, id: i) { (Response, error) in
            if error == nil{
                self.showAlert(alertString: "Error when fetching data")
            }
            else{
                print(moviesResponseSt)
            }
        }
        
    }
}



extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moviesResponseSt.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MovieTableViewCell
        
        
        
        return cell
    }
    
}

