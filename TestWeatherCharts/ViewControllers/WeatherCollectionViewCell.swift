//
//  WeatherCollectionViewCell.swift
//  TestWeatherCharts
//
//  Created by MAC on 03.05.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var hourlyTempLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func configure() {
       contentView.layer.cornerRadius = 20
       contentView.layer.borderWidth = 1.0
       contentView.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
       contentView.layer.masksToBounds = true
       layer.shadowColor = UIColor.gray.cgColor
       layer.shadowOffset = CGSize(width: 0, height: 2.0)
       layer.shadowRadius = 2.0
       layer.shadowOpacity = 0.5
       layer.masksToBounds = false
       layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
}
