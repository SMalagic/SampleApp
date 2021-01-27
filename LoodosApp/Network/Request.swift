//
//  Request.swift
//  LoodosApp
//
//  Created by Serkan Mehmet Malagiç on 27.01.2021.
//

import Alamofire
import SwiftyJSON


var moviesResponseSt = [MovieResponse]()

class GetMoviesRequest {
    
    func getMovies( title : String , year : String , id : String , completion : @escaping ( [MovieResponse] , Error?) -> () )  {
        
        let url = SERVER_URL + title + year + id
        
        AF.request(url , method: .get, encoding : URLEncoding.default  ).responseData(completionHandler: {
            response in
            
            switch response.result {
            case .success( let data ):
                do {
                    moviesResponseSt = try JSONDecoder().decode([MovieResponse].self,from:data)

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
