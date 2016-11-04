//
//  UIImageViewExtensions.swift
//  EliteBase
//
//  Created by Jonathan Lu on 4/6/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import UIKit

extension UIImageView {
    public func setImageWithURL(_ urlString: String) {
        if let url = URL(string: urlString) {
			let request = URLRequest(url: url);
			let session = URLSession.shared
			session.dataTask(with: request) { data, response, error in
                if let data = data{
                    self.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
