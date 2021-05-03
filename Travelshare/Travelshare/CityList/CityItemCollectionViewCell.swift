//
//  CityItemCollectionViewCell.swift
//  Travel share
//
//  Created by 康景炫 on 2021/2/12.
//

import UIKit
//import Kingfisher

class CityItemCollectionViewCell: BaseCollectionViewCell {
    override func commonInit() {
        
        addSubview(stackView)
        addSubview(imageView)
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(subLabel)
        
        imageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(hLineSpacing)
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(imageView.snp.height)
        }
        stackView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-hLineSpacing)
            make.height.equalTo(imageView)
        }
    }
    
    override func fillData(_ data: Any?) {
        let city = data as! Country.City
        label.text = city.c_name
        subLabel.text = city.city_description
        imageView.kf.setImage(with: URL(string: city.images.first!)!)
    }
    
    private lazy var label: UILabel = {
        var titlelabel = UILabel()
        titlelabel.textAlignment = .left
        titlelabel.textColor = .init(hex: 0x222222)
        titlelabel.numberOfLines = 0
        titlelabel.font = UIFont.mediumFont(formatX(17))
        return titlelabel
    }()
    private lazy var subLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.textColor = .init(hex: 0x666666)
        label.font = UIFont.normalFont(formatX(13))
        label.numberOfLines = 2
        return label
    }()

    private lazy var imageView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor.white
        return view
    }()
    private lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        return stackView
    }()
}

