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
        
        _=responseStream.subscribe { event in
            dump(event.element)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

