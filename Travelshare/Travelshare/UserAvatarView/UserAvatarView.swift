//
//  UserAvatarView.swift
//  Travel share
//
//  Created by 康景炫 on 2021/2/20.
//

import UIKit

class UserAvatarView: BaseView {
    
    override func commonInit() {
        self.snp.makeConstraints { (make) in
            make.width.height.equalTo(36)
        }
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        imageView.image = UIImage(named: "publish")?.colored(appMainColor)
        
        self.addGestureRecognizer(UITapGestureRecognizer(handler: { (tapges) in
            if false == AppLogic.shared.isLogin {
                let vc = LoginViewController()
                self.currentViewController?.present(vc, animated: true, completion: nil)
                return
            }
            // jump to user info vc
            let vc = PublishViewController()
            let rvc = UINavigationController(rootViewController: vc)
//            rvc.modalPresentationStyle = .fullScreen
            self.currentViewController?.present(rvc, animated: true, completion: nil)
        }))
    }
    
    private lazy var imageView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleToFill
        view.clipsToBounds = false
        view.layer.cornerRadius = 18
//        view.layer.borderColor = UIColor.init(hex: 0x000000).cgColor
   
//        view.layer.borderWidth = 1
        return view
    }()
}
