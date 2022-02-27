import UIKit
import Firebase
import SDWebImage

class AshiatoViewController: MatchListViewController,GetAshiatoDataProtocol {
    
    
    var loadDBModel = LoadDBModel()
    var userDataModelArray2 = [UserDataModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        loadDBModel.getAshiatoDataProtocol = self
        loadDBModel.loadAshiatoData()
        tableView.register(MatchPersonCell.nib(), forCellReuseIdentifier: MatchPersonCell.identifier)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userDataModelArray2.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MatchPersonCell.identifier, for: indexPath) as? MatchPersonCell
        cell?.configure(nameLabelString: userDataModelArray2[indexPath.row].name!, jobLabelString: userDataModelArray2[indexPath.row].job!, quickWordLabelString: userDataModelArray2[indexPath.row].quickWord!, profileImageViewString: userDataModelArray2[indexPath.row].profileImageString!)
        
        return cell!
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileVC = self.storyboard?.instantiateViewController(identifier: "profileVC2") as! ProfileViewController
        profileVC.userDataModel = userDataModelArray2[indexPath.row]
        self.navigationController?.pushViewController(profileVC, animated: true)
        
    }
    
    func getAshiatoDataProtocol(userDataModelArray: [UserDataModel]) {
        
        self.userDataModelArray2 = userDataModelArray
        tableView.reloadData()
        
    }
    
}
