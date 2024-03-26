//
//  ViewController.swift
//  VKPlagueSimulationTest
//
//  Created by Ильнур Закиров on 21.03.2024.
//

import UIKit

class ConfigureSimulationViewController: UIViewController {
    
    private var model = SimulatorModel(groupSize: 0, infectionFactor: 0, infectionTime: 0)
    
    private let groupSizeTextField = TextFieldView()
    private let infectionFactorTextField = TextFieldView()
    private let infectionTimeTextField = TextFieldView()
    private lazy var button : UIButton = {
        var configuration: UIButton.Configuration = .filled()
        configuration.title = "Запустить моделирование"
        let view = UIButton(configuration: configuration)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        configureViews()
    }
    
    func setupViews() {
        [groupSizeTextField, infectionFactorTextField, infectionTimeTextField, button].forEach(view.addSubview(_:))
        [groupSizeTextField, infectionFactorTextField, infectionTimeTextField].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
        
        
        [
            groupSizeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            groupSizeTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            groupSizeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            infectionFactorTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infectionFactorTextField.topAnchor.constraint(equalTo: groupSizeTextField.bottomAnchor, constant: 20),
            infectionFactorTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            infectionTimeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infectionTimeTextField.topAnchor.constraint(equalTo: infectionFactorTextField.bottomAnchor, constant: 20),
            infectionTimeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            button.heightAnchor.constraint(equalToConstant: 50)
        ].forEach{$0.isActive = true}
    }
    
    func configureViews() {
        groupSizeTextField.configure(titleText: "Введите количество человек",
                                     delegate: self,
                                     tag: 0)
        infectionFactorTextField.configure(titleText: "Введите количество человек, которых единовременно может заразить человек",
                                           delegate: self,
                                           tag: 1)
        infectionTimeTextField.configure(titleText: "Введите период, с которым будет происходить повторное заражение",
                                         delegate: self,
                                         tag: 2)
    }
    
    @objc func buttonTapped() {
        let viewmodel = SimulationViewModel(configs: model)
        let vc = SimulationViewController(viewModel: viewmodel)
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension ConfigureSimulationViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            guard let size = Int(textField.text ?? "") else { return }
            model.groupSize = size
        case 1:
            guard let factor = Int(textField.text ?? "") else { return }
            model.infectionFactor = factor
        case 2:
            guard let time = Int(textField.text ?? "") else { return }
            model.infectionTime = time
        default:
            break
        }
    }
}

#Preview {
    ConfigureSimulationViewController()
}
