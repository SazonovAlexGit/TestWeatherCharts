//
//  AccuWeather.swift
//  TestWeatherCharts
//
//  Created by MAC on 06.05.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

// MARK: - AccuWeatherElement
struct AccuWeatherElement: Codable {
    let dateTime: String
    let epochDateTime: Double
    let weatherIcon: Int
    let iconPhrase: String
    let hasPrecipitation, isDaylight: Bool
    let temperature: Temperature
    let precipitationProbability: Int
    let mobileLink, link: String

    enum CodingKeys: String, CodingKey {
        case dateTime = "DateTime"
        case epochDateTime = "EpochDateTime"
        case weatherIcon = "WeatherIcon"
        case iconPhrase = "IconPhrase"
        case hasPrecipitation = "HasPrecipitation"
        case isDaylight = "IsDaylight"
        case temperature = "Temperature"
        case precipitationProbability = "PrecipitationProbability"
        case mobileLink = "MobileLink"
        case link = "Link"
    }
}

enum IconPhrase: String, Codable {
    case clear = "Clear"
    case sunny = "Sunny"
    case mostlysunny = "Mostly sunny"
    
}

// MARK: - Temperature
struct Temperature: Codable {
    let value: Double
    let unit: Unit
    let unitType: Int

    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case unit = "Unit"
        case unitType = "UnitType"
    }
}

enum Unit: String, Codable {
    case c = "C"
}

typealias AccuWeather = [AccuWeatherElement]

//MARK: - Sity Model
struct AccuCity: Codable {
    let version: Int?
    let key, type: String?
    let rank: Int?
    let localizedName, englishName, primaryPostalCode: String?
    let region, country: Country?
    let administrativeArea: AdministrativeArea?
    let geoPosition: GeoPosition?
    let isAlias: Bool?
    let supplementalAdminAreas: [SupplementalAdminArea]?
    let dataSets: [String]?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case key = "Key"
        case type = "Type"
        case rank = "Rank"
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
        case primaryPostalCode = "PrimaryPostalCode"
        case region = "Region"
        case country = "Country"
        case administrativeArea = "AdministrativeArea"
        case geoPosition = "GeoPosition"
        case isAlias = "IsAlias"
        case supplementalAdminAreas = "SupplementalAdminAreas"
        case dataSets = "DataSets"
    }
}

// MARK: - AdministrativeArea
struct AdministrativeArea: Codable {
    let id, localizedName, englishName: String
    let level: Int
    let localizedType, englishType, countryID: String

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
        case level = "Level"
        case localizedType = "LocalizedType"
        case englishType = "EnglishType"
        case countryID = "CountryID"
    }
}

// MARK: - Country
struct Country: Codable {
    let id, localizedName, englishName: String

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
    }
}

// MARK: - GeoPosition
struct GeoPosition: Codable {
    let latitude, longitude: Double
    let elevation: Elevation

    enum CodingKeys: String, CodingKey {
        case latitude = "Latitude"
        case longitude = "Longitude"
        case elevation = "Elevation"
    }
}

// MARK: - Elevation
struct Elevation: Codable {
    let metric, imperial: Imperial

    enum CodingKeys: String, CodingKey {
        case metric = "Metric"
        case imperial = "Imperial"
    }
}

// MARK: - Imperial
struct Imperial: Codable {
    let value: Int
    let unit: String
    let unitType: Int

    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case unit = "Unit"
        case unitType = "UnitType"
    }
}

// MARK: - SupplementalAdminArea
struct SupplementalAdminArea: Codable {
    let level: Int
    let localizedName, englishName: String

    enum CodingKeys: String, CodingKey {
        case level = "Level"
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
    }
}


//MARK: - JSON Parsing
class JSONParse {
    
    static func fetchArrayDatafromURL<T: Decodable>(urlString: String, completion: @escaping ([T]) -> ()) {
        
        guard let url = URL(string: urlString) else {
            print ("Sorry, connection refused")
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            guard error == nil else { return }
            do {
                let obj = try JSONDecoder().decode([T].self, from: data)
                
                completion(obj)
                
            }catch let error {
                print(error)
              print ("Data missing. Sorry, can't decode data from URL")
            }
        }.resume()
    }

        static func fetchDictDatafromURL<T: Decodable>(urlString: String, completion: @escaping (T) -> ()) {
            
            guard let url = URL(string: urlString) else {
     //           showRedAllert(title: "URL missing", message: "Sorry, connection refused")
                return
            }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                guard error == nil else { return }
                do {
                    let obj = try JSONDecoder().decode(T.self, from: data)
                    
                    completion(obj)
                    
                }catch let error {
                    print(error)
    //                self.showRedAllert(title: "Data missing", message: "Sorry, can't decode data from URL")
                }
            }.resume()
        }
}

