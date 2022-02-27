import UIKit
import EAIntroView

class FirstViewController: UIViewController, EAIntroDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#fcd0ac")
        walkThrough()
    }
    
    func walkThrough() {
        let page1 = EAIntroPage()
        let page2 = EAIntroPage()
        let page3 = EAIntroPage()
        let page4 = EAIntroPage()
        let page5 = EAIntroPage()
        let page6 = EAIntroPage()
        let page7 = EAIntroPage()
        let page8 = EAIntroPage()
        page1.bgColor = UIColor(hex: "#fcd0ac")
        page2.bgColor = UIColor(hex: "#fcd0ac")
        page3.bgColor = UIColor(hex: "#fcd0ac")
        page4.bgColor = UIColor(hex: "#fcd0ac")
        page5.bgColor = UIColor(hex: "#fcd0ac")
        page6.bgColor = UIColor(hex: "#fcd0ac")
        page7.bgColor = UIColor(hex: "#fcd0ac")
        page8.bgColor = UIColor(hex: "#fcd0ac")

        if UIDevice.current.userInterfaceIdiom == .phone {
            page1.bgImage = UIImage(named: "firstview1")
            page2.bgImage = UIImage(named: "firstview2")
            page3.bgImage = UIImage(named: "firstview3")
            page4.bgImage = UIImage(named: "firstview4")
            page5.bgImage = UIImage(named: "firstview5")
            page6.bgImage = UIImage(named: "firstview6")
            page7.bgImage = UIImage(named: "firstview7")
            page8.bgImage = UIImage(named: "firstview8")
        }
        
        let introView = EAIntroView(frame: self.view.bounds, andPages: [page1, page2, page3, page4, page5, page6, page7, page8])
        introView?.skipButton.setTitle("スキップ", for: UIControl.State.normal)
        introView?.delegate = self
        introView?.show(in: self.view, animateDuration: 1.0)
    }
    
    func introDidFinish(_ introView: EAIntroView!, wasSkipped: Bool) {
        if(wasSkipped) {
            if UserDefaults.standard.bool(forKey: "WalkThrough") == true {
                dismiss(animated: true, completion: nil)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let first = storyboard.instantiateViewController(withIdentifier: "first") as! FirstNavigationController
                first.modalPresentationStyle = .fullScreen
                self.present(first, animated: true, completion: nil)
                UserDefaults.standard.set(true, forKey: "WalkThrough")
            }
        } else {
            if UserDefaults.standard.bool(forKey: "WalkThrough") == true {
                dismiss(animated: true, completion: nil)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let first = storyboard.instantiateViewController(withIdentifier: "first") as! FirstNavigationController
                first.modalPresentationStyle = .fullScreen
                self.present(first, animated: true, completion: nil)
                UserDefaults.standard.set(true, forKey: "WalkThrough")
            }
        }
    }
    
    
}
