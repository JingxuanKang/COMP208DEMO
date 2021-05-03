//
//  LoginViewController.swift
//  Travel share
//
//  Created by 康景炫 on 2021/2/9.
//

import UIKit
import SnapKit

class WelcomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(logoImageView)
        view.addSubview(skipButton)
        view.addSubview(loginButton)
        view.addSubview(signupButton)
        
        logoImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
//            make.centerX.equalToSuperview()
//            make.top.equalToSuperview().offset(formatX(80))
//            make.width.height.equalTo(formatX(80))
        }
        skipButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-formatX(16))
            make.bottom.equalTo(loginButton.snp.top).offset(-16)
        }
        loginButton.snp.makeConstraints { (make) in
            make.centerX.width.height.equalTo(signupButton)
            make.bottom.equalTo(signupButton.snp.top).offset(-16)
        }
        signupButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-formatX(80))
            make.width.equalToSuperview().offset(formatX(-32))
        }
    }
    
    @objc private func skipAction() {
        self.navigationController?.pushViewController(MainViewController(), animated: true)
    }
    
    @objc private func loginAction() {
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }

    @objc private func signupAction() {
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    private lazy var logoImageView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFill
//        view.backgroundColor = .red
        view.image = UIImage.init(named: "system")
        return view
    }()
    
    private lazy var skipButton: UIButton = {
        var button = UIButton(type: .custom)
        button.setTitle("Skip", for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(skipAction), for: .touchUpInside)
        button.layer.cornerRadius=formatX(6)
        return button
    }()
    private lazy var loginButton: UIButton = {
        var button = UIButton(type: .custom)
        button.backgroundColor = UIColor.init(hex: 0xcfcfcf)
        button.setTitle("Log in", for: .normal)
        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        button.layer.cornerRadius=formatX(6)
        return button
    }()
    private lazy var signupButton: UIButton = {
        var button = UIButton(type: .custom)
        button.backgroundColor = UIColor.init(hex: 0xcfcfcf)
        button.setTitle("Sign up", for: .normal)
        button.addTarget(self, action: #selector(signupAction), for: .touchUpInside)
        button.layer.cornerRadius=formatX(6)
        return button
    }()
}
