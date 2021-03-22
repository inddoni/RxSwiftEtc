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

    let idValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let pwValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    let idInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let pwInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindInput()
        bindOutput()
    }

    // MARK: - IBOutler

    @IBOutlet var idField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var idValidView: UIView!
    @IBOutlet var pwValidView: UIView!

    // MARK: - Bind UI

    private func bindInput() {
        // id input +--> check valid --> bullet
        //          |
        //          +--> button enable
        //          |
        // pw input +--> check valid --> bullet
        
        // MARK: - 방법 1. 기본적인 .rx를 이용한 UI test
//        idField.rx.text.orEmpty // 아래 nil 검증해주는 애 2줄 == .orEmpty
//            .filter { $0 != nil } // string이 옵셔널이니까 nil인지 체크
//            .map { $0! } // 강제 unwrapping
//            .map(checkEmailValid)
//            .subscribe(onNext: { b in
//                self.idValidView.isHidden = b
//            })
//            .disposed(by: disposeBag)
//
//        pwField.rx.text.orEmpty
//            .map(checkPasswordValid)
//            .subscribe(onNext: { b in
//                self.pwValidView.isHidden = b
//            })
//            .disposed(by: disposeBag)
//
//        Observable.combineLatest(
//            idField.rx.text.orEmpty.map(checkEmailValid),
//            pwField.rx.text.orEmpty.map(checkPasswordValid),
//            resultSelector: { s1, s2 in s1 && s2 }
//        )
//            .subscribe(onNext: { b in
//                self.loginButton.isEnabled = b
//            })
//            .disposed(by: disposeBag)
        
        // MARK: - 방법 2. .rx를 더 고급스럽게 사용해서 UI test
        // input : id value, pw value
        //let idInputOb: Observable<String> = idField.rx.text.orEmpty.asObservable()
        
        // MARK - final start
        // id필드 내용 저장
        idField.rx.text.orEmpty
            .bind(to: idInputText)
            .disposed(by: disposeBag)
        // id필드 valid check
        idInputText
            .map(checkEmailValid)
            .bind(to: idValid)
            .disposed(by: disposeBag)
        // bind return 값이 Disposable이므로 .disposed 해줌
        
        // BehaviorSubject에 값 넣어주기! (onNext 사용해서)
        // idValidOb.subscribe(onNext: { b in
        //    self.idValid.onNext(b)
        // })
        // 혹은 아래 방법! (이걸 더 자주씀, 위윗줄에 map 뒤에 바로 붙혀서 간결하게 사용)
        // idValidOb.bind(to: idValid)
        
        // let pwInputOb: Observable<String> = pwField.rx.text.orEmpty.asObservable()
        
        // id필드 내용 저장
        pwField.rx.text.orEmpty
            .bind(to: pwInputText)
            .disposed(by: disposeBag)
        
        // pw 필드 valid check
        pwInputText
            .map(checkPasswordValid)
            .bind(to: pwValid)
            .disposed(by: disposeBag)
    }
    private func bindOutput() {
        // output : red bullet button, login button
        idValid.subscribe(onNext: { b in self.idValidView.isHidden = b })
            .disposed(by: disposeBag)
        pwValid.subscribe(onNext: { b in self.pwValidView.isHidden = b })
            .disposed(by: disposeBag)
        Observable.combineLatest(idValid, pwValid, resultSelector: { $0 && $1 })
            .subscribe(onNext: { b in self.loginButton.isEnabled = b })
            .disposed(by: disposeBag)
    }

    // MARK: - Logic

    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }

    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
}
