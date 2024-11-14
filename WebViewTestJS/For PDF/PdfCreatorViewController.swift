//
//  PdfCreatorViewController.swift
//  MyNewProject
//
//  Created by Rahul Vishwakarma on 06/11/24.
//

import UIKit
import QuickLook


class TableCellForPdf: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}



class PdfCreatorViewController: UIViewController {
  
    

    @IBOutlet weak var tableViewContainer: UITableView!
    
    lazy var previewItem = NSURL()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewSetUp()
    }
    
    
    
}


extension PdfCreatorViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableViewSetUp() {
        tableViewContainer.delegate = self
        tableViewContainer.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellForPdf")
        
        
        return cell ?? UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let cellView = tableView.cellForRow(at: indexPath) {
            
            let myImage = cellView.contentView.asImage()
            
            print(myImage, "Image Found")
            
            
            if let url = TheCreatorOfPDF.createAndViewPdf(image: myImage) {
                showPdfInNext(url: url)
            }
        }
    }
    
    
    func showPdfInNext(url: URL) {
        
        previewItem = NSURL(fileURLWithPath: url.path)
        
        let qlController = QLPreviewController()
        qlController.dataSource = self
        
        
        self.present(qlController, animated: true)
    }
    
    
}

extension PdfCreatorViewController: QLPreviewControllerDataSource {
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> any QLPreviewItem {
        previewItem
    }
}


extension UIView {

    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}




class TheCreatorOfPDF {
    
    
    static private func createPDF(image: UIImage) -> NSData? {
        
        let pdfData = NSMutableData()
        let pdfConsumer = CGDataConsumer(data: pdfData as CFMutableData)!
        
        var mediaBox = CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        let pdfContext = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil)!
        
        pdfContext.beginPage(mediaBox: &mediaBox)
        pdfContext.draw(image.cgImage!, in: mediaBox)
        pdfContext.endPage()
        
        return pdfData
    }
    
    
    static func createAndViewPdf(image: UIImage) -> URL? {
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let docURL = documentDirectory.appendingPathComponent("myFileName.pdf")
        
        
        if let createdFile = createPDF(image: image) {
            
            createdFile.write(to: docURL, atomically: true)
            
            return docURL
        }
        return nil
        
    }
    
}
