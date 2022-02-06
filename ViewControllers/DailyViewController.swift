//
//  DailyViewController.swift
//  Weather
//
//  Created by Kalpit Patil on 2021-07-03.
//

import UIKit

class DailyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var DataArr = [[String:Any]]()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 8)
        tableView.separatorStyle = .none
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tblcell", for: indexPath) as! TableViewCell
        
        let element = DataArr[indexPath.row]
            let tempDict = element["Temperature"] as! [String:Any]
            let maxTemp = tempDict["Maximum"] as! [String:Any]
            let maxValue = maxTemp["Value"] as! Double
            cell.dailyTemp.text = "\(maxValue)°"
            
            let dayDict = element["Day"] as! [String:Any]
            cell.dailyIcon.image = getIcon(iconNumber: dayDict["Icon"] as! Int, isDayorNot: true )
             let iconphrase = dayDict["IconPhrase"] as! String
            cell.dailyPhrase.text = iconphrase
           
            let windDict = dayDict["Wind"] as! [String:Any]
            let windSpeed = windDict["Speed"] as! [String:Any]
            let speedVal = windSpeed["Value"] as! Double
            cell.dailyWind.text = "Wind:\(speedVal) km/h"
            let daydate = element["Date"] as! String
            let date = daydate.split(separator: "T")
            var time = [Substring]()
            if date[1].contains("-") {
                time = date[1].split(separator: "-")
            }
            else {
                time = date[1].split(separator: "+")
            }
            
            let joint = "\(date[0]) \(time[0])"
            let cDate = strToDate(str: joint)
            let dStr = dateToStr(date:
                                    cDate)
        let arr = dStr.split(separator: ",")
        cell.dailyDay.text = "\(arr[0])"
        cell.dailyDAte.text = "\(arr[1])"
            
        
        return cell
    }
    func strToDate(str: String) -> Date {
        //print(str)
        let isoDate = str
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from:isoDate)!
        return date
    }
    func dateToStr(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "EEEE,d MMM yyyy"
        
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
    @IBAction func backBtn(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
}
