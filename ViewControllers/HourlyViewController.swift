
import UIKit
import ScrollableGraphView

class HourlyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ScrollableGraphViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollGraph: ScrollableGraphView!
    @IBOutlet weak var tempBAr: UIView!
    @IBOutlet weak var windBAr: UIView!
    @IBOutlet weak var rainBar: UIView!
    var dataArr = [[String:Any]]()
    var graphTimeArr = [String]()
    var parentArr = [[Double]](repeating: [], count: 3)
    var flag = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getData()
        rainBar.isHidden = true
        windBAr.isHidden = true
        
        tableView.rowHeight = 90
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 8)
        
        designGraph()
   
    }
    func getData()
    {
        for elemant in dataArr
        {
            let dateTime = elemant["DateTime"] as! String
            let date = dateTime.split(separator: "T")
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
            let time2 = str.split(separator: ":")
            let time3 = time2[1].split(separator: " ")
            graphTimeArr.append("\(time2[0]) \(time3[1])")
            
            let tempDict = elemant["Temperature"] as! [String:Any]
            let tempValue = tempDict["Value"] as! Double
            parentArr[0].append(tempValue)
            
            let rainDict = elemant["Rain"] as! [String:Any]
            let rainValue = rainDict["Value"] as! Double
            parentArr[1].append(rainValue)
            
            let windDict = elemant["Wind"] as! [String:Any]
            let speedDict = windDict["Speed"] as! [String:Any]
            let speedValue = speedDict["Value"] as! Double
            parentArr[2].append(speedValue)
        }
        
        

    }
    func designGraph() {
        
        scrollGraph.dataSource = self
        let linePlot = LinePlot(identifier: "darkLine")
        linePlot.lineWidth = 1
        //linePlot.lineColor = UIColor.colorFromHex(hexString: "#777777")
        linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth

        linePlot.shouldFill = true
        linePlot.fillType = ScrollableGraphViewFillType.gradient
        linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
        linePlot.fillGradientStartColor = UIColor.systemYellow
        linePlot.fillGradientEndColor = UIColor.clear

        linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic

        let dotPlot = DotPlot(identifier: "darkLineDot") // Add dots as well.
        dotPlot.dataPointSize = 2
        dotPlot.dataPointFillColor = UIColor.white

        dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic

        // Setup the reference lines.
        let referenceLines = ReferenceLines()

        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white

        //referenceLines.includeMinMax
        referenceLines.positionType = .relative
        referenceLines.absolutePositions = parentArr[flag]

        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)

        // Setup the graph
        //scrollGraph.backgroundFillColor = UIColor.colorFromHex(hexString: "#333333")
        scrollGraph.dataPointSpacing = 60

        scrollGraph.shouldAnimateOnStartup = true
        scrollGraph.shouldAdaptRange = true
        scrollGraph.shouldRangeAlwaysStartAtZero = false

        //scrollGraph.rangeMax = parentArr[flag].max() ?? default value

        // Add everything to the graph.
        scrollGraph.addReferenceLines(referenceLines: referenceLines)
        scrollGraph.addPlot(plot: linePlot)
        scrollGraph.addPlot(plot: dotPlot)
        
    }
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        
        
        switch(plot.identifier) {
        case "darkLine":
            return parentArr[flag][pointIndex]
        case "darkLineDot":
            return parentArr[flag][pointIndex]
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String
    {
        return graphTimeArr[pointIndex]
    }
    
    func numberOfPoints() -> Int
    {
        return dataArr.count
    }
    
    func plotGraph() {
  
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableViewCell
        
        let elemant = dataArr[indexPath.row]
        cell.HourlyTimelbl.text = "\(graphTimeArr[indexPath.row])"
        cell.hourlyTempLbl.text = "\(Int(parentArr[0][indexPath.row]))°"
        let rainVal = String(format: "%.1f", parentArr[1][indexPath.row])
        cell.hourlyRainLbl.text = "\(rainVal) mm"
        cell.hourlyWindLbl.text = "\((Int(parentArr[2][indexPath.row]))) km/h"
        let relativeHumidity = elemant["RelativeHumidity"] as! Double
        cell.hourlyHumidityLbl.text = "\(Int(relativeHumidity))%"
        cell.hourlyW_icon.image = getIcon(iconNumber: elemant["WeatherIcon"] as! Int, isDayorNot: elemant["IsDaylight"] as! Bool)
   
        
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
    func timeformatter(date: Date) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let string = dateFormatter.string(from: date as Date)
        
        return string
    }
    @IBAction func backBtn(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func tempClicked(_ sender: Any) {
        tempBAr.isHidden = false
        rainBar.isHidden = true
        windBAr.isHidden = true
        flag = 0
        designGraph()
    }
    @IBAction func rainClicked(_ sender: Any) {
        rainBar.isHidden = false
        tempBAr.isHidden = true
        windBAr.isHidden = true
        flag = 1
        designGraph()
    }
    @IBAction func windClicked(_ sender: Any) {
        windBAr.isHidden = false
        rainBar.isHidden = true
        tempBAr.isHidden = true
        flag = 2
        designGraph()
    }
    
}
