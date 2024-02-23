//
//  HourlyEntryCollectionViewCell.swift
//  CollectionvViewDemo
//
//  Created by Bence Pattogato on 23/08/2021.
//

import UIKit

final class HourlyEntryCollectionViewCell: UICollectionViewCell {

    func configure(with viewModel: WeatherViewModel.Hour) {
        hourLabel.text = viewModel.time
        iconLabel.text = viewModel.icon.rawValue
        tempLabel.text = viewModel.temperature
    }
    
    let hourLabel : UILabel = {
         let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.font = UIFont.boldSystemFont(ofSize: 16.0)
         label.numberOfLines = 0
         label.lineBreakMode = .byWordWrapping
         return label
     }()
     let iconLabel : UILabel = {
         let label = UILabel()
         label.font = UIFont.boldSystemFont(ofSize: 16.0)
         label.translatesAutoresizingMaskIntoConstraints = false
         label.textColor = .black
         label.lineBreakMode = .byWordWrapping
         label.numberOfLines = 0
         return label
     }()
    
    let tempLabel : UILabel = {
         let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.font = UIFont.boldSystemFont(ofSize: 16.0)
         label.numberOfLines = 0
         label.lineBreakMode = .byWordWrapping
         return label
     }()

    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(hourLabel)
        stackView.addArrangedSubview(iconLabel)
        stackView.addArrangedSubview(tempLabel)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

}
