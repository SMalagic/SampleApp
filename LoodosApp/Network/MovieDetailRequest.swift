//
//  MovieDetailRequest.swift
//  LoodosApp
//
//  Created by Serkan Mehmet Malagiç on 29.01.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

var movieDetailSt : MovieDetailModel?

class GetMovieDetailRequest {
    
    func getMovieDetail( id : String , completion : @escaping ( MovieDetailModel? , Error?) -> () )  {
       
        let url = SERVER_URL + id
        
        AF.request(url , method: .get, encoding : URLEncoding.default  ).responseData(completionHandler: {
            response in
            
            switch response.result {
            case .success( let data ):
                do {

                    let json = try JSON(data: response.data!)

                    if json["Response"].string == "True" {
                        movieDetailSt = try JSONDecoder().decode(MovieDetailModel.self,from:data)
                        completion( movieDetailSt , nil )

                    }else{
                        completion( nil , nil )
                    }
                
                }
                catch {
                    print(error)
                }
            case .failure(let error):
                print (error)
                completion( movieDetailSt, error )
            }
        })
        
        
    }
}
