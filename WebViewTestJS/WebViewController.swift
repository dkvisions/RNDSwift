//
//  WebViewController.swift
//  WebViewTestJS
//
//  Created by WYH IOS  on 02/05/24.
//

import UIKit
import WebKit



let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

class WebViewController: UIViewController {
    
    let downLoadFileHandler = "downLoadFileHandler"
    var filesDirectory: URL?
    
    
    var wkWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
       return
    
        //MARK: - Add these key in info.plist to show content in file Publically
        /*
         <key>UIFileSharingEnabled</key>
         <true/>
         <key>LSSupportsOpeningDocumentsInPlace</key>
         <true/>
         */
        
        ///-------------------------------------Create Directory-------------------------------------
        
        do {
            filesDirectory = try createFolderInDocumentsDirectoryIfNeeded()
        } catch {
            print(error.localizedDescription)
        }
        ///-------------------------------------------------------
        
    }
    
    
    var addWeb = true
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ///Write your other code here
        let new =  NewViewController()
        new.modalPresentationStyle = .overCurrentContext
        self.present(new, animated: true)
        return
        
        //---------------------------------------------------------
        guard addWeb else { return }
        
        wkWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        wkWebView.navigationDelegate = self
        
        self.view.addSubview(wkWebView)
        addWeb.toggle()
    
       
        
        wkWebView.load(URLRequest(url: URL(string: "https://hraservices.reliancegeneral.co.in:8443/RHC/redirectingsso?policyno=ckAvS3RGU3StU3iYhuoDcknz%2fxbdTWR8JIYOxV%2fVbb0%3d&uhid=/0H5rtZ7OTSnlxLa0+RZ5g==&employeeid=EflJlqk+CqrSLNRgUkXzAQ==&SourceType=XYQ0LXu9EnRhnfNN+tYmgA==&MOBILE_CustomerID=vefR4zq6G5ioCsW6YzbdJLYvlw03pU0FhVqGQQXd2DZJ3kq64HHQjc6H7OBU0W3e&DWH_CLUSTER_ID=Q+998Knh8J2StaYm8w4oJw==&ENGINE_NO=EflJlqk+CqrSLNRgUkXzAQ==&CHASSIS_NO=EflJlqk+CqrSLNRgUkXzAQ==&seniordob=05BrAdiT287urWCcXQVYCw%3d%3d")!))
        
        //............................................................
        addLogHandlerScript()
    }
    
    func addLogHandlerScript() {
        let source = "function captureLog(msg) { window.webkit.messageHandlers.\(downLoadFileHandler).postMessage(msg); } window.console.log = captureLog;"
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        wkWebView.configuration.userContentController.addUserScript(script)
        // register the bridge script that listens for the output
        wkWebView.configuration.userContentController.add(self, name: downLoadFileHandler)
    }

}

extension WebViewController: WKScriptMessageHandler, WKNavigationDelegate {
        
    
    ///----------------------------WKScriptMessageHandler-------------------------------
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == downLoadFileHandler {
            if let dict = message.body as? [String: String] {
                
                if dict.keys.contains("FileFor") {
                    print("Dictionary found \n \(dict.keys)")
                    
                    
                    guard let directory = filesDirectory else { return }
                    
                    let destinationUrl = directory.appendingPathComponent(dict["fileName"] ?? "NewFile")
                    
                    
                    if let dataFromBase64 = dict["base64"]?.toDATA() {
                        
                        do {
                            try dataFromBase64.write(to: destinationUrl)
                            
                            
                            print("Downloaded Your file \(destinationUrl.absoluteString)")
                        }
                        catch {
                            print("cant download")
                        }
                         
                    }
                }
            }
        }
    }
    
    
    ///----------------------------WKNavigationDelegate-------------------------------
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let urlStr = navigationAction.request.url?.absoluteString {
            
            if urlStr.contains("blob:https") {
                decisionHandler(.cancel)
                
                //If blob download event found, return ; as the download will be done from the consol log
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
    
}




//MARK: --------Download file--------

extension WebViewController {
    
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
