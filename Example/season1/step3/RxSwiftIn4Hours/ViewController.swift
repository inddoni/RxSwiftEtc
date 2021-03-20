//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }

    // MARK: - IBOutler

    @IBOutlet var idField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var idValidView: UIView!
    @IBOutlet var pwValidView: UIView!

    // MARK: - Bind UI

    private func bindUI() {
        // id input +--> check valid --> bullet
        //          |
        //          +--> button enable
        //          |
        // pw input +--> check valid --> bullet
        
        // MARK: - 방법 1. 기본적인 .rx를 이용한 UI test
        idField.rx.text.orEmpty // 아래 nil 검증해주는 애 2줄 == .orEmpty
//            .filter { $0 != nil } // string이 옵셔널이니까 nil인지 체크
//            .map { $0! } // 강제 unwrapping
            .map(checkEmailValid)
            .subscribe(onNext: { b in
                self.idValidView.isHidden = b
            })
            .disposed(by: disposeBag)
        
        pwField.rx.text.orEmpty
            .map(checkPasswordValid)
            .subscribe(onNext: { b in
                self.pwValidView.isHidden = b
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            idField.rx.text.orEmpty.map(checkEmailValid),
            pwField.rx.text.orEmpty.map(checkPasswordValid),
            resultSelector: { s1, s2 in s1 && s2 }
        )
            .subscribe(onNext: { b in
                self.loginButton.isEnabled = b
            })
            .disposed(by: disposeBag)
        
        // MARK: - 방법 2. .rx를 더 고급스럽게 사용해서 UI test
        // input : id value, pw value
//        let idInputOb: Observable<String> = idField.rx.text.orEmpty.asObservable()
//        let idValidOb = idInputOb.map(checkEmailValid)
//        
//        let pwInputOb: Observable<String> = pwField.rx.text.orEmpty.asObservable()
//        let pwValidOb = pwInputOb.map(checkPasswordValid)
//        
//        // output : red bullet button, login button
//        idValidOb.subscribe(onNext: { b in self.idValidView.isHidden = b })
//            .disposed(by: disposeBag)
//        pwValidOb.subscribe(onNext: { b in self.pwValidView.isHidden = b })
//            .disposed(by: disposeBag)
//        Observable.combineLatest(idValidOb, pwValidOb, resultSelector: { $0 && $1 })
//            .subscribe(onNext: { b in self.loginButton.isEnabled = b })
//            .disposed(by: disposeBag)
    }

    // MARK: - Logic

    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }

    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
}
