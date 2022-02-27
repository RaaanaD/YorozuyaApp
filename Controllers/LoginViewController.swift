import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        Auth.auth().signIn(withEmail: email!, password: password!) { (result, error) in
            if (result?.user) != nil {
                
                let tabVC = self.storyboard?.instantiateViewController(identifier: "tabVC") as! TabBarViewController
                tabVC.modalPresentationStyle = .fullScreen
                self.present(tabVC, animated: true, completion: nil)
                
            }else{
                
                let alertController: UIAlertController =
                UIAlertController(title: "ログインエラー発生", message: "再度お試し下さい", preferredStyle: .alert)
                
                let actionCancel = UIAlertAction(title: "OK", style: .default){
                    (action) -> Void in
                }
                
                alertController.addAction(actionCancel)
                
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
    }
    
    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        let email = emailTextField.text!
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                let rootVC = self.storyboard?.instantiateViewController(identifier: "LoginVC") as! LoginViewController
                let navVC = UINavigationController(rootViewController: rootVC) //LoginViewControllerをNavigationControllerに内包する
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true, completion: nil)
            }else{
                
                let alertController: UIAlertController =
                UIAlertController(title: "エラー発生", message: "メールアドレスを正しく記載して下さい", preferredStyle: .alert)
                
                let actionCancel = UIAlertAction(title: "OK", style: .default){
                    (action) -> Void in
                }
                
                alertController.addAction(actionCancel)

                self.present(alertController, animated: true, completion: nil)
                print("エラー：\(String(describing: error?.localizedDescription))")
                
            }
        }
    }
    
    @IBAction func terms2(_ sender: Any) {
        
        let alertController: UIAlertController =
        UIAlertController(title: "ご利用方法", message: "お選び下さい", preferredStyle: .alert)
        let actionPositive = UIAlertAction(title: "画像説明", style: .default){
            action in
            print("ウォークスルー画面へ")
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


extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

