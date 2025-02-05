//
//  VersionManager.swift
//  HappyYouApp
//
//  Created by Rahul Vishwakarma on 05/02/25.
//

import UIKit
//import FirebaseRemoteConfig

class VersionManager {

    
    static let shared = VersionManager()
    
//    private var remoteConfig: RemoteConfig?

    private init() {
//        guard applicationDeployOn == .prod else { return }
//        remoteConfig = RemoteConfig.remoteConfig()
    }

    private func fetchVersionInfo(completion: @escaping (String?) -> Void) {
//        remoteConfig?.fetch(withExpirationDuration: 3600) { [weak self] (status, error) in
//            if status == .success {
//                self?.remoteConfig?.activate { (changed, error) in
//                    let latestVersion = self?.remoteConfig?.configValue(forKey: "ios_force_update_version").stringValue
//                    completion(latestVersion)
//                }
//            } else {
//                completion(nil)
//            }
//        }
    }

    func checkVersionUpdate() {
        
        
        
        fetchVersionInfo { latestVersion in
            guard let latestVersion = latestVersion else {
                print("Failed to fetch latest version.")
                return
            }

            guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }

            if latestVersion.compare(currentVersion, options: .numeric) == .orderedDescending {
                
                DispatchQueue.main.async { [weak self] in
                    self?.promptUserToUpdate()
                }
                
            }
        }
    }

    private func promptUserToUpdate() {
        let alert = UIAlertController(title: "Update Available", message: "A new version of the app is available on Appstore. Please update to the latest version.", preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { _ in
            if let url = URL(string: "itms-apps://itunes.apple.com/app/id6448199779") {
                UIApplication.shared.open(url)
            }
        }))
        
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true)
        }
    }
}





//MARK: Through App Store API

class AppVersionCheck {
  
  public static let shared = AppVersionCheck()

  func isUpdateAvailable(callback: @escaping (Bool)->Void) {
      guard let bundleId = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String else { return }
      guard let localAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
      
      guard let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleId)&country=in") else { return }
          let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
          if let data = data {
              do {
                  let jsonObject = try JSONSerialization.jsonObject(with: data)
                  guard let json = jsonObject as? [String: Any] else {
                      debugPrint("The received that is not a Dictionary")
                      return
                  }
                  let results = json["results"] as? [[String: Any]]
                  let firstResult = results?.first
                  let currentVersion = firstResult?["version"] as? String
                  debugPrint("currentVersion: ", currentVersion as Any)
                  debugPrint("localVersion: ", localAppVersion as Any)
                  if currentVersion?.compare(localAppVersion, options: .numeric) == .orderedDescending {
                     callback(true)
                  }else{
                      callback(false)
                  }
              } catch let serializationError {
                  callback(false)
                  debugPrint("Serialization Error: ", serializationError)
              }
          } else if let error = error {
              callback(false)
              debugPrint("Error: ", error)
          } else if let response = response {
              debugPrint("Response: ", response)
          } else {
              callback(false)
              debugPrint("Unknown error")
          }
      }
      task.resume()
  }
  
}

