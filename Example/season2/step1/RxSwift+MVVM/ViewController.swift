//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import RxSwift
import SwiftyJSON
import UIKit

let MEMBER_LIST_URL = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"

//class 나중에생기는데이터
class observable<T> {
    private let task: (@escaping (T) -> Void) -> Void
    init(task: @escaping (@escaping (T) -> Void) -> Void) {
        self.task = task
    }
    // func 나중에오면
    func subscribe(_ f: @escaping(T) -> Void){
        task(f)
    }
}
class ViewController: UIViewController {
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var editView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.timerLabel.text = "\(Date().timeIntervalSince1970)"
        }
    }

    private func setVisibleWithAnimation(_ v: UIView?, _ s: Bool) {
        guard let v = v else { return }
        UIView.animate(withDuration: 0.3, animations: { [weak v] in
            v?.isHidden = !s
        }, completion: { [weak self] _ in
            self?.view.layoutIfNeeded()
        })
    }

    // Promisekit : .then으로 비동기 클로저 결과(나중에 생기는 데이터) 받아와서 처리
    // Bolt : .then으로 비동기 클로저 결과(나중에 생기는 데이터) 받아와서 처리
    // RxSwift : subscribe으로 비동기 클로저 결과(나중에 생기는 데이터 == observable) 받아와서 처리
    //           observable은 event로 동작한다! (onNext 등으로 이벤트를 발생시켜서 데이터를 전달함)
    //           case next, error, completed
    //           비동기로 생기는 결과값을 completion같은 클로저로 전달하는 것이 아니라 리턴값으로 전달하기 위해서 만든 라이브러리
    
    // MARK: SYNC

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // @escaping : 본체함수가 끝나고 나서 실행되는 함수부분에 써주는 것
//    func downloadJson(_ url: String, _ completion: @escaping (String?) -> Void) {
//        DispatchQueue.global().async {
//            let url = URL(string: url)!
//            let data = try! Data(contentsOf: url)
//            let json = String(data: data, encoding: .utf8)
//            DispatchQueue.main.async {
//                completion(json)
//            }
//        }
//    }
    
    func downloadJson(_ url: String) -> observable<String?> {
        return observable() { f in
            DispatchQueue.global().async {
                let url = URL(string: url)!
                let data = try! Data(contentsOf: url)
                let json = String(data: data, encoding: .utf8)
                DispatchQueue.main.async {
                    f(json)
                }
            }
        }
    }
    
    @IBAction func onLoad() {
        editView.text = ""
        setVisibleWithAnimation(activityIndicator, true)
        
        // @escaping 으로 비동기 처리했을 때 코드
//        downloadJson(MEMBER_LIST_URL) { json in
//            self.editView.text = json
//            self.setVisibleWithAnimation(self.activityIndicator, false)
//        }
        // 이렇게 비동기처리를 해주면 안좋은 점
        // completion(클로저)으로 전달을 해주니까 그 자리에서 바로 사용해야 하고,
        // 에러나 예외케이스 처리나 변환 등의 처리를 해주는 것이 어렵다. (변수로 받아오는 것처럼 하면 핸들링 편한데,,)
        
        // rxswift로 비동기 처리했을 때 코드
        downloadJson(MEMBER_LIST_URL)
            .subscribe { json in
            self.editView.text = json
            self.setVisibleWithAnimation(self.activityIndicator, false)
            }
        
    }
    
    // RxSwift 사용법
    // 1. 비동기로 생기는 데이터를 Observable로 감싸서 리턴하는 방법 : .create(), .onNext() - 데이터를 전달, .onCompleted() - 데이터 전달이 끝났다
    // 2. Observable로 오는 데이터를 받아서 처리하는 방법 : .subscribe, switch event
    
}
