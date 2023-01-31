//
//  AsynImageView.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 26/01/23.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

struct DownloadImageEndPoint: Requestable {
    var urlType: URLType
    
    let requestType: HTTPRequestType = .get()
    
    let header: [String : String]? = nil

}


class AsynImageView: UIImageView {
    
    private let imageLoadingIndicator = UIActivityIndicatorView()
    private var imageURL: URL?
    private var didSetConstraints: Bool = false
    func addImageLoadingIndicator() {
        imageLoadingIndicator.color = .darkGray

        addSubview(imageLoadingIndicator)
        imageLoadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        imageLoadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageLoadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    override func updateConstraints() {
        if !didSetConstraints {
            didSetConstraints.toggle()
            addImageLoadingIndicator()
        }
        super.updateConstraints()
    }
    
    func setImage(_ url: URL?) {
        imageURL = url

        image = nil
        
        guard let url = url else {
            return
        }
        
        imageLoadingIndicator.startAnimating()
        
        // Set cached image
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = imageFromCache
            imageLoadingIndicator.stopAnimating()
            return
        }
                
        NetworkWrapper.apiService.getData(
            DownloadImageEndPoint(
                urlType: .url(url)
            ), errorType: CustomError.self) { [weak self] result in
                guard let self = self else{
                    return
                }
                switch result {
                case .success(let data):
                    DispatchQueue.main.async(execute: {
                        
                        if let imageToCache = UIImage(data: data) {
                            
                            if self.imageURL == url {
                                self.image = imageToCache
                            }
                            
                            imageCache.setObject(imageToCache, forKey: url as AnyObject)
                        }
                        self.imageLoadingIndicator.stopAnimating()
                    })
                case .failure(let error):
                    Logger.log(error)
                    DispatchQueue.main.async(execute: {
                        self.imageLoadingIndicator.stopAnimating()
                    })
                    return
                }
            }

    }

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
