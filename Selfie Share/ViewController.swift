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
    mcAdvertiserAssistant?.start()
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
    guard let mcSession = mcSession else { return }
    if mcSession.connectedPeers.count > 0 {
      if let imageData = image.pngData() {
        do {
          try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
        } catch {
          let alert = UIAlertController(title: "Send Error!", message: error.localizedDescription, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default))
          present(alert, animated: true)
        }
      }
    }
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

  //MARK: - MCBrowserViewControllerDelegateProtocol
  func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
    dismiss(animated: true)
  }

  func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
    dismiss(animated: true)
  }

  //MARK: - MCSessionDelegateProtocol
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    switch state {
    case .notConnected:
      print ("Not connected: \(peerID.displayName)")
    case .connecting:
      print ("Connecting: \(peerID.displayName)")
    case .connected:
      print ("Connected: \(peerID.displayName)")
    @unknown default:
      print ("Unknown state received: \(peerID.displayName)")
    }
  }

  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    DispatchQueue.main.async { [weak self] in
      if let image = UIImage(data: data) {
        self?.images.insert(image, at: 0)
        self?.collectionView.reloadData()
      }
    }
  }

  func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}

  func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}

  func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}



}

