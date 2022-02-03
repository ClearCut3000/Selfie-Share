//
//  ViewController.swift
//  Selfie Share
//
//  Created by Николай Никитин on 03.02.2022.
//

import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

  //MARK: - Properties
  var images = [UIImage]()

  //MARK: - UIView lifacycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Selfie Share"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
  }

  //MARK: - Methods
  @objc func importPicture() {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }

  //MARK: - UIImagePickerControllerDelegate Methods
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else { return }
    dismiss(animated: true)
    images.insert(image, at: 0)
    collectionView.reloadData()
  }

  //MARK: - UICollectionViewController Methods
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageView", for: indexPath)
    if let imageView = cell.viewWithTag(1000) as? UIImageView {
      imageView.image = images[indexPath.item]
    }
    return cell
  }
}

