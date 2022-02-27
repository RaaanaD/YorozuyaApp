import Foundation
import UIKit
import MessageUI
import FirebaseAuth
import KeychainSwift
import Firebase

class MypageViewController: UIViewController,MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var blockButton: UIButton!
    @IBOutlet weak var hostButton: UIButton!
    @IBOutlet weak var termButton: UIButton!
    
    //追記
    var delegate: UIViewController?
    var alert:UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Util.rectButton3(button: logoutButton)
        Util.rectButton3(button: deleteButton)
        Util.rectButton3(button: blockButton)
        Util.rectButton3(button: hostButton)
        Util.rectButton3(button: termButton)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func didTapLogout(_ sender: Any){
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error: \(signOutError)")
        }
        
        let rootVC = storyboard?.instantiateViewController(identifier: "LoginVC") as! LoginViewController
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }
    
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        
        let db = Firestore.firestore()
        let alertController: UIAlertController =
        UIAlertController(title: "データ消去されます", message: "退会してもいいですか？", preferredStyle: .alert)
        
        let actionPositive = UIAlertAction(title: "OK", style: .default){
            action in
            Auth.auth().currentUser?.delete {  (error) in
                if error == nil {
                    let rootVC = self.storyboard?.instantiateViewController(identifier: "LoginVC") as! LoginViewController
                    let navVC = UINavigationController(rootViewController: rootVC)
                    navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: true, completion: nil)
                }else{
                    print("エラー：\(String(describing: error?.localizedDescription))")
                }
                
            }
            db.collection("Users").document(Auth.auth().currentUser!.uid).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
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
    
    
    @IBAction func hostButtonTapped(_ sender: Any) {
        
        let alertController: UIAlertController =
        UIAlertController(title: "よろずや", message: "もし、不適切なユーザーと遭遇した場合は通報ボタンを押して下さい。\n運営元Twitter：@yorozu_ya0", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "戻る", style: .default){
            (action) -> Void in
        }
        
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func blockButtonTapped(_ sender: Any) {
        
        let db = Firestore.firestore()
        let alertController: UIAlertController =
        UIAlertController(title:"通報しますか？",
                          message: "メーラーが立ち上がります",
                          preferredStyle: UIAlertController.Style.alert)
        
        let actionPositive = UIAlertAction(title: "OK", style: .default){
            action in
            //メールを送信できるかチェック
            if MFMailComposeViewController.canSendMail()==false {
                print("Email Send Failed")
                return
            }
            
            var mailViewController = MFMailComposeViewController()
            var toRecipients = ["yorozuya.0.yorozuya@gmail.com"] //Toのアドレス指定
            var image = UIImage(named: "myphoto.png")
            var imageData = image!.jpegData(compressionQuality: 1.0)
            
            mailViewController.mailComposeDelegate = self
            mailViewController.setSubject("通報ユーザー")
            mailViewController.setToRecipients(toRecipients) //Toアドレスの表示
            mailViewController.setMessageBody("※以下事項を必ずご記載及び添付のうえ送信下さい。\n・ご登録メールアドレス(ご自身の)：\n・通報したいユーザーの表示名：\n・通報内容：不適切・不快な表現 or 不快なメッセージを受けた or その他(ご記載下さい)\n・通報したいユーザーのプロフィール写真、名前の部分を写したスクリーンショット画像の添付\n以下例の様なスクリーンショット画像を添付下さい", isHTML: false)
            mailViewController.addAttachmentData(imageData!, mimeType: "image/png", fileName: "image")
            self.present(mailViewController, animated: true, completion: nil)
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel){
            (action) -> Void in
        }
        alertController.addAction(actionPositive)
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Email Send Cancelled")
            break
        case .saved:
            print("Email Saved as a Draft")
            break
        case .sent:
            print("Email Sent Successfully")
            break
        case .failed:
            print("Email Send Failed")
            break
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func terms(_ sender: Any) {
        let alertController: UIAlertController =
        UIAlertController(title: "ご利用方法", message: "お選び下さい", preferredStyle: .alert)
        let actionPositive = UIAlertAction(title: "画像説明", style: .default){
            action in
            DispatchQueue.main.async {
                let FirstViewController = FirstViewController.init()
                self.present(FirstViewController, animated: true, completion: nil)
            }
        }
        let actionCancel = UIAlertAction(title: "動画説明", style: .default){
            action in
            let url = URL(string: "https://youtu.be/mXb59hzoU08")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
            
        }
        alertController.addAction(actionPositive)
        alertController.addAction(actionCancel)
        present(alertController, animated: true, completion: nil)
        
    }
    
    
}
