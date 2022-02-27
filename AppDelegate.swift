import UIKit
import Firebase
import IQKeyboardManagerSwift
import KeychainSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true

        UINavigationBar.appearance().tintColor = UIColor.systemBlue

        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor:UIColor.black]
        
        (UINavigationBar.appearance() as UINavigationBar).setBackgroundImage(UIImage(), for: .default)
        
        let ud = UserDefaults.standard
        let firstLunchKey = "firstLunch"
        let firstLunch = [firstLunchKey: true]
        ud.register(defaults: firstLunch)

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }


}

