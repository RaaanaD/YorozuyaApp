import Foundation
import FirebaseAuth
import Firebase

class DatabaseManager {
    
    static let shared = DatabaseManager()
    private init() {}
    let db = Firestore.firestore()
    
    func registerUser(name: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            if let user = result?.user {
                self.updateDisplayName(name, of: user)
            }
        }
    }
    
    private func updateDisplayName(_ name: String, of user: User) {
        let request = user.createProfileChangeRequest()
        request.displayName = name
        request.commitChanges() { [weak self] error in
            guard let self = self else { return }
            if error != nil {
                self.sendEmailVerification(to: user)
            }
        }
    }
    
    private func sendEmailVerification(to user: User) {
        user.sendEmailVerification() { [weak self] error in
            guard let self = self else { return }
            if error != nil {
                self.showSignUpCompletion()
            }
        }
    }
    
    private func showSignUpCompletion() {
        
    }
    
    
}
