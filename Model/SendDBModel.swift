import Foundation
import FirebaseAuth
import Firebase

protocol ProfileSendDone {
    
    func profileSendDone()
    
    
}

protocol LikeSendDelegate {
    
    func like()
    
}

//★★追記
protocol BlockBlockDelegate {

    func block()

}

//★★★追記
protocol BlockBlockDelegate2 {

    func block2()

}

protocol GetAttachProtocol {
    func getAttachProtocol(attachImageString:String)
    
}



class SendDBModel{
    
    let db = Firestore.firestore()
    var profileSendDone:ProfileSendDone?
    var likeSendDelegate:LikeSendDelegate?
    //★★追記
    var blockBlockDelegate:BlockBlockDelegate?

    //★★★追記
    var blockBlockDelegate2:BlockBlockDelegate2?
    
    
    var getAttachProtocol:GetAttachProtocol?
    
    func sendProfileData(userData:UserDataModel,profileImageData:Data){
        
        let imageRef = Storage.storage().reference().child("ProfileImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpeg")
        
        imageRef.putData(profileImageData, metadata: nil) {
            metaData, error in
            
            if error != nil{
                return
            }
            
            imageRef.downloadURL{ url, error in
                if error != nil{
                    return
                }
                
                if url != nil{
                    
                    self.db.collection("Users").document(Auth.auth().currentUser!.uid).setData(
                        
                        ["name":userData.name as Any, "cost":userData.cost as Any, "pre":userData.pre as Any, "job":userData.job as Any, "identity":userData.identity as Any, "customer":userData.customer as Any, "profile":userData.profile as Any, "profileImageString":url?.absoluteString as Any,"uid":Auth.auth().currentUser!.uid as Any,"quickWord":userData.quickWord as Any,"meet":userData.meet as Any,"onlineORNot":userData.onlineORNot as Any]
                    
                    )
                    
                    KeyChainConfig.setKeyData(value:["name":userData.name as Any,"cost":userData.cost as Any, "pre":userData.pre as Any, "job":userData.job as Any, "identity":userData.identity as Any, "customer":userData.customer as Any, "profile":userData.profile as Any, "profileImageString":url?.absoluteString as Any,"uid":Auth.auth().currentUser!.uid as Any,"quickWord":userData.quickWord as Any,"meet":userData.meet as Any], key: "userData")
                    
                    self.profileSendDone?.profileSendDone()
                    
                }
                
            }
        }
    }

    func sendTolike(likeFlag:Bool,thisUserID:String){
        
        if likeFlag == false{
            
            self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).setData(["like":false])
            deleteToLike(thisUserID: thisUserID)
            
            var ownLikeListArray = KeyChainConfig.getKeyArrayListData(key: "ownLikeList")
            ownLikeListArray.removeAll(where: {$0 == thisUserID})
            KeyChainConfig.setKeyArrayData(value: ownLikeListArray, key: "ownLikeList")
            
            print(ownLikeListArray.debugDescription)
            
        }else if likeFlag == true{
            
            let userData = KeyChainConfig.getKeyArrayData(key: "userData")
            
            self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).setData(["like":true,"customer":userData["customer"] as Any,"uid":userData["uid"] as Any,"name":userData["name"] as Any,"cost":userData["cost"] as Any,"pre":userData["pre"] as Any,"job":userData["job"] as Any,"identity":userData["identity"] as Any,"profile":userData["profile"] as Any,"profileImageString":userData["profileImageString"] as Any,"quickWord":userData["quickWord"] as Any,"meet":userData["meet"] as Any])
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("ownLiked").document(thisUserID).setData(["like":true,"customer":userData["customer"] as Any,"uid":userData["uid"] as Any,"name":userData["name"] as Any,"cost":userData["cost"] as Any,"pre":userData["pre"] as Any,"job":userData["job"] as Any,"identity":userData["identity"] as Any,"profile":userData["profile"] as Any,"profileImageString":userData["profileImageString"] as Any,"quickWord":userData["quickWord"] as Any,"meet":userData["meet"] as Any])
            
            var ownLikeListArray = KeyChainConfig.getKeyArrayListData(key: "ownLikeList")
            ownLikeListArray.append(thisUserID)
            KeyChainConfig.setKeyArrayData(value: ownLikeListArray, key: "ownLikeList")
            
            
            //ライクが終わったよ
            self.likeSendDelegate?.like()
            
        }
        
    }
    
    func deleteToLike(thisUserID:String){
        
        self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).delete()
        
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("like").document(thisUserID).delete()

        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("ownLiked").document(thisUserID).delete()
        
    }
    
    func sendToLikeFromLike(likeFlag:Bool,thisUserID:String,matchName:String,matchID:String){
        
        if likeFlag == false{
            
            self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).setData(["like":false])
            deleteToLike(thisUserID: thisUserID)
            var ownLikeListArray = KeyChainConfig.getKeyArrayListData(key: "ownLikeList")
            ownLikeListArray.removeAll(where: {$0 == thisUserID})
            KeyChainConfig.setKeyArrayData(value: ownLikeListArray, key: "ownLikeList")
            
            
        }else if likeFlag == true {
            
            let userData = KeyChainConfig.getKeyArrayData(key: "userData")
            self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).setData(["like":true,"customer":userData["customer"] as Any,"uid":userData["uid"] as Any,"name":userData["name"] as Any,"cost":userData["cost"] as Any,"pre":userData["pre"] as Any,"job":userData["job"] as Any,"identity":userData["identity"] as Any,"profile":userData["profile"] as Any,"profileImageString":userData["profileImageString"] as Any,"quickWord":userData["quickWord"] as Any,"meet":userData["meet"] as Any])
            
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("ownLiked").document(thisUserID).setData(["like":true,"customer":userData["customer"] as Any,"uid":userData["uid"] as Any,"name":userData["name"] as Any,"cost":userData["cost"] as Any,"pre":userData["pre"] as Any,"job":userData["job"] as Any,"identity":userData["identity"] as Any,"profile":userData["profile"] as Any,"profileImageString":userData["profileImageString"] as Any,"quickWord":userData["quickWord"] as Any,"meet":userData["meet"] as Any])
            
            
            var ownLikeListArray = KeyChainConfig.getKeyArrayListData(key: "ownLikeList")
            ownLikeListArray.append(thisUserID)
            KeyChainConfig.setKeyArrayData(value: ownLikeListArray, key: "ownLikeList")

            Util.matchiNotification(name: matchName, id: matchID)
            
            deleteToLike(thisUserID: Auth.auth().currentUser!.uid)
            deleteToLike(thisUserID: matchID)
            
            self.db.collection("Users").document(matchID).collection("matching").document(matchID).delete()
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(Auth.auth().currentUser!.uid).delete()
            
            
            self.likeSendDelegate?.like()
            
        }
        
    }
    
    func sendToMatchingList(thisUserID:String,name:String,cost:String,pre:String,customer:String,profile:String,profileImageString:String,uid:String,job:String,identity:String,quickWord:String,meet:String,userData:[String:Any]){
        
        if thisUserID == uid{
            
            self.db.collection("Users").document(thisUserID).collection("matching").document(Auth.auth().currentUser!.uid).setData(

                ["customer":userData["customer"] as Any,"uid":userData["uid"] as Any,"name":userData["name"] as Any,"cost":userData["cost"] as Any,"pre":userData["pre"] as Any,"job":userData["job"] as Any,"identity":userData["identity"] as Any,"profile":userData["profile"] as Any,"profileImageString":userData["profileImageString"] as Any,"quickWord":userData["quickWord"] as Any,"meet":userData["meet"] as Any]
            )
                
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(thisUserID).setData(
            
            ["customer":customer as Any,"uid":uid as Any,"name":name as Any,"cost":cost as Any,"pre":pre as Any,"job":job as Any,"identity":identity as Any,"profile":profile as Any,"profileImageString":profileImageString as Any,"quickWord":quickWord as Any,"meet":meet as Any]
            
            )
            
        }else{
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(thisUserID).setData(
            
                ["customer":customer as Any,"uid":uid as Any,"name":name as Any,"cost":cost as Any,"pre":pre as Any,"job":job as Any,"identity":identity as Any,"profile":profile as Any,"profileImageString":profileImageString as Any,"quickWord":quickWord as Any,"meet":meet as Any]
            
            )
            
        }
        
        self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).delete()
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("like").document(thisUserID).delete()
        

        

    }
    
    //★★追記
    func bloackUserList(bloackFlag:Bool,thisUserID:String){
        //まだブロックしていない状態
        if bloackFlag == false{
            
            //★★.collection("blockUser") ??
            self.db.collection("Users").document(thisUserID).collection("block").document(Auth.auth().currentUser!.uid).setData(["block":false])
            //消す
            deleteToBloack(thisUserID: thisUserID)
            
            var bloackUserListArray = KeyChainConfig.getKeyArrayListData(key: "bloackUserList")
            bloackUserListArray.removeAll(where: {$0 == thisUserID})
            KeyChainConfig.setKeyArrayData(value: bloackUserListArray, key: "bloackUserList")
            
            print(bloackUserListArray.debugDescription)
            
        }else if bloackFlag == true{
            
            let userData = KeyChainConfig.getKeyArrayData(key: "userData")
            
            self.db.collection("Users").document(thisUserID).collection("block").document(Auth.auth().currentUser!.uid).setData(["block":true,"customer":userData["customer"] as Any,"uid":userData["uid"] as Any,"name":userData["name"] as Any,"cost":userData["cost"] as Any,"pre":userData["pre"] as Any,"job":userData["job"] as Any,"identity":userData["identity"] as Any,"profile":userData["profile"] as Any,"profileImageString":userData["profileImageString"] as Any,"quickWord":userData["quickWord"] as Any,"meet":userData["meet"] as Any])
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("blockUser").document(thisUserID).setData(["like":true,"customer":userData["customer"] as Any,"uid":userData["uid"] as Any,"name":userData["name"] as Any,"cost":userData["cost"] as Any,"pre":userData["pre"] as Any,"job":userData["job"] as Any,"identity":userData["identity"] as Any,"profile":userData["profile"] as Any,"profileImageString":userData["profileImageString"] as Any,"quickWord":userData["quickWord"] as Any,"meet":userData["meet"] as Any])
            
            var bloackUserListArray = KeyChainConfig.getKeyArrayListData(key: "bloackUserList")
            bloackUserListArray.append(thisUserID)
            KeyChainConfig.setKeyArrayData(value: bloackUserListArray, key: "bloackUserList")
            //ブロックが終わった
            self.blockBlockDelegate?.block()
            
        }
        
    }

    
    func deleteToBloack(thisUserID:String){
        
        self.db.collection("Users").document(thisUserID).collection("block").document(Auth.auth().currentUser!.uid).delete()
        
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("block").document(thisUserID).delete()

        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("blockUser").document(thisUserID).delete()
        
    }
    
    
    
    //★★★追記
    func bloackUserList2(bloackFlag2:Bool,thisUserID:String){
        //まだブロックしていない状態
        if bloackFlag2 == false{
            
            //★★.collection("blockUser") ??
            self.db.collection("Users").document(thisUserID).collection("block2").document(Auth.auth().currentUser!.uid).setData(["block2":false])
            //消す
            deleteToBloack(thisUserID: thisUserID)
            
            var bloackUserListArray2 = KeyChainConfig.getKeyArrayListData(key: "bloackUserList2")
            bloackUserListArray2.removeAll(where: {$0 == thisUserID})
            KeyChainConfig.setKeyArrayData(value: bloackUserListArray2, key: "bloackUserList2")
            
            print(bloackUserListArray2.debugDescription)
            
        }else if bloackFlag2 == true{
            
            let userData = KeyChainConfig.getKeyArrayData(key: "userData")
            
            self.db.collection("Users").document(thisUserID).collection("block2").document(Auth.auth().currentUser!.uid).setData(["block2":true,"customer":userData["customer"] as Any,"uid":userData["uid"] as Any,"name":userData["name"] as Any,"cost":userData["cost"] as Any,"pre":userData["pre"] as Any,"job":userData["job"] as Any,"identity":userData["identity"] as Any,"profile":userData["profile"] as Any,"profileImageString":userData["profileImageString"] as Any,"quickWord":userData["quickWord"] as Any,"meet":userData["meet"] as Any])
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("blockUser2").document(thisUserID).setData(["like":true,"customer":userData["customer"] as Any,"uid":userData["uid"] as Any,"name":userData["name"] as Any,"cost":userData["cost"] as Any,"pre":userData["pre"] as Any,"job":userData["job"] as Any,"identity":userData["identity"] as Any,"profile":userData["profile"] as Any,"profileImageString":userData["profileImageString"] as Any,"quickWord":userData["quickWord"] as Any,"meet":userData["meet"] as Any])
            
            var bloackUserListArray2 = KeyChainConfig.getKeyArrayListData(key: "bloackUserList2")
            bloackUserListArray2.append(thisUserID)
            KeyChainConfig.setKeyArrayData(value: bloackUserListArray2, key: "bloackUserList2")
            //ブロックが終わった
            self.blockBlockDelegate2?.block2()
            
        }
        
    }

    
    func deleteToBloack2(thisUserID:String){

        self.db.collection("Users").document(thisUserID).collection("block2").document(Auth.auth().currentUser!.uid).delete()

        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("block2").document(thisUserID).delete()

        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("blockUser2").document(thisUserID).delete()

    }
    
    
    func sendAshiato(aitenoUserID:String){
        
        let userData = KeyChainConfig.getKeyArrayData(key: "userData")
        
        self.db.collection("Users").document(aitenoUserID).collection("ashiato").document(Auth.auth().currentUser?.uid ?? "").setData(["customer":userData["customer"] as Any,"uid":userData["uid"] as Any,"name":userData["name"] as Any,"cost":userData["cost"] as Any,"pre":userData["pre"] as Any,"job":userData["job"] as Any,"identity":userData["identity"] as Any,"profile":userData["profile"] as Any,"profileImageString":userData["profileImageString"] as Any,"quickWord":userData["quickWord"] as Any,"meet":userData["meet"] as Any,"date":Date().timeIntervalSince1970])
        
    }
    
    
    func sendImageData(image:UIImage,senderID:String,toID:String){
        
        let userData = KeyChainConfig.getKeyArrayData(key: "userData")
        
        let imageRef = Storage.storage().reference().child("ChatImages").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpeg")
        
        imageRef.putData(image.jpegData(compressionQuality: 0.3)!, metadata: nil) {
            metaData, error in
            
            if error != nil{
                return
            }
            
            imageRef.downloadURL{ url, error in
                if error != nil{
                    return
                }
                
                if url != nil{
                    
                    self.db.collection("Users").document(senderID).collection("matching").document(toID).collection("chat").document().setData(
                        
                        ["senderID":Auth.auth().currentUser!.uid, "displayName":userData["name"] as Any,  "imageURLString":userData["profileImageString"] as Any,"date":Date().timeIntervalSince1970,"attachImageString":url?.absoluteString as Any]
                    
                    )
 
                    self.db.collection("Users").document(toID).collection("matching").document(senderID).collection("chat").document().setData(
                        
                        ["senderID":Auth.auth().currentUser!.uid, "displayName":userData["name"] as Any,  "imageURLString":userData["profileImageString"] as Any,"date":Date().timeIntervalSince1970,"attachImageString":url?.absoluteString as Any]
                    
                    )
                    
                    self.getAttachProtocol?.getAttachProtocol(attachImageString: url!.absoluteString)
                    
                }
                
            }
        }
        
        
    }
    
    func sendMessage(senderID:String,toID:String,text:String,displayName:String,imageURLString:String){
        
        self.db.collection("Users").document(senderID).collection("matching").document(toID).collection("chat").document().setData(
            ["text":text as Any,"senderID":senderID as Any,"displayName":displayName as Any,"imageURLString":imageURLString as Any,"date":Date().timeIntervalSince1970]
            
        )
        
        self.db.collection("Users").document(toID).collection("matching").document(senderID).collection("chat").document().setData(
            ["text":text as Any,"senderID":Auth.auth().currentUser!.uid as Any,"displayName":displayName as Any,"imageURLString":imageURLString as Any,"date":Date().timeIntervalSince1970]
        
        )
        
    }
    
}
