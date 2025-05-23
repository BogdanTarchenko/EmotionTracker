import UIKit
import LocalAuthentication
import SnapKit

final class BiometricAuthViewController: UIViewController {
    private let biometricService: BiometricServiceProtocol
    private let onSuccess: () -> Void
    private var isAuthenticating = false
    private var hasAttemptedAuth = false
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "faceid")
        imageView.tintColor = .greenPrimary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Вход в приложение"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .textPrimary
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Используйте \(biometricService.biometricType.description) для входа"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var authButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти с \(biometricService.biometricType.description)", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .greenPrimary
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(authButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init(biometricService: BiometricServiceProtocol = BiometricService(),
         onSuccess: @escaping () -> Void) {
        self.biometricService = biometricService
        self.onSuccess = onSuccess
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !hasAttemptedAuth && !isAuthenticating {
            hasAttemptedAuth = true
            authenticate()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .background
        
        view.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(authButton)
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        authButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(48)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func authButtonTapped() {
        authenticate()
    }
    
    private func authenticate() {
        guard !isAuthenticating else { return }
        isAuthenticating = true
        
        UIView.animate(withDuration: 0.1, animations: {
            self.authButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.authButton.transform = .identity
            }
        }
        
        biometricService.authenticate { [weak self] success, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if success {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.containerView.alpha = 0
                        self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    }) { _ in
                        self.onSuccess()
                    }
                } else if let error = error {
                    self.isAuthenticating = false
                    self.hasAttemptedAuth = false
                }
            }
        }
    }
}
