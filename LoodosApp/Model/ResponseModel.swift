//
//  ResponseModel.swift
//  LoodosApp
//
//  Created by Serkan Mehmet Malagiç on 27.01.2021.
//

import Foundation

// MARK: - Welcome
struct MovieResponse: Decodable {

  enum CodingKeys: String, CodingKey {
    case search = "Search"
    case response = "Response"
    case totalResults = "totalResults"
  }

  var search: [Search]?
  var response: String?
  var totalResults: String?

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    search = try container.decodeIfPresent([Search].self, forKey: .search)
    response = try container.decodeIfPresent(String.self, forKey: .response)
    totalResults = try container.decodeIfPresent(String.self, forKey: .totalResults)
  }

}

struct Search: Decodable {

  enum CodingKeys: String, CodingKey {
    case type = "Type"
    case poster = "Poster"
    case imdbID = "imdbID"
    case year = "Year"
    case title = "Title"
  }

  var type: String?
  var poster: String?
  var imdbID: String?
  var year: String?
  var title: String?

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    type = try container.decodeIfPresent(String.self, forKey: .type)
    poster = try container.decodeIfPresent(String.self, forKey: .poster)
    imdbID = try container.decodeIfPresent(String.self, forKey: .imdbID)
    year = try container.decodeIfPresent(String.self, forKey: .year)
    title = try container.decodeIfPresent(String.self, forKey: .title)
  }

}


