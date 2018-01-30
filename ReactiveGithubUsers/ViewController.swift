//
//  ViewController.swift
//  ReactiveGithubUsers
//
//  Created by Богдан Маншилин on 27/01/2018.
//  Copyright © 2018 BManshilin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    enum Error: Swift.Error {
        case errorSerializingJSON
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton.rx.init(UIButton())
        button.base.setTitleColor(.red, for: .normal)
        button.base.setTitle("ХУЙ", for: .normal)
        button.base.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button.base)
        NSLayoutConstraint.activate([
            button.base.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.base.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        // All request
        
        let requestStream = button.tap.startWith(())
            .map {"https://api.github.com/users?since=\(arc4random_uniform(500))"}
        
        // Response
        
        let responseStream = requestStream.flatMap { url -> Observable<Any> in
            return URLSession.shared.rx.json(url: URL(string: url)!)
        } 
        
        let serializedStream = responseStream.flatMap { json in
            return Observable<[[String: Any]]>.create { observer in
                if let array = json as? [[String: Any]] {
                    observer.onNext(array)
                } else {
                    observer.onError(Error.errorSerializingJSON)
                }
                observer.onCompleted()
                return Disposables.create()
            }
        }
        
        // 3 suggestions
        
        let suggestionsStream = serializedStream.flatMap { array in
            return Observable<[String: Any]>.create { observer in
                for _ in 0..<3 {
                    let rand = Int(arc4random_uniform(UInt32(array.count)))
                    observer.onNext(array[rand])
                }
                observer.onCompleted()
                return Disposables.create()
            }
        }
        
        _=suggestionsStream.subscribe { event in
            dump(event.element)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

