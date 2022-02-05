# Selfie-Share

Educational multipeer connectivity app allows you to share data over Wi-Fi.

![Screenshot001](https://github.com/ClearCut3000/Selfie-Share/blob/main/Screenshots/scr001.png?raw=true)
![Screenshot002](https://github.com/ClearCut3000/Selfie-Share/blob/main/Screenshots/scr002.png?raw=true)
![Screenshot003](https://github.com/ClearCut3000/Selfie-Share/blob/main/Screenshots/scr003.png?raw=true)
![Screenshot004](https://github.com/ClearCut3000/Selfie-Share/blob/main/Screenshots/scr004.png?raw=true)
![Screenshot005](https://github.com/ClearCut3000/Selfie-Share/blob/main/Screenshots/scr005.png?raw=true)

For those who plan to repeat the project 25 from Hacking With Swift, here's what you need to add:
1. Go to Info.plist in your project and 

  1.1 delete Application Scene Manifest row.
  
  1.2 add Privacy - Local Network Usage Description
  
  1.3 add Bonjour services with the following 
  
      1.3.1 item_0: _here your serviceType from MCAdvertiserAssistant(serviceType: String._tcp 
      
      1.3.2 item_1: here your serviceType from MCAdvertiserAssistant(serviceType: String._udp
      
2. Go to AppDelegate.swift and add var window: UIWindow? in the class.

3. In the same class, delete everything below // MARK: UISceneSession Lifecycle line.
