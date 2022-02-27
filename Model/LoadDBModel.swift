
import UIKit
import Foundation
import FirebaseAuth
import Firebase

protocol GetProfileDataProtocol {
    
    func getProfileData(userDataModelArray:[UserDataModel])
    
}

//★★追記
protocol GetBloackDataProtocol {
    func getBloackData(userDataModelArray:[UserDataModel])
}

//★★★追記
protocol GetBloackDataProtocol2 {
    func getBloackData2(userDataModelArray:[UserDataModel])
}

protocol GetLikeConutProtcol {
    func getLikeCount(likeCount:Int,likeFlag:Bool)
    
}

protocol GetLikeDataProtocol {
    func getLikeDataProtocol(userDataModelArray:[UserDataModel])
}

//★★追記
protocol BloackDataProtocol {
    func bloackDataProtocol(userDataModelArray:[UserDataModel])
}

//★★★追記
protocol BloackDataProtocol2 {
    func bloackDataProtocol2(userDataModelArray:[UserDataModel])
}


protocol GetWhoisMatchListProtocol {
    func getWhoisMatchListProtocol(userDataModelArray:[UserDataModel])
}

protocol GetAshiatoDataProtocol {
    func getAshiatoDataProtocol(userDataModelArray:[UserDataModel])
}

protocol GetSearchResultProtocol {
    func getSearchResultProtocol(userDataModelArray:[UserDataModel],searchDone:Bool)
}


class LoadDBModel: UIViewController {
    
    var db = Firestore.firestore()
    var profileModelArray = [UserDataModel]()
    var getProfileDataProtocol:GetProfileDataProtocol?
    //★★追記
    var getBloackDataProtocol:GetBloackDataProtocol?
    //★★★追記
    var getBloackDataProtocol2:GetBloackDataProtocol2?
    
    var getLikeConutProtcol:GetLikeConutProtcol?
    var getLikeDataProtocol:GetLikeDataProtocol?
    //★★追記
    var bloackDataProtocol:BloackDataProtocol?
    
    //★★★追記
    var bloackDataProtocol2:BloackDataProtocol2?
    
    var getWhoisMatchListProtocol:GetWhoisMatchListProtocol?
    var getAshiatoDataProtocol:GetAshiatoDataProtocol?
    var getSearchResultProtocol:GetSearchResultProtocol?
    
    //9/23追加
    var matchingIDArray = [String]()
    
    //ユーザデータを受信する
    func loadUsersProfile(customer:String){
        
        //★10/1記載　もしいいねした人がいるならそれを飛ばす
        let ownLikeListArray = KeyChainConfig.getKeyArrayListData(key: "ownLikeList")
        //★★追記
        //        let bloackUserListArray = KeyChainConfig.getKeyArrayListData(key: "bloackUserList")
        
        db.collection("Users").whereField("customer", isNotEqualTo: customer).addSnapshotListener { snapShot, error in
            
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                
                self.profileModelArray = []
                for doc in snapShotDoc{
                    let data = doc.data()
                    
                    if ownLikeListArray.contains(data["uid"] as! String) != true{
                        
                        if let name = data["name"] as? String,let cost = data["cost"] as? String,let identity = data["identity"] as? String,let job = data["job"] as? String,let meet = data["meet"] as? String,let customer = data["customer"] as? String,let pre = data["pre"] as? String,let profile = data["profile"] as? String,let profileImageString = data["profileImageString"] as? String,let uid = data["uid"] as? String,let quickWord = data["quickWord"] as? String,let onlineORNot = data["onlineORNot"] as? Bool{
                            
                            let userDataModel = UserDataModel(name: name, cost: cost, pre: pre, job: job, identity: identity, customer: customer, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, meet: meet, date: 0, onlineORNot: onlineORNot)
                            
                            self.profileModelArray.append(userDataModel)
                            
                        }
                        
                    }
                    
                }
                
                self.getProfileDataProtocol?.getProfileData(userDataModelArray: self.profileModelArray)
                
            }
            
            
        }
        
        
    }
    
    func loadUsersProfile2(customer:String){
        
        let bloackUserListArray = KeyChainConfig.getKeyArrayListData(key: "bloackUserList")
        
        db.collection("Users").whereField("customer", isNotEqualTo: customer).addSnapshotListener { snapShot, error in
            
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                
                self.profileModelArray = []
                for doc in snapShotDoc{
                    let data = doc.data()
                    
                    if bloackUserListArray.contains(data["uid"] as! String) != true{
                        
                        if let name = data["name"] as? String,let cost = data["cost"] as? String,let identity = data["identity"] as? String,let job = data["job"] as? String,let meet = data["meet"] as? String,let customer = data["customer"] as? String,let pre = data["pre"] as? String,let profile = data["profile"] as? String,let profileImageString = data["profileImageString"] as? String,let uid = data["uid"] as? String,let quickWord = data["quickWord"] as? String,let onlineORNot = data["onlineORNot"] as? Bool{
                            
                            let userDataModel = UserDataModel(name: name, cost: cost, pre: pre, job: job, identity: identity, customer: customer, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, meet: meet, date: 0, onlineORNot: onlineORNot)
                            
                            self.profileModelArray.append(userDataModel)
                            
                        }
                        
                    }
                    
                }
                //★★追記
                self.getBloackDataProtocol?.getBloackData(userDataModelArray: self.profileModelArray)
                
            }
            
            
        }
        
        
    }
    
    
    //★★★ユーザデータを受信する
    func loadUsersProfile3(customer:String){
        
        let bloackUserListArray2 = KeyChainConfig.getKeyArrayListData(key: "bloackUserList2")
        
        db.collection("Users").whereField("customer", isNotEqualTo: customer).addSnapshotListener { snapShot, error in
            
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                
                self.profileModelArray = []
                for doc in snapShotDoc{
                    let data = doc.data()
                    
                    if bloackUserListArray2.contains(data["uid"] as! String) != true{
                        
                        if let name = data["name"] as? String,let cost = data["cost"] as? String,let identity = data["identity"] as? String,let job = data["job"] as? String,let meet = data["meet"] as? String,let customer = data["customer"] as? String,let pre = data["pre"] as? String,let profile = data["profile"] as? String,let profileImageString = data["profileImageString"] as? String,let uid = data["uid"] as? String,let quickWord = data["quickWord"] as? String,let onlineORNot = data["onlineORNot"] as? Bool{
                            
                            let userDataModel = UserDataModel(name: name, cost: cost, pre: pre, job: job, identity: identity, customer: customer, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, meet: meet, date: 0, onlineORNot: onlineORNot)
                            
                            self.profileModelArray.append(userDataModel)
                            
                        }
                        
                    }
                    
                }
                //★★追記
                self.getBloackDataProtocol2?.getBloackData2(userDataModelArray: self.profileModelArray)
                
            }
            
            
        }
        
        
    }
    
    func loadLikeCount(uuid:String){
        
        var likeFlag = Bool()
        db.collection("Users").document(uuid).collection("like").addSnapshotListener
        { snapShot, error in
            
            if error != nil{
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                
                for doc in snapShotDoc{
                    let data = doc.data()
                    if doc.documentID == Auth.auth().currentUser?.uid{
                        if let like = data["like"] as? Bool{
                            
                            likeFlag = like
                            
                        }
                        
                        
                    }
                    
                }
                
                let docCount = snapShotDoc.count
                self.getLikeConutProtcol?.getLikeCount(likeCount: docCount, likeFlag: likeFlag)
                
                
            }
            
        }
    }
    
    func loadLikeList(){
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("like").addSnapshotListener { snapShot, error in
            
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                
                self.profileModelArray = []
                for doc in snapShotDoc{
                    let data = doc.data()
                    if let name = data["name"] as? String,let cost = data["cost"] as? String,let identity = data["identity"] as? String,let job = data["job"] as? String,let meet = data["meet"] as? String,let customer = data["customer"] as? String,let pre = data["pre"] as? String,let profile = data["profile"] as? String,let profileImageString = data["profileImageString"] as? String,let uid = data["uid"] as? String,let quickWord = data["quickWord"] as? String{
                        
                        let userDataModel = UserDataModel(name: name, cost: cost, pre: pre, job: job, identity: identity, customer: customer, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, meet: meet, date: 0, onlineORNot: true)
                        
                        self.profileModelArray.append(userDataModel)
                        
                    }
                }
                
                self.getLikeDataProtocol?.getLikeDataProtocol(userDataModelArray: self.profileModelArray)
                
            }
            
            
        }
        
        
    }
    
    //★★追記
    func loadBloackList(){
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("block").addSnapshotListener { snapShot, error in
            
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                
                self.profileModelArray = []
                for doc in snapShotDoc{
                    let data = doc.data()
                    if let name = data["name"] as? String,let cost = data["cost"] as? String,let identity = data["identity"] as? String,let job = data["job"] as? String,let meet = data["meet"] as? String,let customer = data["customer"] as? String,let pre = data["pre"] as? String,let profile = data["profile"] as? String,let profileImageString = data["profileImageString"] as? String,let uid = data["uid"] as? String,let quickWord = data["quickWord"] as? String{
                        
                        let userDataModel = UserDataModel(name: name, cost: cost, pre: pre, job: job, identity: identity, customer: customer, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, meet: meet, date: 0, onlineORNot: true)
                        
                        self.profileModelArray.append(userDataModel)
                        
                    }
                }
                
                self.bloackDataProtocol?.bloackDataProtocol(userDataModelArray: self.profileModelArray)
                
            }
            
            
        }
        
        
    }
    
    
    
    //★★★追記
    func loadBloackList2(){
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("block2").addSnapshotListener { snapShot, error in
            
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                
                self.profileModelArray = []
                for doc in snapShotDoc{
                    let data = doc.data()
                    if let name = data["name"] as? String,let cost = data["cost"] as? String,let identity = data["identity"] as? String,let job = data["job"] as? String,let meet = data["meet"] as? String,let customer = data["customer"] as? String,let pre = data["pre"] as? String,let profile = data["profile"] as? String,let profileImageString = data["profileImageString"] as? String,let uid = data["uid"] as? String,let quickWord = data["quickWord"] as? String{
                        
                        let userDataModel = UserDataModel(name: name, cost: cost, pre: pre, job: job, identity: identity, customer: customer, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, meet: meet, date: 0, onlineORNot: true)
                        
                        self.profileModelArray.append(userDataModel)
                        
                    }
                }
                
                self.bloackDataProtocol2?.bloackDataProtocol2(userDataModelArray: self.profileModelArray)
                
            }
            
            
        }
        
        
    }
    
    
    func loadMatchingPersonData(){
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").addSnapshotListener {
            snapShot, error in
            
            if error != nil{
                return
            }
            
            
            if let snapShotDoc = snapShot?.documents{
                
                self.profileModelArray = []
                for doc in snapShotDoc{
                    
                    let data = doc.data()
                    if let name = data["name"] as? String,let cost = data["cost"] as? String,let identity = data["identity"] as? String,let job = data["job"] as? String,let meet = data["meet"] as? String,let customer = data["customer"] as? String,let pre = data["pre"] as? String,let profile = data["profile"] as? String,let profileImageString = data["profileImageString"] as? String,let uid = data["uid"] as? String,let quickWord = data["quickWord"] as? String{
                        
                        self.matchingIDArray = KeyChainConfig.getKeyArrayListData(key: "matchingID")
                        
                        if self.matchingIDArray.contains(where: {$0 == uid}) == false{
                            
                            if uid == Auth.auth().currentUser?.uid{
                                
                                self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(Auth.auth().currentUser!.uid).delete()
                                
                            }else{
                                Util.matchiNotification(name: name, id: uid)
                                
                                self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(Auth.auth().currentUser!.uid).delete()
                                
                                self.matchingIDArray.append(uid)
                                KeyChainConfig.setKeyArrayData(value: self.matchingIDArray, key: "matchingID")
                            }
                        }
                        
                        let userDataModel = UserDataModel(name: name, cost: cost, pre: pre, job: job, identity: identity, customer: customer, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, meet: meet, date: 0, onlineORNot: true)
                        self.profileModelArray.append(userDataModel)
                        
                        
                    }
                    
                }
                
                self.getWhoisMatchListProtocol?.getWhoisMatchListProtocol(userDataModelArray:self.profileModelArray)
                
                
            }
            
            
            
        }
        
        
    }
    
    func loadAshiatoData(){
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("ashiato").order(by: "date").addSnapshotListener { snapShot, error in
            
            if error != nil{
                return
                
            }
            
            if let snapShotDoc = snapShot?.documents{
                
                self.profileModelArray = []
                for doc in snapShotDoc{
                    
                    let data = doc.data()
                    if let name = data["name"] as? String,let cost = data["cost"] as? String,let identity = data["identity"] as? String,let job = data["job"] as? String,let meet = data["meet"] as? String,let customer = data["customer"] as? String,let pre = data["pre"] as? String,let profile = data["profile"] as? String,let profileImageString = data["profileImageString"] as? String,let uid = data["uid"] as? String,let quickWord = data["quickWord"] as? String,let date = data["date"] as? Double{
                        
                        let userDataModel = UserDataModel(name: name, cost: cost, pre: pre, job: job, identity: identity, customer: customer, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, meet: meet, date: date, onlineORNot: true)
                        self.profileModelArray.append(userDataModel)
                        
                    }
                    
                    
                }
                
                self.getAshiatoDataProtocol?.getAshiatoDataProtocol(userDataModelArray: self.profileModelArray)
                
            }
            
        }
        
    }
    
    
    func loadSearch(job:String,identity:String,userData:String){
        
        db.collection("Users").whereField("job", isEqualTo: job).whereField("identity", isEqualTo: identity).addSnapshotListener { snapShot, error in
            
            
            if error != nil{
                
                print(error.debugDescription)
                return
                
            }
            
            if let snapShotDoc = snapShot?.documents{
                
                self.profileModelArray = []
                for doc in snapShotDoc{
                    
                    let data = doc.data()
                    if let name = data["name"] as? String,let cost = data["cost"] as? String,let identity = data["identity"] as? String,let job = data["job"] as? String,let meet = data["meet"] as? String,let customer = data["customer"] as? String,let pre = data["pre"] as? String,let profile = data["profile"] as? String,let profileImageString = data["profileImageString"] as? String,let uid = data["uid"] as? String,let quickWord = data["quickWord"] as? String,let onlineORNot = data["onlineORNot"] as? Bool {
                        
                        let userDataModel = UserDataModel(name: name, cost: cost, pre: pre, job: job, identity: identity, customer: customer, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, meet: meet, date: 0, onlineORNot: onlineORNot)
                        
                        self.profileModelArray.append(userDataModel)
                        self.profileModelArray = self.profileModelArray.filter({
                            
                            $0.job == job && $0.identity == identity && $0.customer != userData
                            
                        })
                        
                        
                    }
                }
                
                self.getSearchResultProtocol?.getSearchResultProtocol(userDataModelArray: self.profileModelArray, searchDone: true)
                
            }
            
        }
        
        
    }
    
    
}
