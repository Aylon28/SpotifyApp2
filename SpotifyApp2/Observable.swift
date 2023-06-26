//
//  Observable.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 15.04.23.
//

import Foundation

class Observable<T> {
    var value: T {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                self.listener?(self.value)
            }
        }
    }
    private var listener: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ listener: @escaping (T) -> Void) {
        listener(value)
        self.listener = listener
    }
}
