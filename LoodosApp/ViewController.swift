//
//  ViewController.swift
//  LoodosApp
//
//  Created by Serkan Mehmet Malagiç on 27.01.2021.
//

import UIKit
import Network
import SwiftOverlays
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchHeight: NSLayoutConstraint!
    
    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    let monitor = NWPathMonitor()
    
    var t = "&t=a"
    var y = "&y=1990"
    var i = "&i=10"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchHeight.constant = 0
        
        checkNetworkConn()
        
        fetchMovies()
        
        setDelegates()
        
        setNavigationBar()
    
    }
    
    func checkFirebaseRemote(){
        
        let defaultValues = [
            "alertText" : "default" as NSObject
        ]
        RemoteConfig.remoteConfig().setDefaults(defaultValues)
        
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: 0) { [unowned self ](status, error) in
            guard error == nil else{
                print("There was an error")
                return
            }
            print("Values got!")
            RemoteConfig.remoteConfig().activate { (Res, error) in
                guard error == nil else{
                    print("There was an error")
                    return
                }
                updateValues()

            }
        }
        
    }
    
    func updateValues(){
             
        DispatchQueue.main.async {
            let alertText = RemoteConfig.remoteConfig().configValue(forKey: "alertText").stringValue ?? ""
            
            self.showAlert(alertString: "Data fetched from firebase : " + alertText)
        }
        
    }
    
    func setNavigationBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title : "Search", style: .plain, target: self , action: #selector(expandSearchBar))
        navigationItem.title = "Search Movies"
    }
    
    func setDelegates(){
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func checkNetworkConn(){
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Connected Established")
                self.checkFirebaseRemote()

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
        
        GetMoviesRequest().getMovies(title: t, year: y, id: i) { (moviesResponseSt, error) in
            if error == nil{
                self.showAlert(alertString: "Error when fetching data")
            }
            else{
                print(moviesResponseSt)
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
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MovieTableViewCell
        
        cell.titleLbl.text = "The Good, Bad and the Ugly"
        
        cell.subtitleLbl.text = "Blondie (The Good) (Clint Eastwood) is a professional gunslinger who is out trying to earn a few dollars. Angel Eyes (The Bad) (Lee Van Cleef) is a hitman who always commits to a task and sees it through, as long as he is paid to do so. And Tuco (The Ugly) (Eli Wallach) is a wanted outlaw trying to take care of his own hide. Tuco and Blondie share a partnership together making money off of Tuco's bounty, but when Blondie unties the partnership, Tuco tries to hunt down Blondie. When Blondie and Tuco come across a horse carriage loaded with dead bodies, they soon learn from the only survivor, Bill Carson (Antonio Casale), that he and a few other men have buried a stash of gold in a cemetery. Unfortunately, Carson dies and Tuco only finds out the name of the cemetery, while Blondie finds out the name on the grave. Now the two must keep each other alive in order to find the gold. Angel Eyes (who had been looking for Bill Carson) discovers that Tuco and Blondie met with Carson and knows ..."
        
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    
}

