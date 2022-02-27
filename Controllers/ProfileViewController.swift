
import UIKit
import Firebase

class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,LikeSendDelegate,GetLikeConutProtcol,BlockBlockDelegate {
    
    
    @IBOutlet weak var likeButton: UIButton!
    //★★追記
    @IBOutlet weak var blockBlockButton: UIButton!
    
    var userDataModel:UserDataModel?
    @IBOutlet weak var tableView: UITableView!
    var likeCount = Int()
    var likeFlag = Bool()
    //★★追記
    var bloackFlag = Bool()
    var loadDBModel = LoadDBModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ProfileImageCell.nib(), forCellReuseIdentifier: ProfileImageCell.identifire)
        tableView.register(ProfileTextCell.nib(), forCellReuseIdentifier: ProfileTextCell.identifire)
        tableView.register(ProfileDetailCell.nib(), forCellReuseIdentifier: ProfileDetailCell.identifire)
        
        loadDBModel.getLikeConutProtcol = self
        loadDBModel.loadLikeCount(uuid: (userDataModel?.uid)!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        let sendDBModel = SendDBModel()
        sendDBModel.sendAshiato(aitenoUserID: (userDataModel?.uid)!)
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell") as! ProfileImageCell
        
        switch indexPath.row {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileImageCell.identifire, for: indexPath) as! ProfileImageCell
            cell.configure(profileImageString: (userDataModel?.profileImageString)!, nameLabelString: (userDataModel?.name)!, costLabelString: (userDataModel?.cost)!, quickWordLabelString: (userDataModel?.quickWord)!,jobLabelString: (userDataModel?.job)!, identityLabelString: (userDataModel?.identity)!, likeLabelString: String(likeCount))
            //追記
            cell.delegate = self //必要
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTextCell.identifire, for: indexPath) as! ProfileTextCell
            
            cell.profileTextView.text = userDataModel?.profile
            
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileDetailCell.identifire, for: indexPath) as! ProfileDetailCell
            cell.configure(nameLabelString:  (userDataModel?.name)!, jobLabelString: (userDataModel?.job)!, identityLabelString: (userDataModel?.identity)!, preLabelString:  (userDataModel?.pre)!, meetLabelString: (userDataModel?.meet)!, customerLabelString: (userDataModel?.customer)!, costLabelString: (userDataModel?.cost)!)
            
            return cell
            
        default:
            return UITableViewCell()
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            return 450
        }else if indexPath.row == 2{
            return 370
        }else if indexPath.row == 3{
            return 400
        }
        
        return 1
        
    }
    
    
    @IBAction func likeAction(_ sender: Any) {
        
        //もし自分のIDで無い場合
        if userDataModel?.uid != Auth.auth().currentUser?.uid{
            
            let sendDBModel = SendDBModel()
            sendDBModel.likeSendDelegate = self
            
            if self.likeFlag == false{
                sendDBModel.sendTolike(likeFlag: true, thisUserID: (userDataModel?.uid)!)
                
            }else{
                sendDBModel.sendTolike(likeFlag: false, thisUserID: (userDataModel?.uid)!)
            }
            
        }
        
    }
    
    func like() {
        Util.startAnimation(name: "good", view: self.view)
    }
    
    //★★
    @IBAction func blockAction(_ sender: Any) {
        
        let db = Firestore.firestore()
        let alertController: UIAlertController =
        UIAlertController(title: "本ユーザブロックします", message: "ブロック解除はできません\n※強制退会をご希望の場合は通報下さい。", preferredStyle: .alert)
        
        let actionPositive = UIAlertAction(title: "OK", style: .default){ [self]
            action in
            //★★もし自分のIDで無い場合
            if userDataModel?.uid != Auth.auth().currentUser?.uid{
                
                let sendDBModel = SendDBModel()
                sendDBModel.blockBlockDelegate = self
                
                if self.bloackFlag == false{
                    sendDBModel.bloackUserList(bloackFlag: true, thisUserID: (userDataModel?.uid)!)
                    
                }else{
                    sendDBModel.bloackUserList(bloackFlag: false, thisUserID: (userDataModel?.uid)!)
                }
                
            }
            
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel){
            (action) -> Void in
        }
        alertController.addAction(actionPositive)
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func block() {
        
        let tabVC = self.storyboard?.instantiateViewController(identifier: "tabVC") as! TabBarViewController
        tabVC.modalPresentationStyle = .fullScreen
        self.present(tabVC, animated: true, completion: nil)
        
    }
    
    
    func getLikeCount(likeCount: Int, likeFlag: Bool) {
        
        self.likeFlag = likeFlag
        self.likeCount = likeCount
        if self.likeFlag == false{
            likeButton.setImage(UIImage(named: "notLike"), for: .normal)
            
        }else{
            likeButton.setImage(UIImage(named: "like"), for: .normal)
            
        }
        
        tableView.reloadData()
    }
    
}
