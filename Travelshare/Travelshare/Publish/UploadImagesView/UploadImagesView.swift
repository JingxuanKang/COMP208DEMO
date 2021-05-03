//
//  UploadImagesView.swift
//  Travelshare
//
//  Created by 康景炫 on 2021/3/31.
//

import UIKit

class UploadImagesView: BaseView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static let MaxImageCount: Int = 9
    static let CellSize: CGFloat = 80
    
    var dataSource: [UIImage] = .init()
    
    override func commonInit() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
    }

    // MARK: -
    private func chooseImage() {
        self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.imagePicker.modalPresentationStyle = .fullScreen
        self.currentViewController?.present(self.imagePicker, animated: true, completion: nil)
    }

    private func handleImage(image: UIImage) {
        dataSource.append(image)
        collectionView.reloadData()
    }
    
    // MARK: -
    private lazy var layout: UICollectionViewFlowLayout = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = layout.minimumLineSpacing
        layout.sectionInset = .init(top: 0, left: hLineSpacing, bottom: 0, right: hLineSpacing)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        var view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.register(UploadImagesViewCell.self, forCellWithReuseIdentifier: UploadImagesViewCell.reuseIdentifier)
        view.register(UploadImagesViewAddCell.self, forCellWithReuseIdentifier: UploadImagesViewAddCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        return view
    }()
    
    //MARK: Picker
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
}

extension UploadImagesView {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            if dataSource.count == Self.MaxImageCount {
                return 0
            }
            return 1
        }
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: Self.CellSize, height: Self.CellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UploadImagesViewCell.reuseIdentifier, for: indexPath) as! UploadImagesViewCell
            cell.deleteActionHandler = { [weak self] in
                self?.dataSource.remove(at: indexPath.row)
                self?.collectionView.reloadData()
            }
            let model = dataSource[indexPath.row]
            cell.fillData(model)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UploadImagesViewAddCell.reuseIdentifier, for: indexPath) as! UploadImagesViewAddCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            chooseImage()
        } else {
        }
    }
}

extension UploadImagesView: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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
