//
//  AddTagButtonView.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 28.02.2025.
//

import UIKit
import SnapKit

class AddTagCell: UICollectionViewCell {
    
    private var imageView = UIImageView()
    private var textField: UITextField = {
        let field = UITextField()
        field.font = Constants.textFieldFont
        field.textColor = Constants.textFieldColor
        field.tintColor = Constants.textFieldColor
        field.returnKeyType = .done
        field.backgroundColor = .clear
        field.alpha = 0
        return field
    }()
    
    var onTap: (() -> Void)?
    var onTagAdded: ((String) -> Void)?
    
    private var isEditing: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupGesture()
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textField.text = ""
        setEditing(false, animated: false)
    }
    
    func startEditing() {
        setEditing(true, animated: true)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        
        if isEditing {
            let targetSize = CGSize(
                width: UIView.layoutFittingCompressedSize.width,
                height: layoutAttributes.size.height
            )
            
            let size = contentView.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .defaultLow,
                verticalFittingPriority: .required
            )
            
            attributes.size = CGSize(
                width: max(size.width, Metrics.minimumTextFieldWidth),
                height: layoutAttributes.size.height
            )
        } else {
            attributes.size = CGSize(
                width: Metrics.imageSize + Metrics.imageInset * 2,
                height: Metrics.imageSize + Metrics.imageInset * 2
            )
        }
        
        return attributes
    }
}

private extension AddTagCell {
    func setupUI() {
        backgroundColor = Constants.backgroundColor
        layer.cornerRadius = Metrics.layerCornerRadius
        isUserInteractionEnabled = true
        configureImageView()
    }
    
    func configureImageView() {
        imageView.image = Constants.image
        imageView.tintColor = Constants.imageColor
    }
    
    func setupConstraints() {
        contentView.addSubview(imageView)
        contentView.addSubview(textField)
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(Metrics.imageSize)
            make.leading.trailing.top.bottom.equalToSuperview().inset(Metrics.imageInset)
        }
        
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Metrics.textFieldVerticalInset)
            make.leading.trailing.equalToSuperview().inset(Metrics.textFieldHorizontalInset)
            make.width.greaterThanOrEqualTo(Metrics.minimumTextFieldWidth)
        }
    }
    
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
    }
    
    func setupTextField() {
        textField.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextField.textDidChangeNotification,
            object: textField
        )
    }
    
    @objc private func textDidChange() {
        let size = textField.sizeThatFits(CGSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: self.bounds.height
        ))
        
        if size.width + Metrics.textFieldHorizontalInset * 2 != self.bounds.width {
            UIView.animate(withDuration: 0.2) {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
    }
    
    func setEditing(_ editing: Bool, animated: Bool) {
        guard isEditing != editing else { return }
        isEditing = editing
        
        let animationDuration = animated ? 0.3 : 0.0
        
        if editing {
            textField.text = ""
            textField.alpha = 1
            imageView.alpha = 0
            textField.becomeFirstResponder()
        }
        
        UIView.animate(withDuration: animationDuration) {
            self.invalidateIntrinsicContentSize()
            self.superview?.layoutIfNeeded()
            
            if !editing {
                self.textField.alpha = 0
            }
        } completion: { _ in
            if !editing {
                UIView.animate(withDuration: 0.3) {
                    self.imageView.alpha = 1
                }
            }
        }
    }
}

extension AddTagCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else {
            setEditing(false, animated: true)
            return
        }
        
        onTagAdded?(text)
        textField.text = ""
        setEditing(false, animated: true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= Metrics.maxTextLength
    }
}

private extension AddTagCell {
    @objc private func handleTap() {
        if !isEditing {
            onTap?()
        }
    }
}

private extension AddTagCell {
    enum Metrics {
        static let imageSize: CGFloat = 20
        static let layerCornerRadius: CGFloat = 18
        static let imageInset: CGFloat = 8
        static let textFieldVerticalInset: CGFloat = 8
        static let textFieldHorizontalInset: CGFloat = 16
        static let minimumTextFieldWidth: CGFloat = 100
        static let maxTextLength: Int = 30
    }
    
    enum Constants {
        static let backgroundColor: UIColor = .buttonSecondary
        static let image: UIImage = UIImage(named: "AddTagImg")!
        static let imageColor: UIColor = .textPrimary
        static let textFieldFont: UIFont = .init(name: "VelaSans-Regular", size: 14)!
        static let textFieldColor: UIColor = .textPrimary
    }
}
