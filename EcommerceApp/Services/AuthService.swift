
import Foundation

import FirebaseAuth

protocol AuthServiceProtocol {
    var currentUser: User? { get }
    func signUp(email: String, password: String) async throws -> User
    func login(email: String, password: String) async throws -> User
    func logout() throws
}

final class AuthService: AuthServiceProtocol {
    private let auth = Auth.auth()
    
    var currentUser: User? { auth.currentUser }
    
    func signUp(email: String, password: String) async throws -> User {
        let result = try await auth.createUser(withEmail: email, password: password)
        return result.user
    }
    
    func login(email: String, password: String) async throws -> User {
        let result = try await auth.signIn(withEmail: email, password: password)
        return result.user
    }
    
    func logout() throws {
        try auth.signOut()
    }
}
