//
//  CollectionViewCell.swift
//  Weather
//
//  Created by Kalpit Patil on 2021-05-26.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var dailyWeatherIcon: UIImageView!
    @IBOutlet weak var minTempLbl: UILabel!
    @IBOutlet weak var maxTempLbl: UILabel!
    @IBOutlet weak var hourlyTimeLbl: UILabel!
    @IBOutlet weak var hourlyImg: UIImageView!
    @IBOutlet weak var hourlyTempLbl: UILabel!
    @IBOutlet weak var cw_icon: UIImageView!
    @IBOutlet weak var cw_string: UILabel!
    @IBOutlet weak var cw_value: UILabel!
    @IBOutlet weak var viewGradient: UIView!
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    @IBOutlet weak var sbBkgdImg: UIImageView!
    @IBOutlet weak var sbTempLbl: UILabel!
    @IBOutlet weak var sblocationLbl: UILabel!
    @IBOutlet weak var sbDescriptionText: UILabel!
    @IBOutlet weak var sbdescpIcon: UIImageView!
    
}
