//
//  CityCollectionReusableView.swift
//  Travel share
//
//  Created by 康景炫 on 2021/2/12.
//

import UIKit

class CityCollectionReusableView: BaseCollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(hLineSpacing)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillData(country: Country) {
        label.text = country.country
    }
    
    private lazy var label: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
}
