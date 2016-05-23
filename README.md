
SimplestDemostrationOfUsingOperator
===================================

Unable to demonstrate the use of the `using` operator in Rx.playground. This project seeks the simplest way to show how it works. 


## Example is:

If you do not want to run the example simply is this:

### In _ViewController.swift_:

```swift
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
```

### Debug area output:

```
🕗
🕗
🕗
Source Observable completed
```

## License

This library belongs to _RxSwiftCommunity_.

RxSwiftExt is available under the MIT license. See the LICENSE file for more info.
