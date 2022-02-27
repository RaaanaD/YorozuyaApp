import UIKit
import SDWebImage

class LikeProfileCell: UITableViewCell {

    
    @IBOutlet weak var customerLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var quickWordLabel: UILabel!
    @IBOutlet weak var identityLabel: UILabel!
    @IBOutlet weak var preLabel: UILabel!
    @IBOutlet weak var meetLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    var userData = [String:Any]()
    var uid = String()
    static let identifier = "LikeProfileCell"
    var profileImageViewString = String()
    
    
    @IBOutlet weak var likeButton: UIButton!
    
    
    static func nib()->UINib{
        
        return UINib(nibName: "LikeProfileCell", bundle: nil)
    }
    
    func configure(customerLabelString:String,nameLabelString:String,jobLabelString:String,identityLabelString:String, preLabelString:String,meetLabelString:String,costLabelString:String,quickWordLabelString:String,profileImageViewString:String,uid:String,userData:[String:Any]){
        
        customerLabel.text = customerLabelString
        nameLabel.text = nameLabelString
        jobLabel.text = jobLabelString
        identityLabel.text = identityLabelString
        preLabel.text = preLabelString
        meetLabel.text = meetLabelString
        costLabel.text = costLabelString
        quickWordLabel.text = quickWordLabelString
        profileImageView.sd_setImage(with: URL(string: profileImageViewString), completed: nil)
        self.uid = uid
        self.userData = userData
        self.profileImageViewString = profileImageViewString
        
        Util.rectButton(button: likeButton)
    
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width * 0.3

    }

    
    @IBAction func likeAction(_ sender: Any) {
        
        let sendDBModel = SendDBModel()
        sendDBModel.sendToLikeFromLike(likeFlag: true, thisUserID: self.uid, matchName: nameLabel.text!, matchID: self.uid)
        
        print(self.uid)
        print(self.userData["uid"].debugDescription)

        sendDBModel.sendToMatchingList(thisUserID: self.uid, name: nameLabel.text!, cost: costLabel.text!, pre: preLabel.text!, customer: customerLabel.text!, profile: "後で外部引数で追加", profileImageString: self.profileImageViewString, uid: self.uid, job: jobLabel.text!, identity: identityLabel.text!, quickWord: quickWordLabel.text!, meet: meetLabel.text!, userData: self.userData)
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
}
