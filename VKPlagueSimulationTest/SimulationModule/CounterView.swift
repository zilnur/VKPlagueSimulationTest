//
//  CounterView.swift
//  VKPlagueSimulationTest
//
//  Created by Ильнур Закиров on 24.03.2024.
//

import UIKit

class CounterView: UIView {
    
    private let healthyPersonLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .green
        view.textAlignment = .center
        view.text = "Здоровые"
        return view
    }()
    
    private let infectedPersonLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .red
        view.textAlignment = .center
        view.text = "Зараженные"
        return view
    }()
    
    private let healthyLabel: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .green
        view.textAlignment = .center
        return view
    }()
    
    private let infectedLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .red
        view.textAlignment = .center
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [healthyPersonLabel, infectedPersonLabel ,healthyLabel, infectedLabel].forEach(addSubview(_:))
        
        [
            healthyPersonLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            healthyPersonLabel.trailingAnchor.constraint(equalTo: centerXAnchor),
            healthyPersonLabel.topAnchor.constraint(equalTo: topAnchor),
            
            healthyLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            healthyLabel.trailingAnchor.constraint(equalTo: centerXAnchor),
            healthyLabel.topAnchor.constraint(equalTo: healthyPersonLabel.bottomAnchor),
            healthyLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            infectedPersonLabel.leadingAnchor.constraint(equalTo: centerXAnchor),
            infectedPersonLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            infectedPersonLabel.topAnchor.constraint(equalTo: topAnchor),
            
            infectedLabel.leadingAnchor.constraint(equalTo: centerXAnchor),
            infectedLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            infectedLabel.topAnchor.constraint(equalTo: infectedPersonLabel.bottomAnchor),
            infectedLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ].forEach{$0.isActive = true}
        
        
    }
    
    func updateCounters(healthy: Int, infected: Int) {
        healthyLabel.text = healthy.formatted()
        infectedLabel.text = infected.formatted()
    }

}
