//
//  ViewController.swift
//  Selfie Share
//
//  Created by Николай Никитин on 03.02.2022.
//

import MultipeerConnectivity
import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {

  //MARK: - Properties
  var images = [UIImage]()
  var peerID = MCPeerID(displayName: UIDevice.current.name)
  var mcSession: MCSession?
  var mcAdvertiserAssistant: MCAdvertiserAssistant?

  //MARK: - UIView lifacycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Selfie Share"
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPromt))
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
    mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
    mcSession?.delegate = self
  }

  //MARK: - Methods
  @objc func importPicture() {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }

  @objc func showConnectionPromt() {
    let alert = UIAlertController(title: "Connect to others.", message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
    alert.addAction(UIAlertAction(title: "Join session", style: .default, handler: joinSession))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(alert, animated: true)
  }

  func startHosting(ction: UIAlertAction) {
    guard let mcSession = mcSession else { return }
    mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-selfieshare", discoveryInfo: nil, session: mcSession)
  }

  func joinSession(action: UIAlertAction) {
    guard let mcSession = mcSession else { return }
    let mcBrowser = MCBrowserViewController(serviceType: "hws-selfieshare", session: mcSession)
    mcBrowser.delegate = self
    present(mcBrowser, animated: true)
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

