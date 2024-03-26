//
//  PersonCollectionViewCell.swift
//  VKPlagueSimulationTest
//
//  Created by Ильнур Закиров on 26.03.2024.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {
    
    private let personImage: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "figure.stand"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(personImage)
        
        [
            personImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            personImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            personImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            personImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ].forEach{$0.isActive = true}
    }
    
    func updateView(isHealthy: Bool) {
        personImage.tintColor = isHealthy ? .green : .red
    }
}
