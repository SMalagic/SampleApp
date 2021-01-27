//
//  ViewController.swift
//  LoodosApp
//
//  Created by Serkan Mehmet Malagiç on 27.01.2021.
//

import UIKit
import Network
import SwiftOverlays
import SDWebImage

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchHeight: NSLayoutConstraint!
    
    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    let monitor = NWPathMonitor()
    
    var t = "Serkan"
    var y = "1122"
    var i = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchHeight.constant = 0
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        checkNetworkConn()
        
        fetchMovies()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title : "Search", style: .plain, target: self , action: #selector(expandSearchBar))
        
        navigationItem.title = "Search Movies"
        
       
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
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func searchCompleteTapped(_ sender: Any) {
       
        
        
    }
    
    @objc func expandSearchBar(sender: UIBarButtonItem){
        UIView.transition(with : view, duration: 0.25, options: .transitionCrossDissolve, animations: { [self] in
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title : "", style: .plain, target: self , action: #selector(expandSearchBar))

            self.searchHeight.constant = 50
        })
    }
}



extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moviesResponseSt.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MovieTableViewCell
        
        cell.titleLbl.text = moviesResponseSt[indexPath.row].title
        
        cell.subtitleLbl.text = moviesResponseSt[indexPath.row].plot
        
        cell.imageView?.sd_setImage(with: URL(string: moviesResponseSt[indexPath.row].poster))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailSB") as? MovieDetailViewController
        vc?.id = moviesResponseSt[indexPath.row].imdbID
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

