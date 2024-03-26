//
//  TextFieldView.swift
//  VKPlagueSimulationTest
//
//  Created by Ильнур Закиров on 22.03.2024.
//

import UIKit

class TextFieldView: UIView {

    private let titleView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        return view
    }()
    
    private let textField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "Введите значение"
        view.keyboardType = .numberPad
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [titleView, textField].forEach(addSubview(_:))
        
        [
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleView.topAnchor.constraint(equalTo: topAnchor),
            titleView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ].forEach{$0.isActive = true}
    }
    
    func configure(titleText: String, delegate: UITextFieldDelegate, tag: Int) {
        titleView.text = titleText
        textField.delegate = delegate
        textField.tag = tag
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.lineWidth = 1
        layer.addSublayer(shape)
    }
    
}
