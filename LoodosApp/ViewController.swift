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
import SDWebImage
import PopupDialog

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let monitor = NWPathMonitor()
    var s = "&s=god"
    var y = "&y=a2010"
    var i = "&i=10"
    
    var result = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchHeight.constant = 0
        searchBtn.layer.cornerRadius = 5
        
        checkNetworkConn()
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
            
            let title = "Data fetched from Firebase"
            let message = alertText
            let popup = PopupDialog(title: title, message: message)
            popup.transitionStyle = .fadeIn
            self.present(popup, animated: true, completion: nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.dismiss(animated: true, completion: nil)
            self.fetchMovies()
        }
    }
    
    func setNavigationBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title : "Search", style: .plain, target: self , action: #selector(expandSearchBar))
        navigationItem.title = "Search Movies"
    }
    
    func setDelegates(){
        tableView.tableFooterView = UIView()
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
            print(path.isExpensive)
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    func fetchMovies(){
        
        self.showWaitOverlay()
        GetMoviesRequest().getMovies(search: s, year: y, id: i) { (moviesResponseSt, error) in
            self.removeAllOverlays()
            if moviesResponseSt == nil{
                self.showAlert(alertString: "Error when fetching data")
            }
            else{
                print(moviesResponseSt)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func searchCompleteTapped(_ sender: Any) {
        
        if searchBar.text == ""{
            showAlert(alertString: "search text is empty")
        }else{
            view.endEditing(true)
            let str = searchBar.text
            searchBar.text = ""
            s =  "&s=" + str!.trimmingCharacters(in: .whitespacesAndNewlines)
            fetchMovies()
        }
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
        return moviesResponseSt?.search!.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MovieTableViewCell
        cell.titleLbl.text = moviesResponseSt?.search![indexPath.row].title
        cell.subtitleLbl.text = moviesResponseSt?.search![indexPath.row].type
        cell.imgView.sd_setImage(with: URL(string: moviesResponseSt?.search![indexPath.row].poster ?? "" ))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailSB") as? MovieDetailViewController
        vc?.id = moviesResponseSt?.search![indexPath.row].imdbID ?? ""
        vc?.modalTransitionStyle = .crossDissolve
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

