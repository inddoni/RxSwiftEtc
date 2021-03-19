//
//  RxSwiftViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxSwift
import UIKit

class RxSwiftViewController: UIViewController {
    // MARK: - Field

    var counter: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.counter += 1
            self.countLabel.text = "\(self.counter)"
        }
    }

    // MARK: - IBOutlet

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var countLabel: UILabel!

    // MARK: - IBAction

    // var disposable: Disposable?
    var disposeBag: DisposeBag = DisposeBag()
    
    @IBAction func onLoadImage(_ sender: Any) {
        imageView.image = nil

        // let disposable = rxswiftLoadImage(from: LARGER_IMAGE_URL)
        rxswiftLoadImage(from: LARGER_IMAGE_URL)
            .observeOn(MainScheduler.instance)
            .subscribe({ result in
                switch result {
                case let .next(image):
                    self.imageView.image = image

                case let .error(err):
                    print(err.localizedDescription)

                case .completed:
                    break
                }
            })
            .disposed(by: disposeBag)
            // DisposeBag 처리방법 2. 굳이 변수를 쓰지 않고 삭제할 수 있는 방법!
        // disposeBag.insert(disposable) // DisposeBag 처리방법 1.
    }

    @IBAction func onCancel(_ sender: Any) {
        // TODO: cancel image loading
        
        // disposable?.dispose()
        // 생성 된 옵져버블이 동작하고 있는 동안(image loading)의 작업을 dispose 시킬 수 있다.
        
        disposeBag = DisposeBag()
        // disposeBag은 .dispose() 같이 삭제해주는 메소드가 없다.
        // 대신 새로 disposeBag()을 만들어주면 삭제해주는 역할 (초기화)
    }

    // MARK: - RxSwift

    func rxswiftLoadImage(from imageUrl: String) -> Observable<UIImage?> {
        return Observable.create { seal in
            asyncLoadImage(from: imageUrl) { image in
                seal.onNext(image)
                seal.onCompleted()
            }
            return Disposables.create()
        }
    }
}
