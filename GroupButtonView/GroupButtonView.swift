//
//  GroupButtonView.swift
//  GroupButtonView
//
//  Created by Est Rouge on 12/30/19.
//  Copyright © 2019 ThaoPN. All rights reserved.
//

import UIKit

@IBDesignable public class GroupButtonView: UIStackView {
    @IBInspectable public var itemTitles = [String]() {
        didSet {
            makeUI()
        }
    }
    @IBInspectable public var items: String = "" {
        didSet {
            let newline = CharacterSet.newlines
            itemTitles = items.components(separatedBy: newline)
        }
    }
    
    @IBInspectable public var highlightColorBackground: UIColor = .systemBlue {
        didSet {
            updateButtonsStyle()
        }
    }
    @IBInspectable public var highlightColorText: UIColor = .white {
        didSet {
            updateButtonsStyle()
        }
    }
    
    @IBInspectable public var unhighlightColorBackground: UIColor = .lightGray {
        didSet {
            updateButtonsStyle()
        }
    }
    @IBInspectable public var unhighlightColorText: UIColor = .white {
        didSet {
            updateButtonsStyle()
        }
    }
    
    @IBInspectable public var buttonBorderCorner: CGFloat = 3 {
        didSet {
            updateButtonsStyle()
        }
    }
    @IBInspectable public var buttonBorderWidth: CGFloat = 0 {
        didSet {
            updateButtonsStyle()
        }
    }
    @IBInspectable public var buttonBorderColor: UIColor = .clear {
        didSet {
            updateButtonsStyle()
        }
    }
    @IBInspectable public var buttonFont: UIFont = .systemFont(ofSize: 18.0, weight: .medium) {
        didSet {
            updateButtonsStyle()
        }
    }
    
    public var valueChanged: ((Int) -> Void)?
    
    @IBInspectable public var spaceBetweenItems: CGFloat = 10 {
        didSet {
            spacing = spaceBetweenItems
        }
    }
    
    private var buttons: [UIButton] = []
    private var selectedIndex = -1
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func prepareForInterfaceBuilder() {
      super.prepareForInterfaceBuilder()
    }
    
    public func setSelected(index: Int) {
        if !buttons.isEmpty && index < buttons.count && index != selectedIndex {
            for btn in buttons {
                btn.isSelected = false
            }
            buttons[index].isSelected = true
            selectedIndex = index
        }
    }
    
    private func makeUI() {
        configurate()
        buttons.removeAll()
        for item in itemTitles {
            let btn = createStyleButton(title: item)
            buttons.append(btn)
            addArrangedSubview(btn)
        }
        updateButtonsStyle()
        if selectedIndex < 0 {
            setSelected(index: 0)
        }
        layoutIfNeeded()
    }
    
    private func updateButtonsStyle() {
        for btn in buttons {
            set(button: btn, withBackgroundColor: highlightColorBackground, forState: .selected)
            set(button: btn, withBackgroundColor: unhighlightColorBackground, forState: .normal)
            
            btn.titleLabel?.font = buttonFont
            btn.setTitleColor(highlightColorText, for: .selected)
            btn.setTitleColor(unhighlightColorText, for: .normal)
            
            btn.layer.cornerRadius = buttonBorderCorner
            btn.layer.borderColor = buttonBorderColor.cgColor
            btn.layer.borderWidth = buttonBorderWidth
        }
    }
    
    private func configurate() {
        distribution = .fillEqually
        spacing = spaceBetweenItems
    }
    
    private func createStyleButton(title: String) -> UIButton {
        let btn = UIButton(type: .custom)
        
        btn.setTitle(title, for: .normal)
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(touchOnButton(_:)), for: .touchUpInside)
        
        return btn
    }
    
    @objc private func touchOnButton(_ sender: UIButton) {
        guard let index = buttons.firstIndex(of: sender) else { return }
        setSelected(index: index)
        valueChanged?(index)
    }
    
    private func set(button: UIButton, withBackgroundColor color: UIColor, forState: UIControl.State) {
        button.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            button.setBackgroundImage(colorImage, for: forState)
        }
    }
}
