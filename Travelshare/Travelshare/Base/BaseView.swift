//
//  BaseView.swift
//  Base
//
//  Created by 康景炫 on 2020/9/17.
//  Copyright © 2020 K999999999. All rights reserved.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
    }
}
