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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial load
        
        let requestStream = Observable.just("https://api.github.com/users")
        
        
        let responseStream = requestStream.flatMap { url -> Observable<Any> in
            return URLSession.shared.rx.json(url: URL(string: url)!)
        }
        
        _=responseStream.subscribe { event in
            dump(event.element)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

