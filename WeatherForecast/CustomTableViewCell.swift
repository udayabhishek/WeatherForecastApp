//
//  CustomTableViewCell.swift
//  WeatherForecast
//
//  Created by Uday Kumar Abhishek - (Digital) on 22/06/17.
//  Copyright © 2017 Uday Kumar Abhishek - (Digital). All rights reserved.
//

import Foundation
import UIKit


class CustomTableViewCell:UITableViewCell{

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var labelDayName: UILabel!
    @IBOutlet weak var labelWeatherType: UILabel!
    @IBOutlet weak var labelTemperatureMax: UILabel!
    @IBOutlet weak var labelTemperatureMin: UILabel!
}
