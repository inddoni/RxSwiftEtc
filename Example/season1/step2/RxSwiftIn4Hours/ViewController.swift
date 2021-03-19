//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxSwift
import UIKit

class ViewController: UITableViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Observable을 create해주는 method 중 하나
    @IBAction func exJust1() {
        Observable.just("Hello World")
            //just()에 넣어준 애개 onNext의 인자로 그대로 내려옴 (여기서는 str에)
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exJust2() {
        Observable.just(["Hello", "World"])
            // string이든 array든 넣어주는 대로 고대로 인자로 들어가서 나옴 (exJust1과 비교)
            .subscribe(onNext: { arr in
                print(arr)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exFrom1() {
        Observable.from(["RxSwift", "In", "4", "Hours"])
            // array에 있는 elements를 "하나씩" 인자로 받아옴
            // "하나씩" 내려오는 것 == Stream으로 처리 되는 것
            // .of()로 바꾸면 just 처럼 array 통으로 출력 됨
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exMap1() {
        Observable.just("Hello")
            .map { str in "\(str) RxSwift" } // str = "Hello"
            // map은 위에 있는 애에게 인자를 받아서 처리 후 아래로 내려주는 역할!
            .subscribe(onNext: { str in // str = "Hello RxSwift"
                print(str)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exMap2() {
        Observable.from(["with", "곰튀김"])
            .map { $0.count }
            // string이 "하나씩" 내려왔다가 .count로 인해 integer로 바뀌어서 내려감
            .subscribe(onNext: { str in
                print(str) // 4 \n 3 출력
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exFilter() {
        Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
            .filter { $0 % 2 == 0 }
            // .filter의 조건문에서 False면 더 이상 밑으로 흐르지 않음. True일 경우에만 Stream
            .subscribe(onNext: { n in
                print(n)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exMap3() {
        Observable.just("800x600")
            .map { $0.replacingOccurrences(of: "x", with: "/") } // "800/600"
            .map { "https://picsum.photos/\($0)/?random" } // "https://picsum.photos/800/600/?random"
            .map { URL(string: $0) } // URL?
            .filter { $0 != nil } // nil이 아닐때만 True
            .map { $0! } // URL!, 강제 unwrapping(!), error 안남 (위에 .filter로 인해 nil값 안내려오니까)
            .map { try Data(contentsOf: $0) } // URL에 있는 내용을 받은 Data
            .map { UIImage(data: $0) } // Data로 UIImage 객체 생성, UIImage?
            .subscribe(onNext: { image in // image == UIImage?
                self.imageView.image = image
            })
            .disposed(by: disposeBag)
    }
}
