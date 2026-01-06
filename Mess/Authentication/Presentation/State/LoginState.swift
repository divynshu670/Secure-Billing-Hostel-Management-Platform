import Foundation

struct LoginState {
    var email: String = ""
    var password: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    var isLoggedIn: Bool = false
}
