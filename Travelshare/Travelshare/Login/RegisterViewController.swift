//
//  RegisterViewController.swift
//  Travel share
//
//  Created by 康景炫 on 2021/2/9.
//

import UIKit
import Toast_Swift

class RegisterViewController: BaseViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        logoImageView.addGestureRecognizer(UITapGestureRecognizer(handler: { [weak self] (_) in
            self?.UsernametextField.resignFirstResponder()
            self?.passwordtextField.resignFirstResponder()
        }))
        addKeybordKvo()
    }
    
    override func configViews() {
        view.addSubview(logoImageView)
        view.addSubview(UsernametextField)
        view.addSubview(passwordtextField)
        view.addSubview(RegisterButton)
        
        
        
        logoImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            //            make.centerX.equalToSuperview()
            //            make.top.equalToSuperview().offset(formatX(80))
            //            make.width.height.equalTo(formatX(80))
        }
        
        passwordtextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(formatX(-32))
            make.bottom.equalTo(RegisterButton.snp.top).offset(-16)
        }
        
        
        
        UsernametextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerX.width.height.equalTo(passwordtextField)
            make.bottom.equalTo(passwordtextField.snp.top).offset(-16)
        }
        
        RegisterButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-formatX(120))
            make.width.equalToSuperview().offset(formatX(-32))
        }
    }
    
    override func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            RegisterButton.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview().offset(-formatX(keyboardHeight) - 10)
            }
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        RegisterButton.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(-formatX(120))
        }
    }
    
    
    @objc private func RegisterAction() {
        guard let username = UsernametextField.text else {
            return
        }
        guard let password = passwordtextField.text else {
            return
        }
        
        self.view.makeToastActivity(.center)
        AppLogic.shared.api.register(username: username, password: password) { (result) in
            DispatchQueue.main.async {
                self.view.hideToastActivity()
                switch result {
                case .failure(let error):
                    self.view.makeToast(error.localizedDescription)
                case .success(_):
                    (UIApplication.shared.delegate as! AppDelegate).changeRootToVC(LoginViewController())
                }
            }
        }
    }
    
    
    private lazy var passwordtextField: UITextField = {
        let view = UITextField()
        view.backgroundColor = .white
        view.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0x120f1d).withAlphaComponent(0.7),
        ])
        view.tintColor = .init(hex: 0x120f1d)
        view.textColor = .init(hex: 0x120f1d)
        view.autocapitalizationType = .none
        view.layer.cornerRadius=formatX(6)
        view.autocorrectionType = .no
        view.spellCheckingType = .no
        view.returnKeyType = .continue
        view.isSecureTextEntry=true
        view.enablesReturnKeyAutomatically = true
        view.delegate = self
        return view
    }()
    private lazy var UsernametextField: UITextField = {
        


        let view = UITextField()
        view.backgroundColor = .white
        view.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0x120f1d).withAlphaComponent(0.7),
        ])
        view.tintColor = .init(hex: 0x120f1d)
        view.textColor = .init(hex: 0x120f1d)
        view.layer.cornerRadius=formatX(6)
        view.autocapitalizationType = .none
        view.autocorrectionType = .no
        view.spellCheckingType = .no
        view.returnKeyType = .continue
        view.enablesReturnKeyAutomatically = true
        view.delegate = self
        return view
    }()
    
    
    private lazy var logoImageView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFill
        //        view.backgroundColor = .red
        view.image = UIImage.init(named: "system")
        return view
    }()
    
    
    private lazy var RegisterButton: UIButton = {
        var button = UIButton(type: .custom)
        button.backgroundColor = UIColor.init(hex: 0xcfcfcf)
        button.setTitle("Register", for: .normal)
        button.addTarget(self, action: #selector(RegisterAction), for: .touchUpInside)
        
        
        return button
    }()
    
}
