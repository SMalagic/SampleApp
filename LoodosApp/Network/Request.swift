//
//  Request.swift
//  LoodosApp
//
//  Created by Serkan Mehmet Malagiç on 27.01.2021.
//

import Alamofire
import SwiftyJSON


var moviesResponseSt = [Response]()

class GetMoviesRequest {
    
    func getMovies( title : String , year : String , id : String , completion : @escaping ( [Response] , Error?) -> () )  {
        
        let url = SERVER_URL + title + year + id
        
        AF.request(url , method: .get, encoding : URLEncoding.default  ).responseData(completionHandler: {
            response in
            
            switch response.result {
            case .success( let data ):
                do {
                    moviesResponseSt = try JSONDecoder().decode([Response].self,from:data)
                    
//                    var moviesResponseJson : JSON?
//                    moviesResponseJson = try JSON(data: data)

                    completion( moviesResponseSt , nil )

                }
                catch {
                    print(error)
                }
            case .failure(let error):
                print (error)
                completion( moviesResponseSt, error )
            }
        })
        
        
    }
}
