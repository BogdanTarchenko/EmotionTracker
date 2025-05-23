import LocalAuthentication
import UIKit

protocol BiometricServiceProtocol {
    var biometricType: BiometricType { get }
    func authenticate(completion: @escaping (Bool, Error?) -> Void)
}

enum BiometricType {
    case none
    case touchID
    case faceID
    case opticID
    
    var description: String {
        switch self {
        case .none:
            return "Биометрия недоступна"
        case .touchID:
            return "Touch ID"
        case .faceID:
            return "Face ID"
        case .opticID:
            return "Optic ID"
        }
    }
}

final class BiometricService: BiometricServiceProtocol {
    private let context = LAContext()
    
    var biometricType: BiometricType {
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        print("Биометрия доступна: \(canEvaluate)")
        if let error = error {
            print("Ошибка проверки биометрии: \(error.localizedDescription)")
        }
        
        guard canEvaluate else {
            return .none
        }
        
        let type = context.biometryType
        print("Тип биометрии: \(type.rawValue)")
        
        switch type {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        @unknown default:
            return .none
        }
    }
    
    func authenticate(completion: @escaping (Bool, Error?) -> Void) {
        let reason = "Войдите в приложение"
        
        print("Начинаем аутентификацию...")
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                             localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                if success {
                    print("Аутентификация успешна")
                } else if let error = error {
                    print("Ошибка аутентификации: \(error.localizedDescription)")
                }
                completion(success, error)
            }
        }
    }
}
