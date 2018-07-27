//
//  AMTextField.swift
//  AMTextField
//
//  Created by Abood Mufti on 2018-07-25.
//  Copyright © 2018 abood mufti. All rights reserved.
//


import UIKit

public typealias HorizontalPadding = (left: CGFloat, right: CGFloat)

public class AMTextField: UIView {

    // MARK: Components

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false

        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(placeholderLabelTapped)))

        insertSubview(label, aboveSubview: internalTextfield)

        placeholderTopConstraint = label.topAnchor.constraint(equalTo: self.topAnchor, constant: textFieldVerticalMargin)
        placeholderTopConstraint?.isActive = true

        label.leftAnchor.constraint(equalTo: internalTextfield.leftAnchor).isActive = true

        return label
    }()

    public lazy var internalTextfield: UITextField = {
        var textfield = UITextField()

        textfield.addTarget(self, action: #selector(textfieldEditingDidBegin), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(textfieldEditingDidEnd), for: .editingDidEnd)
        textfield.translatesAutoresizingMaskIntoConstraints = false

        addSubview(textfield)

        textfieldTopConstraint = textfield.topAnchor.constraint(equalTo: self.topAnchor, constant: textFieldVerticalMargin)
        textfieldTopConstraint?.isActive = true

        textfieldLeftConstraint = textfield.leftAnchor.constraint(equalTo: self.leftAnchor, constant: horizontalPadding.left)
        textfieldLeftConstraint?.isActive = true

        textfieldRightConstraint = textfield.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -horizontalPadding.right)
        textfieldRightConstraint?.isActive = true

        textfield.bottomAnchor.constraint(equalTo: infoLabel.topAnchor).isActive = true

        return textfield
    }()

    private lazy var infoLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)
        label.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        infoHeightConstraint = label.heightAnchor.constraint(equalToConstant: textFieldVerticalMargin)
        infoHeightConstraint?.isActive = true

        return label
    }()

    private lazy var bottomBorder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        addSubview(view)

        bottomBorderWidthConstraint = view.heightAnchor.constraint(equalToConstant: bottomBorderWidth)
        bottomBorderWidthConstraint?.isActive = true

        bottomBorderLeftConstraint = view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: bottomBorderPadding.left)
        bottomBorderLeftConstraint?.isActive = true

        bottomBorderRightConstraint = view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -bottomBorderPadding.right)
        bottomBorderRightConstraint?.isActive = true

        view.topAnchor.constraint(equalTo: internalTextfield.bottomAnchor).isActive = true

        return view
    }()

    // MARK: Constraints

    private var placeholderTopConstraint: NSLayoutConstraint?

    private var textfieldTopConstraint: NSLayoutConstraint?
    private var textfieldLeftConstraint: NSLayoutConstraint?
    private var textfieldRightConstraint: NSLayoutConstraint?

    private var infoHeightConstraint: NSLayoutConstraint?

    private var bottomBorderWidthConstraint: NSLayoutConstraint?
    private var bottomBorderLeftConstraint: NSLayoutConstraint?
    private var bottomBorderRightConstraint: NSLayoutConstraint?

    // MARK: Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        _ = placeholderLabel
        _ = bottomBorder
    }

    // MARK: Placeholder Animations

    private var placeHolderSmallScale: CGFloat = 0.7
    private var placeholderSmallFontSize: CGFloat { return font.pointSize * placeHolderSmallScale }
    private var textFieldVerticalMargin: CGFloat { return placeholderSmallFontSize + 10 }

    @objc private func movePlaceholderUp() {
        let frame = self.placeholderLabel.frame
        self.placeholderLabel.layer.anchorPoint = CGPoint(x: 0, y: 0)
        self.placeholderLabel.frame = frame

        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            self.placeholderLabel.transform = self.placeholderLabel.transform
                .scaledBy(x: 1.1, y: 1.1)
                .translatedBy(x: 0, y: 5)
        }) { _ in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveEaseOut], animations: {
                self.placeholderLabel.transform = self.placeholderLabel.transform
                    .scaledBy(x: self.placeHolderSmallScale, y: self.placeHolderSmallScale)
                    .translatedBy(x: 0, y: -(self.textFieldVerticalMargin + 10))
            })
        }

    }

    @objc private func movePlaceholderDown() {
        UIView.animate(withDuration: 0.1) { self.placeholderLabel.transform = .identity }
    }

    @objc private func textfieldEditingDidEnd() {
        if internalTextfield.text?.isEmpty ?? false { movePlaceholderDown() }
    }

    @objc private func textfieldEditingDidBegin() {
        if internalTextfield.text?.isEmpty ?? false { movePlaceholderUp() }
    }

    @objc private func placeholderLabelTapped() {
        internalTextfield.becomeFirstResponder()
    }


    // MARK: Bottom Border Styling

    public var bottomBorderColor: UIColor? {
        didSet {
            bottomBorder.backgroundColor = bottomBorderColor
        }
    }

    public var bottomBorderWidth: CGFloat = 0 {
        didSet {
            bottomBorderWidthConstraint?.constant = bottomBorderWidth
        }
    }

    public var bottomBorderPadding: HorizontalPadding = (0,0) {
        didSet {
            bottomBorderLeftConstraint?.constant = bottomBorderPadding.left
            bottomBorderRightConstraint?.constant = -bottomBorderPadding.right
        }
    }

    // Default: UIColor.lightGray
    public var placeholderColor: UIColor = .lightGray {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }

    public var font: UIFont =  UIFont.systemFont(ofSize: 18) {
        didSet {
            internalTextfield.font = font
            placeholderLabel.font = font
            placeholderTopConstraint?.constant = textFieldVerticalMargin
            textfieldTopConstraint?.constant = textFieldVerticalMargin
            infoHeightConstraint?.constant = textFieldVerticalMargin
        }
    }

    /// Returns `true` if the textfield has an actual
    /// value greater than an empty string; otherwise `false`.
    public var isEmpty: Bool {
        return text?.isEmpty ?? true
    }

    public var horizontalPadding: HorizontalPadding = (0,0) {
        didSet {
            textfieldLeftConstraint?.constant = horizontalPadding.left
            textfieldRightConstraint?.constant = -horizontalPadding.right
        }
    }
}

extension AMTextField {


    public var text: String? {
        get {
            return internalTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        set {
            internalTextfield.text = newValue
        }
    }

    public var textColor: UIColor? {
        get {
            return internalTextfield.textColor
        }
        set {
            internalTextfield.textColor = newValue
        }
    }

    public var attributedText: NSAttributedString? {
        get {
            return internalTextfield.attributedText
        }
        set {
            internalTextfield.attributedText = newValue
        }
    }

    public var placeholder: String? {
        get {
            return placeholderLabel.text
        }
        set {
            internalTextfield.placeholder = nil
            placeholderLabel.text = newValue
        }
    }

    public var attributedPlaceholder: NSAttributedString? {
        get {
            return placeholderLabel.attributedText
        }
        set {
            internalTextfield.placeholder = nil
            placeholderLabel.attributedText = newValue
        }
    }

    public var textAlignment: NSTextAlignment {
        get {
            return internalTextfield.textAlignment
        }
        set {
            internalTextfield.textAlignment = newValue
        }
    }

    public var clearsOnBeginEditing: Bool {
        get {
            return internalTextfield.clearsOnBeginEditing
        }
        set {
            internalTextfield.clearsOnBeginEditing = newValue
        }
    }

    public var adjustsFontSizeToFitWidth: Bool {
        get {
            return internalTextfield.adjustsFontSizeToFitWidth
        }
        set {
            internalTextfield.adjustsFontSizeToFitWidth = newValue
        }
    }

    public var minimumFontSize: CGFloat {
        get {
            return internalTextfield.minimumFontSize
        }
        set {
            internalTextfield.minimumFontSize = newValue
        }
    }

    public var delegate: UITextFieldDelegate? {
        get {
            return internalTextfield.delegate
        }
        set {
            internalTextfield.delegate = newValue
        }
    }

    public override var tintColor: UIColor! {
        didSet {
            internalTextfield.tintColor = tintColor
        }
    }

    public var isEditing: Bool { return internalTextfield.isEditing }

}

extension AMTextField: UITextInputTraits {

    public var autocapitalizationType: UITextAutocapitalizationType {
        get {
            return internalTextfield.autocapitalizationType
        }
        set {
            internalTextfield.autocapitalizationType = newValue
        }
    }

    public var autocorrectionType: UITextAutocorrectionType {
        get {
            return internalTextfield.autocorrectionType
        }
        set {
            internalTextfield.autocorrectionType = newValue
        }
    }

    public var spellCheckingType: UITextSpellCheckingType {
        get {
            return internalTextfield.spellCheckingType
        }
        set {
            internalTextfield.spellCheckingType = newValue
        }
    }

    public var smartQuotesType: UITextSmartQuotesType {
        get {
            return internalTextfield.smartQuotesType
        }
        set {
            internalTextfield.smartQuotesType = newValue
        }
    }

    public var smartDashesType: UITextSmartDashesType {
        get {
            return internalTextfield.smartDashesType
        }
        set {
            internalTextfield.smartDashesType = newValue
        }
    }

    public var smartInsertDeleteType: UITextSmartInsertDeleteType {
        get {
            return internalTextfield.smartInsertDeleteType
        }
        set {
            internalTextfield.smartInsertDeleteType = newValue
        }
    }

    public var keyboardType: UIKeyboardType {
        get {
            return internalTextfield.keyboardType
        }
        set {
            internalTextfield.keyboardType = newValue
        }
    }

    public var keyboardAppearance: UIKeyboardAppearance {
        get {
            return internalTextfield.keyboardAppearance
        }
        set {
            internalTextfield.keyboardAppearance = newValue
        }
    }

    public var enablesReturnKeyAutomatically: Bool {
        get {
            return internalTextfield.enablesReturnKeyAutomatically
        }
        set {
            internalTextfield.enablesReturnKeyAutomatically = newValue
        }
    }

    public var isSecureTextEntry: Bool {
        get {
            return internalTextfield.isSecureTextEntry
        }
        set {
            internalTextfield.isSecureTextEntry = newValue
        }
    }

    public var textContentType: UITextContentType! {
        get {
            return internalTextfield.textContentType
        }
        set {
            internalTextfield.textContentType = newValue
        }
    }

}


