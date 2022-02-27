import UIKit
import SDWebImage
import FirebaseAuth

class SearchViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,GetSearchResultProtocol {
    
    
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var identityTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var costMinPicker = UIPickerView()
    var costMaxPicker = UIPickerView()
    var jobPicker = UIPickerView()
    var identityPicker = UIPickerView()
    
    var dataStringArray = [String]()
    var dataIntArray = [Int]()
    
    var userDataModelArray = [UserDataModel]()
    var userData = String()
    var resultHandler: (([UserDataModel],Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobTextField.inputView = jobPicker
        identityTextField.inputView = identityPicker
        
        jobPicker.delegate = self
        jobPicker.dataSource = self
        identityPicker.delegate = self
        identityPicker.dataSource = self
        
        jobPicker.tag = 1
        identityPicker.tag = 2

        Util.rectButton(button: searchButton)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView.tag {
        case 1:
            dataStringArray = ["ビジネス","IT・プログラミング","デザイン・クリエイティブ・芸術","就業・転職","副業・フリーランス","探偵・調査・探し物","自己啓発・マインドフルネス","代行サービス","恋愛・婚活","スポーツ・フィットネス","健康・医療","美容","農業・自然","旅・旅行","場所・会場提供","音楽","マンガ・アニメ・ゲーム","趣味・娯楽","各種相談窓口","その他"]
            return dataStringArray.count
        case 2:
            dataStringArray = ["親しみ易い","親切・丁寧・分かり易い","冷静・客観的・的確","情熱的・熱心","主体的・リーダー性強い","面白い・個性派","サポート欲強い","ボランティア・人助け精神高い"]
            return dataStringArray.count
        default:
            return 0
        }
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag{
        case 1:
            jobTextField.text = dataStringArray[row]
            jobTextField.resignFirstResponder()
            break
        case 2:
            identityTextField.text = dataStringArray[row]
            identityTextField.resignFirstResponder()
            break
        default:
            break
        }
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag {
        case 1:
            return dataStringArray[row]
        case 2:
            return dataStringArray[row]
        default:
            return ""
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    @IBAction func back(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func search(_ sender: Any) {
        
        let loadDBModel = LoadDBModel()
        loadDBModel.getSearchResultProtocol = self
        loadDBModel.loadSearch(job: jobTextField.text!, identity: identityTextField.text!, userData: userData)

    }
    
    func getSearchResultProtocol(userDataModelArray: [UserDataModel], searchDone: Bool) {
        
        self.userDataModelArray = []
        self.userDataModelArray = userDataModelArray
        
        if let handler = self.resultHandler{
            
            handler(self.userDataModelArray,searchDone)
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
        
}


