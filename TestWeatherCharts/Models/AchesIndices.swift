//
//  AchesIndices.swift
//  TestWeatherCharts
//
//  Created by MAC on 21.05.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

struct AchesIndex: Codable {
    let name: String
    let id: Int
    let ascending: Bool
    let localDateTime: String
    let epochDateTime: Int
    let value: Double
    let category: String
    let categoryValue: Int
    let mobileLink, link: String

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case id = "ID"
        case ascending = "Ascending"
        case localDateTime = "LocalDateTime"
        case epochDateTime = "EpochDateTime"
        case value = "Value"
        case category = "Category"
        case categoryValue = "CategoryValue"
        case mobileLink = "MobileLink"
        case link = "Link"
    }
}

typealias AchesIndices = [AchesIndex]
