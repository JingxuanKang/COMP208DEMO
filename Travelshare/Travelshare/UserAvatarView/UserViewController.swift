//
//  UserViewController.swift
//  Travel share
//
//  Created by 康景炫 on 2021/2/20.
//

import UIKit

enum UserInfoType: String {
    case email = "Email"
    case phoneNumber = "Phone Number"
    case birthday = "Birthday"
}

class UserViewController: BaseViewController {
    
    public var finishPickingMediaWithInfo: ([UIImagePickerController.InfoKey: Any]) -> () = {info in}

    override func viewDidLoad(){
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateUser), name: .init("userinfoChanged"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func configViews() {
        view.addSubview(imageView)
        view.addSubview(usernamelabel)
        view.addSubview(attributeView)
        view.addSubview(LogoutButton)
        
        imageView.image = UIImage.init(named: "avator")
        
        imageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(64)
            make.top.equalToSuperview().offset(hLineSpacing+hLineSpacing+hLineSpacing+hLineSpacing)
            make.centerX.equalToSuperview()
        }
        
        usernamelabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(hLineSpacing)
            make.centerX.equalToSuperview()
        }
        
        attributeView.snp.makeConstraints { (make) in
            make.top.equalTo(usernamelabel.snp.bottom).offset(hLineSpacing)
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(attributeView.getViewHeight()+hLineSpacing)
        }
        
        LogoutButton.snp.makeConstraints { (make) in
//            make.top.equalTo(attributeView.snp.bottom).offset(hLineSpacing+hLineSpacing)
            make.bottom.equalToSuperview().offset(-hLineSpacing-hLineSpacing-hLineSpacing)
            make.centerX.equalToSuperview()
            make.width.equalTo(formatX(160))
            make.height.equalTo(formatX(30))
        }
    }
    
    @objc private func updateUser() {
        attributeView.user = AppLogic.shared.user
    }
    
    //MARK: openCarema
    public func openCaremaPresentFrom() {
        self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    //MARK: openAlbum
    public func openAlbumFrom() {
        self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.imagePicker.modalPresentationStyle = .fullScreen
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    private func chooseImageAction() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            self.openCaremaPresentFrom()
        }))
        alert.addAction(UIAlertAction(title: "Album", style: .default , handler:{ (UIAlertAction)in
            self.openAlbumFrom()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
        }))
        self.present(alert, animated: true, completion: {
        })
    }
    
    private func handleImage(image: UIImage) {
        // todo ; upload image to server and change the imageView's image
        self.imageView.image = image
    }
    
    //////////////////////////////
    private lazy var imageView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 32
        view.layer.borderColor = UIColor.init(hex: 0x000000).cgColor
        view.layer.borderWidth = 1
        view.isUserInteractionEnabled = true
        view.addTapGesture { [weak self] (ges) in
            self?.chooseImageAction()
        }
        return view
    }()
    
    private lazy var usernamelabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    private let attributeView: UserInterfaceAttribute = .init()
    
    private lazy var LogoutButton: UIButton = {
        var button = UIButton(type: .custom)
        button.backgroundColor = UIColor.init(hex: 0xcfcfcf)
        button.setTitle("Log out", for: .normal)
        button.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
        button.layer.cornerRadius=formatX(6)
        return button
    }()
    
    @objc private func logoutAction() {
        AppLogic.shared.user = nil
        (UIApplication.shared.delegate as! AppDelegate).changeRootToVC(UINavigationController(rootViewController: WelcomeViewController()))
    }
    
    //MARK: Picker
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
}


extension UserViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true) {[weak self] in
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self?.handleImage(image: image)
            }
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

