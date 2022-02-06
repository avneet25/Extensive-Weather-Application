//
//  Constant.swift
//  Weather
//
//  Created by Kalpit Patil on 2021-05-27.
//

import UIKit

func getIcon(iconNumber:Int, isDayorNot:Bool) -> UIImage {
    
    var iconImage = UIImage()

    switch (iconNumber) {
            case 1:
                iconImage = UIImage(named: "day_sunny")!
                break
            case 2:
                iconImage = UIImage(named: "day_mostly_sunny")!
                break;
            case 3:
                iconImage = UIImage(named: "day_partly_sunny")!
                break
            case 4:
                iconImage = UIImage(named: "day_intermittent_cloud")!
                break
            case 5:
                iconImage = UIImage(named: "day_hazy_sunshine")!
                break
            case 6:
                iconImage = UIImage(named: "day_mostly_cloudy")!
                break
            case 7:
                if isDayorNot {
                    iconImage = UIImage(named: "day_cloudy")!
                } else
                {
                    iconImage = UIImage(named: "night_cloudy")!
                }

                break
            case 8:
                if isDayorNot {
                    iconImage = UIImage(named: "day_dreary(over-cast)")!
                } else {
                    iconImage = UIImage(named: "night_dreary(over-cast)")!
                }
                break
            case 11:
                if isDayorNot{
                    iconImage = UIImage(named: "day_fog")!
                } else {
                    iconImage = UIImage(named: "night_fog")!
                }
                break
            case 12:
                if isDayorNot {
                    iconImage = UIImage(named: "day_showers")!
                } else {
                    iconImage = UIImage(named: "night_showers")!
                }
                break
            case 13:
                iconImage = UIImage(named: "day_mostly_cloudy_with_showers")!
                break;
            case 14:
                iconImage = UIImage(named: "day_partly_sunny_with_showers")!
                break
            case 15:
                if isDayorNot {
                    iconImage = UIImage(named: "day_t_stroms")!
                } else {
                    iconImage = UIImage(named: "night_t_stroms")!
                }
                break
            case 16:
                iconImage = UIImage(named: "day_mostly_cloudy_with_t_stroms")!
                break
            case 17:
                iconImage = UIImage(named: "day_partly_sunny_with_t_stroms")!
                break
            case 18:
                if isDayorNot {
                    iconImage = UIImage(named: "day_rainy")!
                } else {
                    iconImage = UIImage(named: "night_rainy")!
                }
                break
            case 19:
                if isDayorNot {
                    iconImage = UIImage(named: "day_flurries")!
                } else {
                    iconImage = UIImage(named: "night_flurries")!
                }
                break
            case 20:
                iconImage = UIImage(named: "day_mostly_cloudy_with_flurries")!
                break
            case 21:
                iconImage = UIImage(named: "day_partly_sunny_with_flurries")!
                break
            case 22:
                if isDayorNot {
                    iconImage = UIImage(named: "day_snow")!
                } else {
                    iconImage = UIImage(named: "night_snow")!
                }
                break
            case 23:
                iconImage = UIImage(named: "day_mostly_cloudy_with_snow")!
                break
            case 24:
                if isDayorNot {
                    iconImage = UIImage(named: "day_ice")!
                } else {
                    iconImage = UIImage(named: "night_ice")!
                }
                break
            case 25:
                if isDayorNot {
                    iconImage = UIImage(named: "day_sleet")!
                } else {
                    iconImage = UIImage(named: "night_sleet")!
                }
                break
            case 26:
                if isDayorNot {
                    iconImage = UIImage(named: "day_freezing_rain")!
                } else {
                    iconImage = UIImage(named: "night_freezing_rain")!
                }
                break
            case 29:
                if isDayorNot {
                    iconImage = UIImage(named: "day_rain_snow")!
                } else {
                    iconImage = UIImage(named: "night_rain_snow")!
                }
                break
            case 30:
                if isDayorNot {
                    iconImage = UIImage(named: "day_hot")!
                } else {
                    iconImage = UIImage(named: "night_hot")!
                }
                break
            case 31:
                if isDayorNot {
                    iconImage = UIImage(named: "day_cold")!
                } else {
                    iconImage = UIImage(named: "night_cold")!
                }
                break
            case 32:
                if isDayorNot {
                    iconImage = UIImage(named: "day_windy")!
                } else {
                    iconImage = UIImage(named: "night_windy")!
                }
                break
            case 33:
                iconImage = UIImage(named: "night_clear")!
                break
            case 34:
                iconImage = UIImage(named: "night_mostly_clear")!
                break
            case 35:
                iconImage = UIImage(named: "night_partly_cloudy")!
                break
            case 36:
                iconImage = UIImage(named: "night_intermittent_cloud")!
                break
            case 37:
                iconImage = UIImage(named: "night_hazy_moonlight")!
                break
            case 38:
                iconImage = UIImage(named: "night_mostly_cloudy")!
                break
            case 39:
                iconImage = UIImage(named: "night_partly_cloudy_with_showers")!
                break
            case 40:
                iconImage = UIImage(named: "night_mostaly_cloudy_wih_showers")!
                break
            case 41:
                iconImage = UIImage(named: "night_partly_cloudy_with_t_stroms")!
                break
            case 42:
                iconImage = UIImage(named: "night_mostaly_cloudy_with_t_stroms")!
                break
            case 43:
                iconImage = UIImage(named: "night_mostaly_cloudy_with_flurries")!
                break
            case 44:
                iconImage = UIImage(named: "night_mostaly_cloudy_with_snow")!
                break

            default:
                iconImage = UIImage.init()
    }


return iconImage
    
}

