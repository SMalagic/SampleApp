//
//  ResponseModel.swift
//  LoodosApp
//
//  Created by Serkan Mehmet Malagiç on 27.01.2021.
//

import Foundation

struct MovieResponse: Decodable {
    let title, year, rated, released: String
    let runtime, genre, director, writer: String
    let actors, plot, language, country: String
    let awards: String
    let poster: String
    let ratings: [Rating]
    let metascore, imdbRating, imdbVotes, imdbID: String
    let type, dvd, boxOffice, production: String
    let website, response: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case ratings = "Ratings"
        case metascore = "Metascore"
        case imdbRating, imdbVotes, imdbID
        case type = "Type"
        case dvd = "DVD"
        case boxOffice = "BoxOffice"
        case production = "Production"
        case website = "Website"
        case response = "Response"
    }
}

// MARK: - Rating
struct Rating: Decodable {
    let source: Source
    let value: Value

    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}

enum Source: String, Decodable {
    case internetMovieDatabase = "Internet Movie Database"
    case metacritic = "Metacritic"
    case rottenTomatoes = "Rotten Tomatoes"
}

enum Value: String, Codable {
    case the32 = "32%"
    case the36100 = "36/100"
    case the6010 = "6.0/10"
}

