import UIKit
import Firebase
import SDWebImage
import FirebaseAuth

class HumansViewController: UIViewController,GetProfileDataProtocol,GetBloackDataProtocol,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,GetLikeDataProtocol {
    
    
    @IBOutlet weak var ashiatoButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var searchORNot = Bool()
    
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 2.0, bottom: 2.0, right: 2.0)
    
    let itemsPerRow:CGFloat = 2
    var userDataModelArray = [UserDataModel]()
    
    var db = Firestore.firestore()
    
    var loadshitaLikeArray = [String]()
    //★★追記
    var bloackshitaArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Util.rectButton2(button: searchButton)
        Util.rectButton2(button: ashiatoButton)
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillEnterForeground(_:)), name: UIScene.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground(_:)), name: UIScene.didEnterBackgroundNotification, object: nil)
        
        
        if Auth.auth().currentUser?.uid != nil && searchORNot == false{
            
            collectionView.delegate = self
            collectionView.dataSource = self
            
            //自分のユーザデータを取り出す
            let userData = KeyChainConfig.getKeyArrayData(key: "userData")
            
            //受信します
            let loadDBModel = LoadDBModel()
            loadDBModel.getProfileDataProtocol = self
            loadDBModel.getBloackDataProtocol = self
            loadDBModel.getLikeDataProtocol = self
            loadDBModel.loadUsersProfile(customer: userData["customer"] as? String ?? "")
            loadDBModel.loadUsersProfile2(customer: userData["customer"] as? String ?? "")
            loadDBModel.loadLikeList()
            loadDBModel.loadBloackList()
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(Auth.auth().currentUser!.uid).setData(
                
                ["customer":userData["customer"] as Any,"uid":userData["uid"] as Any,"name":userData["name"] as Any,"cost":userData["cost"] as Any,"pre":userData["pre"] as Any,"job":userData["job"] as Any,"identity":userData["identity"] as Any,"profile":userData["profile"] as Any,"profileImageString":userData["profileImageString"] as Any,"quickWord":userData["quickWord"] as Any,"meet":userData["meet"] as Any]
            )

            loadDBModel.loadMatchingPersonData()
            
        }else if Auth.auth().currentUser?.uid != nil && searchORNot == true{

            collectionView.reloadData()
            
        }
    }
    
    @objc func viewWillEnterForeground(_ notification:Notification?){
        Util.updateOnlineStatus(onlineORNot: true)
    }
    
    @objc func didEnterBackground(_ notification:Notification?){
        //★★追記
        Util.updateOnlineStatus(onlineORNot: false)
    }
    
    func getProfileData(userDataModelArray: [UserDataModel]) {

        var deleteArray = [Int]()
        var count = 0

        //いいねしたならセルへ表示しない
        loadshitaLikeArray = []
        self.userDataModelArray = userDataModelArray
        loadshitaLikeArray = KeyChainConfig.getKeyArrayListData(key: "ownLikeList")

        for i in 0..<self.userDataModelArray.count{

            if loadshitaLikeArray.contains(self.userDataModelArray[i].uid!) == true{

                deleteArray.append(i)

            }

        }

        for i in 0..<deleteArray.count{

            print(deleteArray.count,i)
            print(self.userDataModelArray.count)
            print(deleteArray.debugDescription)
            print(count)
            print(deleteArray[i] - count)

            self.userDataModelArray.remove(at: deleteArray[i] - count)
            count += 1

        }

        collectionView.reloadData()

    }
    
    
//★★追記
    func getBloackData(userDataModelArray: [UserDataModel]) {

        var deleteArray = [Int]()
        var count = 0

        //ブロックしたならセルへ表示しない
        bloackshitaArray = []
        self.userDataModelArray = userDataModelArray
        bloackshitaArray = KeyChainConfig.getKeyArrayListData(key: "bloackUserList")

        for i in 0..<self.userDataModelArray.count{

            if bloackshitaArray.contains(self.userDataModelArray[i].uid!) == true{

                deleteArray.append(i)

            }

        }

        for i in 0..<deleteArray.count{

            print(deleteArray.count,i)
            print(self.userDataModelArray.count)
            print(deleteArray.debugDescription)
            print(count)
            print(deleteArray[i] - count)

            self.userDataModelArray.remove(at: deleteArray[i] - count)
            count += 1

        }

        collectionView.reloadData()

    }
    

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return userDataModelArray.count
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem + 42)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
        
    }
    
    //セルの行間
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        //セルと構築、返す
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        //セルに効果　ex.影など
        cell.layer.borderWidth = 0.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = true
        
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        imageView.sd_setImage(with: URL(string: userDataModelArray[indexPath.row].profileImageString!), completed: nil)
        imageView.layer.cornerRadius = imageView.frame.width * 0.3
        
        let quickWordLabel = cell.contentView.viewWithTag(2)as! UILabel
        quickWordLabel.text = userDataModelArray[indexPath.row].quickWord
        
        let onLineMarkImageView = cell.contentView.viewWithTag(3) as! UIImageView
        onLineMarkImageView.layer.cornerRadius = onLineMarkImageView.frame.width/2
        
        if userDataModelArray[indexPath.row].onlineORNot == true{
            
            onLineMarkImageView.image = UIImage(named: "online")
        }else{
            onLineMarkImageView.image = UIImage(named: "offLine")
        }
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let profileVC = self.storyboard?.instantiateViewController(identifier: "profileVC") as! ProfileViewController
        profileVC.userDataModel = userDataModelArray[indexPath.row]
        self.navigationController?.pushViewController(profileVC, animated: true)
        
        
    }
    
    
    @IBAction func search(_ sender: Any) {
        
        performSegue(withIdentifier: "searchVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "searchVC"{
            
            let userData = KeyChainConfig.getKeyArrayData(key: "userData")
            
            //遷移先のControllerを取得
            let searchVC = segue.destination as? SearchViewController
            searchVC?.userData = userData["customer"] as? String ?? ""

            //遷移先のpropertyに処理ごと渡す
            searchVC?.resultHandler = { userDataModelArray,searchDone in
                
                self.searchORNot = searchDone
                self.userDataModelArray = userDataModelArray
                self.collectionView.reloadData()
                
            }
            
            
        }
        
    }
    
    func getLikeDataProtocol(userDataModelArray: [UserDataModel]) {
        var count = 0
        
        var likeArray = [Int]()
        
        for i in 0..<userDataModelArray.count{
            if self.userDataModelArray.contains(userDataModelArray[i]) == true{
                likeArray.append(i)
            }
            
        }
        
        for i in 0..<likeArray.count{
            self.userDataModelArray.remove(at: likeArray[i] - count)
            count += 1
        }
        
        print(self.userDataModelArray.count)
        print(self.userDataModelArray.debugDescription)
        
        self.collectionView.reloadData()
    }

}
