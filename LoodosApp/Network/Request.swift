//
//  Request.swift
//  LoodosApp
//
//  Created by Serkan Mehmet Malagiç on 27.01.2021.
//

import Alamofire
import SwiftyJSON


var moviesResponseSt : MovieResponse?

class GetMoviesRequest {
    
    func getMovies( title : String , year : String , id : String , completion : @escaping ( MovieResponse? , Error?) -> () )  {
       
        let url = SERVER_URL + title + year
        
        AF.request(url , method: .get, encoding : URLEncoding.default  ).responseData(completionHandler: {
            response in
            
            switch response.result {
            case .success( let data ):
                do {

                    let json = try JSON(data: response.data!)

                    if json["Response"].string == "True" {
                        moviesResponseSt = try JSONDecoder().decode(MovieResponse.self,from:data)
                        completion( moviesResponseSt , nil )

                    }else{
                        completion( nil , nil )
                    }
                
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
