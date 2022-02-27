import UIKit
import Firebase
import FirebaseAuth


class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    
    
    @IBAction func didTapRegister(_ sender: Any) {
        if emailTextField.text != nil, passwordTextField.text != nil {
            let email = emailTextField.text!
            let password = passwordTextField.text!
            
            // FirebaseSDK 新規ユーザーとしてログイン
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                
                // ログイン出来ていたら
                if (result?.user) != nil {
                    // Creatへ
                    let tabVC2 = self.storyboard?.instantiateViewController(identifier: "tabVC2") as! CreateNewUserViewController
                    tabVC2.modalPresentationStyle = .fullScreen
                    self.present(tabVC2, animated: true, completion: nil)
                    
                }else{
                    
                    let alertController: UIAlertController =
                    UIAlertController(title: "登録エラー発生", message: "再度お試し下さい", preferredStyle: .alert)
                    
                    // 選択肢
                    let actionCancel = UIAlertAction(title: "OK", style: .default){
                        (action) -> Void in
                    }
                    
                    // actionを追加
                    alertController.addAction(actionCancel)
                    
                    // UIAlertControllerの起動
                    self.present(alertController, animated: true, completion: nil)
                    
                    print("エラー：\(String(describing: error?.localizedDescription))")
                }
                
            }
        }
        
    }
    
    
    @IBAction func privacyPolicyTapped(_ sender: Any) {
        let url = URL(string: "https://myportfolioproject-e7129.web.app/")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
}
