
import UIKit
import CoreLocation
import Alamofire
import StepSlider
import MapKit
import SDWebImage
import MSCircularSlider

class ViewController: UIViewController, UIGestureRecognizerDelegate, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
 
    @IBOutlet weak var sideBar_cv: UICollectionView!
    @IBOutlet weak var Daily_cv: UICollectionView!
    @IBOutlet weak var daydateLbl: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherTextlbl: UILabel!
    @IBOutlet weak var collectView: UICollectionView!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var symbolLbl: UILabel!
    @IBOutlet weak var hourly_cv: UICollectionView!
    @IBOutlet weak var mapViewImg: UIImageView!
    @IBOutlet weak var dayLeadingLbl: UILabel!
    @IBOutlet weak var timeLeadingLbl: UILabel!
    @IBOutlet weak var dayTrailingLbl: UILabel!
    @IBOutlet weak var timeTrailingLbl: UILabel!
    @IBOutlet weak var stepSliderView: StepSlider!
    @IBOutlet weak var rainBarView: UIView!
    @IBOutlet weak var cloudBarView: UIView!
    @IBOutlet weak var overlappingMapImg: UIImageView!
    @IBOutlet weak var DateTimeLbl: UILabel!
    @IBOutlet weak var circularSlider: MSCircularSlider!
    @IBOutlet weak var sunsetLbl: UILabel!
    @IBOutlet weak var sunriseLbl: UILabel!
    @IBOutlet var viewOpacity: UIView!
    @IBOutlet var viewSideBar: UIView!
    
    var currentWeatherData = [String:Any]()
    var searchedWeatherData = [String:Any]()
    let locationManager = CLLocationManager()
    var cw_stringArr = ["Feels Like", "Wind", "Humidity", "Pressure", "Rain", "Cloud Cover"]
    var value2 = [[String:Any]]()
    var dailyData = [[String:Any]]()
    var tempDiffArr = [Int]()
    var MaxDiff = Int()
    var currentDay = [String:Any]()
    var mapRainOrCloudIndex = 0
    var Observation = [[String:Any]]()
    var BaseTime = String()
    var locId = String()
    var historyArray = [[String:Any]]()
    var cityName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  NotificationCenter.default.addObserver(self, selector: #selector(searchedDict), name: NSNotification.Name.init("nc"), object: nil)
        
        cloudBarView.isHidden = true
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        drawerInit()
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if let historyArr = UserDefaults.standard.array(forKey: "history") as? [[String:Any]] {
            historyArray = historyArr
            if !historyArray.isEmpty {
                let currentCity = historyArr[0]
                let locKey = currentCity["Key"] as! String
                getWeatherInfo(Id: locKey)
                getDailyWeatherInfo(Id: locKey)
                getHourlyWeatherInfo(Id: locKey)
                let localname =  currentCity["LocalizedName"]
                let country = (currentCity["Country"] as! [String:Any])["ID"] as! String
                locationLbl.text = "\(localname!), \(country)"
                getLatiLongiByKey(Id: locKey)
            }
        }
        
    }
    
    //    @objc func searchedDict(noti:Notification) {
    //        notificationsCalled = notificationsCalled + 1
    //        let partiCitySearched  = noti.userInfo as! [String:Any]
    //
    //    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        getLocationInfo(lati: locValue.latitude, longi: locValue.longitude)
        getLocationId(lati: locValue.latitude, longi: locValue.longitude)
    }
    
    //func returns location key using lati/long
    func getLocationInfo(lati: Double, longi: Double)
    {
        
        let apiUrl = "https://api.accuweather.com/locations/v1/cities/geoposition/search.json?q=\(lati),\(longi)&apikey=srRLeAmTroxPinDG8Aus3Ikl6tLGJd94"
        AF.request(apiUrl).responseJSON { [self] results in
            if let value = results.value as? [String:Any] {
                //print(value)
                let locationId = value["Key"] as! String
                let city = (value["ParentCity"] as! [String:Any]) ["EnglishName"] as! String
                let country = (value["Country"] as! [String:Any]) ["EnglishName"] as! String
                cityName = city
                getWeatherInfo(Id: locationId)
                getDailyWeatherInfo(Id: locationId)
                getHourlyWeatherInfo(Id: locationId)
                locationLbl.text = "\(city), \(country)"
            }
        }
        
    }
    func getLatiLongiByKey(Id: String) {
        
        let apiUrl = "https://api.accuweather.com/locations/v1/\(Id).json?apikey=srRLeAmTroxPinDG8Aus3Ikl6tLGJd94&language=en-us&details=true"
        
        AF.request(apiUrl).responseJSON { result in
            if let value = result.value as? [String:Any]{
                let lati = (value["GeoPosition"] as! [String:Any]) ["Latitude"] as! Double
                let longi = (value["GeoPosition"] as! [String:Any]) ["Longitude"] as! Double
                self.getLocationId(lati: lati, longi: longi)
                
            }
        }
    }
    
    func getLocationId(lati: Double, longi: Double) {
        
        let apiUrl =  "https://pw.foreca.com/fw/v4/\(longi),\(lati).json?lang=en&locale=en-US&v=4.9.8.1153"
        
        AF.request(apiUrl).responseJSON { [self] results in
            if let value = results.value as? [String:Any] {
                locId = value["location_id"] as! String
                getMapImage(lId: locId)
                getMapdata(rainOrCloudId: 0, locationId: locId)
            }
        }
        
    }
    func getWeatherInfoAgain(Id: String)
    {
        let apiUrl = "https://api.accuweather.com/currentconditions/v1/\(Id).json?apikey=srRLeAmTroxPinDG8Aus3Ikl6tLGJd94&language=en-us&details=true&getphotos=false"
        AF.request(apiUrl).responseJSON { [self] results in
            if let value = results.value
                as? [[String:Any]] {
                searchedWeatherData = value[0]
                //sideBar_cv.reloadData()
            }
        }
    }
    func getWeatherInfo(Id: String)
    {
        let apiUrl = "https://api.accuweather.com/currentconditions/v1/\(Id).json?apikey=srRLeAmTroxPinDG8Aus3Ikl6tLGJd94&language=en-us&details=true&getphotos=false"
        AF.request(apiUrl).responseJSON { [self] results in
            if let value = results.value
                as? [[String:Any]] {
                currentWeatherData = value[0]
                let tempDict = currentWeatherData["Temperature"] as!
                    [String:Any]
                weatherTextlbl.text = currentWeatherData["WeatherText"] as? String
                weatherIcon.image = getIcon(iconNumber:
                                                currentWeatherData["WeatherIcon"] as! Int, isDayorNot: currentWeatherData["IsDayTime"] as! Bool)
                
                let daydate = currentWeatherData["LocalObservationDateTime"] as! String
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
                daydateLbl.text = dStr
                
                
                //                let Imp_tempDict = tempDict["Imperial"] as! [String:Any]
                //                let tempValueI = Imp_tempDict["Value"] as! Double
                let Met_tempDict = tempDict["Metric"] as! [String:Any]
                let tempValueM = Met_tempDict["Value"] as! Double
                //print("\(tempValueI), \(tempValueM)"
                
                self.tempLbl.text = "\(tempValueM)"
                symbolLbl.text = "°C"
                collectView.reloadData()
                
            }
        }
        
    }
    
    func designCircularSlider() {
        
        if !dailyData.isEmpty {
            let sunDict = (dailyData[0] )["Sun"] as! [String:Any]
            let sunrise = sunDict["Rise"] as! String
            let sunset = sunDict["Set"] as! String
            let sr = SetSunRiseSetLbls(Time: sunrise)
            let ss = SetSunRiseSetLbls(Time: sunset)
            sunriseLbl.text = sr
            sunsetLbl.text = ss
            
            let sr2 = sr.split(separator: ":")
            let ss2 = ss.split(separator: ":")
            
            let sr3 = "\(sr2[0]).\(sr2[1])"
            let ss3 = "\(ss2[0]).\(ss2[1])"
            
            let sunrise2 = Double(sr3) as! Double
            let sunset2 = Double(ss3) as! Double
            let dayHours = sunset2 - sunrise2
            
            if !currentWeatherData.isEmpty {
                let daydate = currentWeatherData["LocalObservationDateTime"] as! String
                
                let date = daydate.split(separator: "T")
                var time = [Substring]()
                if date[1].contains("-") {
                    time = date[1].split(separator: "-")
                }
                else {
                    time = date[1].split(separator: "+")
                }
                
                let t2 = time[0].split(separator: ":")
                let T = "\(t2[0]).\(t2[1])"
                let currenttime = Double(T) as! Double
                
                
                circularSlider.maximumAngle = 180
                let slidervalue = ((currenttime - sunrise2)/dayHours) * 100
                circularSlider.currentValue = slidervalue
                circularSlider.handleType = .doubleCircle
                circularSlider.handleEnlargementPoints = 12
                
            }
        }
    }
    
    
    func SetSunRiseSetLbls(Time: String) -> String {
        //        2021-06-09T05:47:00-07:00
        let timeMid = Time.split(separator: "T")
        let time2 = timeMid[1].split(separator: "-")
        let time = time2[0].split(separator: ":")
        return "\(time[0]):\(time[1])"
    }
    
    func strToDate(str: String) -> Date {
        //print(str)
        let isoDate = str
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from:isoDate)!
        return date
    }
    
    func getHourlyWeatherInfo(Id: String) {
        let apiUrl = "https://api.accuweather.com/forecasts/v1/hourly/24hour/\(Id).json?apikey=srRLeAmTroxPinDG8Aus3Ikl6tLGJd94&language=en-us&details=true&metric=true"
        
        AF.request(apiUrl).responseJSON { [self] result in
            if let value = result.value as? [[String:Any]] {
                self.value2 = value
                hourly_cv.reloadData()
            }
        }
        
    }
    func getDailyWeatherInfo(Id: String) {
        let apiUrl = "https://api.accuweather.com/forecasts/v1/daily/15day/\(Id).json?apikey=srRLeAmTroxPinDG8Aus3Ikl6tLGJd94&language=en-us&details=true&metric=true"
        AF.request(apiUrl).responseJSON { [self] result in
            if let value = result.value as? [String:Any] {
                self.dailyData = value["DailyForecasts"] as! [[String : Any]]
                getTempDiff()
                designCircularSlider()
            }
        }
        
        
    }
    //func for getting maximum temp difference
    func getTempDiff() {
        for i in 0..<dailyData.count {
            currentDay = dailyData[i]
            let tempDict = currentDay["Temperature"] as! [String:Any]
            let maxTemp = tempDict["Maximum"] as! [String:Any]
            let maxValue = maxTemp["Value"] as! Double
            let minTemp = tempDict["Minimum"] as! [String:Any]
            let minValue = minTemp["Value"] as! Double
            
            let partiDiff = Int(maxValue-minValue)
            tempDiffArr.append(partiDiff)
        }
        
        MaxDiff = tempDiffArr[0]
        
        for i in 1..<tempDiffArr.count{
            if tempDiffArr[i] > MaxDiff  {
                MaxDiff = tempDiffArr[i]
            }
        }
        
        Daily_cv.reloadData()
    }
    
    func dateToStr(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "EEE, dd MMM - HH:mm a"
        
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
    func dateToStrr(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd MMM "
        
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
    func timeformatter(date: Date) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let string = dateFormatter.string(from: date as Date)
        
        return string
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectView
        {
            return 6
        }
        else if collectionView == hourly_cv {
            return value2.count
        }
        else if collectionView == Daily_cv {
            return dailyData.count
        }
        else {
            return historyArray.count
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
            cell.layer.cornerRadius = 5
            cell.cw_string.text = cw_stringArr[indexPath.row]
            cell.cw_icon.image = UIImage.init(named: cw_stringArr[indexPath.row])
            
            if !currentWeatherData.isEmpty {
                if indexPath.row == 0 {
                    //feels like
                    let tempDict = currentWeatherData["RealFeelTemperature"] as! [String:Any]
                    
                    let Met_tempDict = tempDict["Metric"] as! [String:Any]
                    let tempValueM = Met_tempDict["Value"] as! Double
                    let unit = Met_tempDict["Unit"] as! String
                    cell.cw_value.text = "\(tempValueM) °\(unit)"
                    
                }
                else if indexPath.row == 1{
                    //"Wind"
                    let tempDict = currentWeatherData["Wind"] as! [String:Any]
                    
                    let speed = tempDict["Speed"] as! [String:Any]
                    let Met_speedDict = speed["Metric"] as! [String:Any]
                    let tempValueM = Met_speedDict["Value"] as! Double
                    let unit = Met_speedDict["Unit"] as! String
                    cell.cw_value.text = "\(tempValueM) \(unit)"
                }
                else if indexPath.row == 2{
                    //"Humidity"
                    cell.cw_value.text = "\(currentWeatherData["RelativeHumidity"] as! Int) %"
                }
                else if indexPath.row == 3{
                    //"Pressure"
                    let tempDict = currentWeatherData["Pressure"] as! [String:Any]
                    
                    let Met_pressureDict = tempDict["Metric"] as! [String:Any]
                    let pressureValueM = Met_pressureDict["Value"] as! Double
                    let unit = Met_pressureDict["Unit"] as! String
                    cell.cw_value.text = "\(pressureValueM) \(unit)"
                }
                else if indexPath.row == 4{
                    //"Rain"
                    let rainDict = currentWeatherData["Precip1hr"] as! [String:Any]
                    
                    let Met_rainDict = rainDict["Metric"] as! [String:Any]
                    let rainValueM = Met_rainDict["Value"] as! Double
                    let unit = Met_rainDict["Unit"] as! String
                    cell.cw_value.text = "\(rainValueM) \(unit)"
                    
                }
                else {
                    //"Cloud Cover"
                    cell.cw_value.text = "\(currentWeatherData["CloudCover"] as! Int) %"
                }
            }
            
            return cell
        }
        else if collectionView == hourly_cv {
            //hourly
            let cell = hourly_cv.dequeueReusableCell(withReuseIdentifier: "collectionCell2", for: indexPath) as! CollectionViewCell
            
            if !value2.isEmpty {
                let HourlypartiDict = value2[indexPath.row]
                let dateTimeStr = HourlypartiDict["DateTime"] as! String
                let date = dateTimeStr.split(separator: "T")
                var time = [Substring]()
                if date[1].contains("-") {
                    time = date[1].split(separator: "-")
                }
                else {
                    time = date[1].split(separator: "+")
                }
                let joint = "\(date[0]) \(time[0])"
                let date2 = strToDate(str: joint)
                let str = timeformatter(date: date2)
                cell.hourlyTimeLbl.text = str
                
                cell.hourlyImg.image = getIcon(iconNumber: HourlypartiDict["WeatherIcon"] as! Int, isDayorNot: HourlypartiDict["IsDaylight"] as! Bool)
                
                let tempDict = HourlypartiDict["Temperature"] as! [String:Any]
                let tempValueM = tempDict["Value"] as! Double
                let unit = tempDict["Unit"] as! String
                cell.hourlyTempLbl.text = "\(Int(tempValueM)) °\(unit)"
                
            }
            
            return cell
        }
        else if collectionView == Daily_cv {
            let cell = Daily_cv.dequeueReusableCell(withReuseIdentifier: "dailyCell", for: indexPath) as! CollectionViewCell
            
            currentDay = dailyData[indexPath.row]
            let tempDict = currentDay["Temperature"] as! [String:Any]
            let maxTemp = tempDict["Maximum"] as! [String:Any]
            let maxValue = maxTemp["Value"] as! Double
            let minTemp = tempDict["Minimum"] as! [String:Any]
            let minValue = minTemp["Value"] as! Double
            
            let partiDiff = Int(maxValue-minValue)
            cell.heightConstant.constant = CGFloat(Int((150 * partiDiff) / MaxDiff))
            
            cell.layoutIfNeeded()
            cell.viewGradient.layer.cornerRadius = 5
            
            cell.maxTempLbl.text = "\(maxValue)°"
            cell.minTempLbl.text = "\(minValue)°"
            
            let dayDict = currentDay["Day"] as! [String:Any]
            cell.dailyWeatherIcon.image = getIcon(iconNumber: dayDict["Icon"] as! Int, isDayorNot: true )
            let daydate = currentDay["Date"] as! String
            let date = daydate.split(separator: "T")
            var time = [Substring]()
            if date[1].contains("-") {
                time = date[1].split(separator: "-")
            }
            else {
                time = date[1].split(separator: "+")
            }
            let joint = "\(date[0]) \(time[0])"
            //print(joint)
            let cDate = strToDate(str: joint)
            let strr = dateToStrr(date: cDate)
            cell.dateLbl.text = "\(strr)"
            
            return cell
        }
        else {
            let cell = sideBar_cv.dequeueReusableCell(withReuseIdentifier: "historyCell", for: indexPath) as! CollectionViewCell
            
            if !historyArray.isEmpty {
                let partiCity = historyArray[indexPath.row]
                let partiKey = partiCity["Key"] as! String
                getWeatherInfoAgain(Id: partiKey)
                if !searchedWeatherData.isEmpty {
                    let tempDict = searchedWeatherData["Temperature"] as! [String:Any]
                    let Met_tempDict = tempDict["Metric"] as! [String:Any]
                    let tempValueM = Met_tempDict["Value"] as! Double
                    cell.sbTempLbl.text = "\(tempValueM)°C"
                    cell.sbDescriptionText.text = partiCity["WeatherText"] as? String
                    let isDayorNot = searchedWeatherData["IsDayTime"] as! Bool
                    if isDayorNot {
                        cell.sbBkgdImg.image = UIImage.init(named: "day")
                    }
                    else {
                        cell.sbBkgdImg.image = UIImage.init(named: "night")
                    }
                    cell.sbdescpIcon.image = getIcon(iconNumber: searchedWeatherData["WeatherIcon"] as! Int, isDayorNot: isDayorNot)
                }
            }
            return cell
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectView {
            return CGSize.init(width: 120, height: 120)}
        else if collectionView == hourly_cv {
            return CGSize.init(width: 100, height: 150) }
        else if collectionView == Daily_cv {
            return CGSize.init(width: 120, height: 325)
        }
        else {
            return CGSize.init(width: self.viewSideBar.frame.width, height: 180)
        }
    }
    
    //MARK: Rain/Cloud
    func getMapdata(rainOrCloudId: Int, locationId: String)
    {
        overlappingMapImg.image = UIImage()
        let url = "https://pw.foreca.com/fw/v4/\(locationId).json?lang=en&locale=en-US&v=4.9.8.1153"
        
        AF.request(url).responseJSON { [self] data in
            if let res = data.value as? [String:Any]
            {
                let maps = res["maps"] as! [[String:Any]]
                //Note: check if key is one of the "names"
                var rainOrCloud = [String:Any]()
                if rainOrCloudId == 1 {
                     rainOrCloud = maps[rainOrCloudId]
                }
                else
                {
                     rainOrCloud = maps[rainOrCloudId+1]
                }
                
                BaseTime = rainOrCloud["basetime"] as! String
                let Steps = rainOrCloud["steps"] as! [String:Any]
                Observation = Steps["observation"] as! [[String:Any]]
                
                if Observation.isEmpty {
                    Observation = Steps["forecast"] as! [[String:Any]]
                }
                mapLblSetting(index: 0)
            }
        }
    }
    
    @IBAction func stepSliderAction(_ sender: StepSlider) {
        let ind = sender.index
        mapLblSetting(index: Int(ind))
        
        if !Observation.isEmpty {
            let partiElememt = Observation[Int(ind)]
            let partiUtc = partiElememt["time_utc"] as! String
            var type = String()
            if mapRainOrCloudIndex == 0 {
                type = "rain"
            }else {
                type = "cloud"
            }
            getPartiMapImage(Id: locId, UTCtime: partiUtc, baseTime: BaseTime, type: type)
        }
        
    }
    
    func getMapImage(lId: String) {
        
        rainBarView.isHidden = false
        cloudBarView.isHidden = true
        let apiUrl = "https://pw.foreca.com/fw/v4/map?l=\(lId)&w=320&h=329&z=5&v=4.9.8.1153"
        
        //        AF.request(apiUrl).responseData { [self] result in
        //
        //            if let value = result.value
        //            {
        mapViewImg.sd_setImage(with: URL.init(string: apiUrl)) { uiimage, err, cache, url in
            
        }
        //            }
        //        }
    }
    
    
    
    func getPartiMapImage(Id: String, UTCtime: String, baseTime: String, type: String) {
        
        overlappingMapImg.image = UIImage()
        
        let apiUrl = "https://pw.foreca.com/fw/v4/map?l=\(Id)&w=320&h=329&z=5&p=\(type)&t=\(UTCtime)&basetime=\(baseTime)&v=4.9.8.1153"
        
        AF.request(apiUrl).responseData { [self] result in
            if let value = result.value {
                overlappingMapImg.image = UIImage.init(data: value)
            }
        }
        
    }
    
    @IBAction func RainButtonClicked(_ sender: Any)
    {
        cloudBarView.isHidden = true
        rainBarView.isHidden = false
        stepSliderView.index = 0
        overlappingMapImg.image = UIImage()
        getMapdata(rainOrCloudId: 0, locationId: locId)
    }
    
    @IBAction func CloudButtonClicked(_ sender: Any) {
        cloudBarView.isHidden = false
        rainBarView.isHidden = true
        stepSliderView.index = 0
        overlappingMapImg.image = UIImage()
        getMapdata(rainOrCloudId: 1, locationId: locId)
    }
    
    func setDayTimeLbls (Str: String, check: Int)  {
        //Note: bit of a garbage
        let date = Str.split(separator: "T")
        var time = [Substring]()
        if date[1].contains("-") {
            time = date[1].split(separator: "-")
        }
        else {
            time = date[1].split(separator: "+")
        }
        var joint = "\(date[0]) \(time[0])"
        joint.removeLast(1)
        let cDate = strToDate(str: joint)
        let dateStr = dateToStr(date:
                                    cDate)
        let TimeStr = timeformatter(date: cDate)
        let dateArr = dateStr.split(separator: ",")
        let timeArr = TimeStr.split(separator: " ")
        let t1 = timeArr[0].split(separator: ":")
        let Time = "\(t1[0]) \(timeArr[1])"
        let day = "\(dateArr[0])"
        
        if check == 0 {
            
            dayLeadingLbl.text = day
            timeLeadingLbl.text = Time
            DateTimeLbl.text = "\(day), \(Time)"
        }
        else {
            dayTrailingLbl.text = day
            timeTrailingLbl.text = Time
        }
        
        //up untill here we have the initial rain view set up
        //code flows after click of rain/cloud button moving forward
    }
    
    func mapLblSetting(index: Int) {
        if !Observation.isEmpty {
            stepSliderView.maxCount = UInt(Observation.count)
            
            let firstUtcTime = (Observation[index])["time_utc"]  as! String
            setDayTimeLbls(Str: firstUtcTime, check: 0)
            
            let lastUtcTime = (Observation[Observation.count - 1])["time_utc"]  as! String
            setDayTimeLbls(Str: lastUtcTime, check: 1)
            
        }
    }
    
    //MARK:- Drawer
    
    func drawerInit() {
        let window = UIApplication.shared.keyWindow
        viewOpacity.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: window!.frame.size.height)
        viewOpacity.alpha = 0
        window?.addSubview(viewOpacity)
        window?.bringSubviewToFront(viewOpacity)
        
        viewSideBar.frame = CGRect(x: self.view.frame.size.width , y: 0, width: (self.view.frame.size.width * 3)/4, height: window!.frame.size.height)
        window?.addSubview(viewSideBar)
        window?.bringSubviewToFront(viewSideBar)
        
        let tapGesture = UITapGestureRecognizer.init()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        //tapGesture.addTarget(self, action: #selector(<#T##@objc method#>))
        tapGesture.addTarget(self, action: #selector(self.tapped(_ :)))
        viewSideBar.addGestureRecognizer(tapGesture)
        
        let swipeRight = UISwipeGestureRecognizer(target: self,action: #selector(respondToSwipeRightGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self,action: #selector(respondToSwipeLeftGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.viewSideBar.addGestureRecognizer(swipeLeft)
    }
    
    @IBAction func drawerAction(_ sender: Any) {
        bringDrawer()
        sideBar_cv.reloadData()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        resignDrawer()
    }
    
    @objc func respondToSwipeRightGesture(_ sender:UISwipeGestureRecognizer) {
        resignDrawer()
    }
    
    @objc func respondToSwipeLeftGesture(_ sender:UISwipeGestureRecognizer) {
        bringDrawer()
    }
    
    @objc func tapped(_ sender : UITapGestureRecognizer) {
        resignDrawer()
    }
    
    func resignDrawer() {
        //        self.viewOpacity.alpha = 1
        //        self.viewSideBar.frame.origin.x = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.viewSideBar.frame.origin.x = 2 * self.view.frame.size.width
            self.viewOpacity.alpha = 0
        })
    }
    
    func bringDrawer() {
        //        self.viewOpacity.alpha = 0
        //        self.viewSideBar.frame.origin.x = 0 - self.view.frame.size.width
        UIView.animate(withDuration: 0.3, animations: {
            self.viewSideBar.frame.origin.x = 0 + (self.view.frame.size.width * 1)/4
            self.viewOpacity.alpha = 1
        })
    }
    
    
    @IBAction func searchAction(_ sender: Any) {
        resignDrawer()
        performSegue(withIdentifier: "searchSegue", sender: nil)
    }
    
    @IBAction func recenterAction(_ sender: Any) {
        resignDrawer()
        performSegue(withIdentifier: "locationSegue", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "locationSegue" {
            let vc  = segue.destination as! LocatonViewController
            vc.cityname = cityName
            
        }
        else if segue.identifier == "hourlySegue" {
            let vc = segue.destination as! HourlyViewController
            vc.dataArr = value2
        }
        else if segue.identifier == "dailySegue" {
            let vc = segue.destination as! DailyViewController
            vc.DataArr = dailyData
        }
    }
    
    @IBAction func hourlyDetailsAction(_ sender: Any) {
        performSegue(withIdentifier: "hourlySegue", sender: nil)
    }
 
    @IBAction func dailyDetailsBtn(_ sender: Any) {
        //DailyForecasts
        performSegue(withIdentifier: "dailySegue", sender: nil)
    }
}
