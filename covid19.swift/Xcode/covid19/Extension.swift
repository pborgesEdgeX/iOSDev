//
//  Extension.swift
//  covid19
//
//  Created by Daniel on 4/4/20.
//  Copyright © 2020 dk. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentOkAlertWithMessage(_ message: String) {
    let alertvc = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
                let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
                alertvc.addAction(action)
                self.present(alertvc, animated: true, completion: nil)
    }
}

extension URL {
    func get<T: Codable>(type: T.Type, completion: @escaping (Result<T, ApiError>) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: self) { data, _, error in
            if let _ = error {
                DispatchQueue.main.async {
                    completion(.failure(.generic))
                }
                return
            }
            
            guard let unwrapped = data else {
                DispatchQueue.main.async {
                    completion(.failure(.generic))
                }
                return
            }
            
            if let result = try? JSONDecoder().decode(type, from: unwrapped) {
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(.failure(.generic))
                }
            }
        }

        task.resume()
    }
}

enum ApiError: Error {
    case generic
}

extension ApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .generic:
            return NSLocalizedString("Could not retrieve data.", comment: "")
        }
    }
}
