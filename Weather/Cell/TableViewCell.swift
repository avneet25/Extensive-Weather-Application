//
//  TableViewCell.swift
//  Weather
//
//  Created by Kalpit Patil on 2021-06-12.
//

import UIKit

class TableViewCell: UITableViewCell
{

    @IBOutlet weak var hourlyW_icon: UIImageView!
    @IBOutlet weak var suggestionLbl: UILabel!
    @IBOutlet weak var HourlyTimelbl: UILabel!
    @IBOutlet weak var hourlyTempLbl: UILabel!
    @IBOutlet weak var hourlyRainLbl: UILabel!
    @IBOutlet weak var hourlyWindLbl: UILabel!
    @IBOutlet weak var hourlyHumidityLbl: UILabel!
    
    @IBOutlet weak var dailyIcon: UIImageView!
    @IBOutlet weak var dailyDay: UILabel!
    @IBOutlet weak var dailyDAte: UILabel!
    @IBOutlet weak var dailyPhrase: UILabel!
    @IBOutlet weak var dailyWind: UILabel!
    @IBOutlet weak var dailyTemp: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
