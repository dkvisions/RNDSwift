//
//  ViewController.swift
//  WebViewTestJS
//
//  Created by WYH IOS  on 15/04/24.
//

import UIKit
import WebKit

import AppTrackingTransparency


enum  ResponseError: Error {

    case documnentDirectoryNil
    case invalidData
    case decodeError
    case error(Int)
    case somthingWentWrong
    case invalidURL

}



struct DownloadFileFromWebModel: Codable {
    let fileFor, fileName, base64: String?

    enum CodingKeys: String, CodingKey {
        case fileFor = "FileFor"
        case fileName, base64
    }
}


///Refer from URL
///https://medium.com/john-lewis-software-engineering/ios-wkwebview-communication-using-javascript-and-swift-ee077e0127eb

class ViewController: UIViewController {

    let iosDownloadHandler = "iosDownloadHandler"
    
    var filesDirectory: URL?
    
    var wkWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        // Request tracking authorization
        ATTrackingManager.requestTrackingAuthorization { status in
            // Handle authorization status
            switch status {
            case .authorized:
                print("authorized")
            case .denied:
                print("User denied tracking")
            case .restricted:
                print("Tracking is restricted")
            case .notDetermined:
                print("Tracking authorization has not been requested yet")
            @unknown default:
                break
            }
        }
        
        
    
        do {
            filesDirectory = try createFolderInDocumentsDirectoryIfNeeded()
        } catch {
            print(error.localizedDescription)
        }
    
        
    }
    
    
    
    
    func addLogHandlerScript() {
        //------New---------
        
        let source = "function captureLog(msg) { window.webkit.messageHandlers.logHandler.postMessage(msg); } window.console.log = captureLog;"
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        wkWebView.configuration.userContentController.addUserScript(script)
        // register the bridge script that listens for the output
        wkWebView.configuration.userContentController.add(self, name: "logHandler")
    }
    
    
    
    var addWeb = true
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ///Write your other code here
        
        //---------------------------------------------------------
        guard addWeb else { return }
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(self, name: iosDownloadHandler)
        
        wkWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), configuration: configuration)
        
        wkWebView.navigationDelegate = self
        
        self.view.addSubview(wkWebView)
        addWeb.toggle()
    
        
        
        addLogHandlerScript()
        
        //............................................................
        
        wkWebView.load(URLRequest(url: URL(string: "https://hraservices.reliancegeneral.co.in:8443/RHC/redirectingsso?policyno=ckAvS3RGU3StU3iYhuoDcknz%2fxbdTWR8JIYOxV%2fVbb0%3d&uhid=/0H5rtZ7OTSnlxLa0+RZ5g==&employeeid=EflJlqk+CqrSLNRgUkXzAQ==&SourceType=XYQ0LXu9EnRhnfNN+tYmgA==&MOBILE_CustomerID=vefR4zq6G5ioCsW6YzbdJLYvlw03pU0FhVqGQQXd2DZJ3kq64HHQjc6H7OBU0W3e&DWH_CLUSTER_ID=Q+998Knh8J2StaYm8w4oJw==&ENGINE_NO=EflJlqk+CqrSLNRgUkXzAQ==&CHASSIS_NO=EflJlqk+CqrSLNRgUkXzAQ==&seniordob=05BrAdiT287urWCcXQVYCw%3d%3d")!))
        
        
        //        wkWebView.load(URLRequest(url: URL(string: "https://rhealthcircle.reliancegeneral.co.in/rhc/redirectingsso?policyno=ckAvS3RGU3StU3iYhuoDcknz%2fxbdTWR8JIYOxV%2fVbb0%3d&uhid=/0H5rtZ7OTSnlxLa0+RZ5g==&employeeid=EflJlqk+CqrSLNRgUkXzAQ==&SourceType=XYQ0LXu9EnRhnfNN+tYmgA==&MOBILE_CustomerID=vefR4zq6G5ioCsW6YzbdJLYvlw03pU0FhVqGQQXd2DZJ3kq64HHQjc6H7OBU0W3e&DWH_CLUSTER_ID=Q+998Knh8J2StaYm8w4oJw==&ENGINE_NO=EflJlqk+CqrSLNRgUkXzAQ==&CHASSIS_NO=EflJlqk+CqrSLNRgUkXzAQ==&seniordob=05BrAdiT287urWCcXQVYCw%3d%3d")!))
        
    }

}

extension ViewController: WKScriptMessageHandler, WKNavigationDelegate {
        
    
    ///----------------------------WKScriptMessageHandler-------------------------------
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        print("message.name  \(message.name)")
      
        if message.name == iosDownloadHandler {
            print("json String \(message.body)")
        
        }
        
        if message.name == "logHandler" {
            
            
            if let dict = message.body as? [String: String] {
                
                if dict.keys.contains("FileFor") {
                    print("Dictionary founc")
                }
                
            }
            print("LOG: \(message.body)")
        }
    }
    
    
    ///----------------------------WKNavigationDelegate-------------------------------
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let urlStr = navigationAction.request.url?.absoluteString {
            
            print(urlStr)
            if urlStr.contains("blob:") {
                decisionHandler(.cancel)
                return
            }
            
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("didCommit.....")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish.....")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFail.....")
    }
    
    
    func showAlert(msg: String) {
        
        let alerVC = UIAlertController(title: "Success", message: msg, preferredStyle: .alert)
        
        alerVC.addAction(UIAlertAction(title: "Okay", style: .default))
        
        
        self.present(alerVC, animated: true)
        
        
    }
}




//MARK: --------Download file--------

extension ViewController {
    
    
    func downLoadFile(urlString: String) async throws -> String {
        
        guard let url = URL(string: urlString) else { throw ResponseError.invalidURL }
        guard let directory = filesDirectory else { throw ResponseError.documnentDirectoryNil}
        
        let destinationUrl = directory.appendingPathComponent(url.lastPathComponent)
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer Y3GzLG2x6wSXihmUGhwGFw", forHTTPHeaderField: "Authorization")
        
        
        let prarams = [
            "FileFor": "RECORD",
            "fileName": "46e7cc26-08d6-41b6-92c3-6a939ff3a339.png",
            "DisplayName": "Screenshot 2024-04-02 173030"
        ]
        
        
        var jsonData: Data?
        do {
            jsonData = try? JSONSerialization.data(withJSONObject: prarams)
        }
        guard let jsonData = jsonData else { throw ResponseError.invalidData}
        
        request.httpBody = jsonData
        
        request.httpMethod = "POST"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let responseCode = response as? HTTPURLResponse {
                if responseCode.statusCode == 200 {
                    
                    do {
                        
                        
                        let modelData = try JSONDecoder().decode(DownloadFileFromWebModel.self, from: data)
                        
                        
                        if let dataFromBase64 = modelData.base64?.toDATA() {
                            try dataFromBase64.write(to: destinationUrl)
                            
                            //MARK: You can add toast message like "File downloaded successfully"
                            print("Downloaded ")
                            
                        }
                        return destinationUrl.path
                        
                    } catch {
                        throw error
                        
                    }
                    
                } else {
                    throw ResponseError.error(responseCode.statusCode)
                }
                
            } else {
                throw ResponseError.somthingWentWrong
            }
            
            
        } catch {
            throw ResponseError.somthingWentWrong
        }
    
    }
    
    
    private func createFolderInDocumentsDirectoryIfNeeded() throws -> URL {
        
        let fileManager = FileManager.default
        let folderURL = documentsURL.appendingPathComponent("documents")
        var isDirectory: ObjCBool = false
        
        if fileManager.fileExists(atPath: folderURL.path, isDirectory: &isDirectory) {
            
            if isDirectory.boolValue {
                return folderURL
                
            } else {
                // A file with the same name exists, handle appropriately
                throw NSError(domain: "", code: 1001, userInfo: [NSLocalizedDescriptionKey: "A file with the same name exists at the specified path."])
            }
        } else {
            // Folder does not exist, create it
            do {
                try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                return folderURL
            } catch {
                throw error
            }
        }
    }

}


extension String {
    
    fileprivate func toDATA() -> Data? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return data
        }
        return nil
    }
}
