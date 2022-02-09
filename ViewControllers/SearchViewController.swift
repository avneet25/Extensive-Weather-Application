

import UIKit
import Alamofire

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchArr = [[String:Any]]()
    var searchFilter = [[String:Any]]()
    var selectedCity = [String:Any]()
    var isSearched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designInit()
        searchBar.becomeFirstResponder()
        tableView.rowHeight = 50
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        
    }
    func designInit() {
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.layer.cornerRadius = 25
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearched {
            return searchFilter.count
        }
        return searchArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableViewCell
        
        
        var partiLocation = [String:Any]()
        
        if isSearched {
            partiLocation = searchFilter[indexPath.row]
        }
        else {
            partiLocation = searchArr[indexPath.row]
        }
        
        let localname =  partiLocation["LocalizedName"]
        
        let adminArea = (partiLocation["AdministrativeArea"] as! [String:Any])["LocalizedName"] as! String
        
        let country = (partiLocation["Country"] as! [String:Any])["ID"] as! String
        
        cell.suggestionLbl.text = "\(localname!), \(adminArea), \(country)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
           selectedCity = searchFilter[indexPath.row]
        
        if let historyArr = UserDefaults.standard.array(forKey: "history") as? [[String:Any]] {
            var tempArr = historyArr
            tempArr.insert(selectedCity, at: 0)
            UserDefaults.standard.set(tempArr , forKey: "history")

        }
        else
        {
            var tempArr = [[String:Any]]()
            tempArr.append(selectedCity)
            UserDefaults.standard.set(tempArr , forKey: "history")
        }
//            NotificationCenter.default.post(name: NSNotification.Name.init("nc"), object: nil, userInfo: selectedCity)
//        navigationController?.popViewController(animated: true)
    
    
        navigationController?.popViewController(animated: true)
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text!.count > 0 {
            //user entered something
            isSearched = true
            getData(textInput: searchBar.text!.lowercased())
            let filter = searchArr.filter { (($0["LocalizedName"] as! String).lowercased()).contains(searchBar.text!.lowercased()) }
            searchFilter = filter
            tableView.reloadData()
        }
        else {
            //blank
            isSearched = false
            tableView.reloadData()
        }
    }
    
    func getData(textInput: String)
    {
        let apiUrl = "XXX"
        
        AF.request(apiUrl).responseJSON { result in
            if let value = result.value as? [[String : Any]] {
                self.searchArr = value
                self.tableView.reloadData()
                
            }
                
        }
        
    }


}
