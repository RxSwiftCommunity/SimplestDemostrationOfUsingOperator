//
//  ViewController.swift
//  SimplestDemostrationOfUsingOperator
//
//  Created by Carlos García on 23/05/16.
//  Copyright © 2016 RxSwiftCommunity - https://github.com/RxSwiftCommunity. All rights reserved.
//

import UIKit
import RxSwift

func runAfterDelay(delay: NSTimeInterval, block: dispatch_block_t) {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
    dispatch_after(time, dispatch_get_main_queue(), block)
}

class MyDisposableResource: Disposable {
    
    let myObservable = Observable<Int32>.interval(1.0, scheduler: MainScheduler.instance)
    let disposable: Disposable
    
    init() {
        disposable = myObservable.subscribeNext { _ in print("🕗") }
    }
    
    func dispose() {
        disposable.dispose()
    }
}

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The observableFactory closure returns a Observable (Observable<Int32> in this case).
        // The observable returned by Observable.using constructor is the same than given by the observableFactory closure.
        // While Observable.using create a Disposable instance (MyDisposableResource) whose lifespan is the same than the observable given by the observableFactory closure.
        
        let xObservable/*:Observable<Int32>*/ = Observable.using({ return MyDisposableResource() }, observableFactory: {
            disposable -> Observable<Int32> in
            
            return Observable<Int32>.create { observer -> Disposable in
                runAfterDelay(3.0) {
                    observer.on(.Completed)
                }
                return AnonymousDisposable {}
            }
        })
        
        xObservable.subscribeCompleted {
                print("Source Observable completed")
            }
            .addDisposableTo(disposeBag)
        
    }
    
}

