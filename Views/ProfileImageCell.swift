import UIKit
import MessageUI
import SDWebImage
import Foundation
import FirebaseAuth
import KeychainSwift
import Firebase

class ProfileImageCell: UITableViewCell,MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var blockButton: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var costLabel: UILabel!
    
    @IBOutlet weak var quickWordLabel: UILabel!
    
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var identityLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    
    //★追記
    var userDataModel:UserDataModel?
    var loadDBModel = LoadDBModel()
    //追記
    var delegate: UIViewController?
    var alert:UIAlertController!
    
    static let identifire = "ProfileImageCell"
    
    static func nib()->UINib{
        
        return UINib(nibName: "ProfileImageCell", bundle: nil)
    }
    
    func configure(profileImageString:String,nameLabelString:String,costLabelString:String,quickWordLabelString:String,jobLabelString:String,identityLabelString:String,likeLabelString:String){
        
        profileImageView.sd_setImage(with: URL(string:profileImageString), completed: nil)
        nameLabel.text = nameLabelString
        costLabel.text = costLabelString
        quickWordLabel.text = quickWordLabelString
        jobLabel.text = jobLabelString
        identityLabel.text = identityLabelString
        likeLabel.text = likeLabelString
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.width * 0.3
        profileImageView.clipsToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    //追記
    @IBAction func blockButtonTapped(_ sender: Any) {
        
        let db = Firestore.firestore()
        alert = UIAlertController(title:"通報しますか？",
                                  message: "メーラーが立ち上がります",
                                  preferredStyle: UIAlertController.Style.alert)
        
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
                                                       style: UIAlertAction.Style.cancel,
                                                       handler:{
            action in
        })
        let OKAction:UIAlertAction = UIAlertAction(title: "OK",
                                                   style: UIAlertAction.Style.default,
                                                   handler:{ [self]
            (action:UIAlertAction!) -> Void in
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
            delegate!.present(mailViewController, animated: true, completion: nil)
            
        })
        alert.addAction(cancelAction)
        alert.addAction(OKAction)
        delegate!.present(alert, animated: true, completion: nil)//必要
        
        func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }
        
        func setSelected(selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            
            // Configure the view for the selected state
        }
        
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
    
    
}
