//
//  ViewController.swift
//  AuthScreen
//
//  Created by Михаил on 27.08.2018.
//  Copyright © 2018 Михаил. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

class ViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let headLabel = UILabel()
    let headSep = UIView()
    let emailLabel = UILabel()
    let emailTextField = UITextField()
    let emailSep = UIView()
    let passLabel = UILabel()
    let passTextField = UITextField()
    let passButton = UIButton()
    let passSep = UIView()
    let loginButton = UIButton()
    let createAccButton = UIButton()
    var mark1 = false
    var mark2 = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(scrollView: scrollView)
        configure(headLabel: headLabel)
        configure(headSep : headSep)
        configure(emailLabel: emailLabel)
        configure(emailTextField: emailTextField)
        configure(emailSep: emailSep)
        configure(passLabel: passLabel)
        configure(passTextField: passTextField)
        configure(passSep: passSep)
        configure(passButton: passButton)
        configure(loginButton: loginButton)
        configure(createAccButton: createAccButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        emailTextField.rx.text
            .orEmpty
            .throttle(3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .asObservable()
            .subscribe(onNext: {
                let regex = try? NSRegularExpression.init(pattern: "^((([0-9A-Za-z]{1}[-0-9A-z\\.]{1,}[0-9A-Za-z]{1})|([0-9А-Яа-я]{1}[-0-9А-я\\.]{1,}[0-9А-Яа-я]{1}))@([-A-Za-z]{1,}\\.){1,2}[-A-Za-z]{2,})$")
                if self.matches(for: regex!, in: $0)
                {
                    self.mark1 = true
                    print("Email correct")
                }
                else
                {
                    self.mark1 = false
                }
            })
        
        passTextField.rx.text
            .orEmpty
            .throttle(3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .asObservable()
            .subscribe(onNext: {
                let regex = try? NSRegularExpression.init(pattern: "(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z]{6,}")
                if self.matches(for: regex!, in: $0)
                {
                    self.mark2 = true
                    print("Password correct")
                }
                else
                {
                    self.mark2 = false
                }
            })

    
    }
    
    func matches(for regex: NSRegularExpression, in text: String) -> Bool {
        let results = regex.matches(in: text,
                                    range: NSRange(text.startIndex..., in: text))
        if results.count > 0 {
            return true
        }  else
        {
            return false
        }
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height - 65 - scrollView.contentInset.bottom)
    }
    
    private func configure(scrollView: UIScrollView) {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func configure (headLabel : UILabel) {
        headLabel.translatesAutoresizingMaskIntoConstraints = false
        headLabel.text = "Авторизация"
        headLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        view.addSubview(headLabel)
        
        headLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 33).isActive = true
        headLabel.widthAnchor.constraint(equalToConstant: 108).isActive = true
        headLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func configure (headSep : UIView) {
        headSep.translatesAutoresizingMaskIntoConstraints = false
        headSep.backgroundColor = UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1.0)
        view.addSubview(headSep)
        
        headSep.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
        headSep.heightAnchor.constraint(equalToConstant: 1).isActive = true
        headSep.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headSep.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
   
    func configure (emailLabel : UILabel) {
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.text = "Почта"
        emailLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        emailLabel.textColor = UIColor(red: 121/255, green: 121/255, blue: 121/255, alpha: 1.0)
        scrollView.addSubview(emailLabel)
        
        emailLabel.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: -110).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 15).isActive = true
    }
    
    func configure (emailTextField : UITextField) {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = "Введите адрес почты"
        emailTextField.autocorrectionType = .no
        emailTextField.returnKeyType = .next
        emailTextField.keyboardType = .emailAddress
        emailTextField.addTarget(self, action: #selector(endEditing(sender:)), for: .editingDidEndOnExit)
        
        emailTextField.tag = 0
        scrollView.addSubview(emailTextField)
        
        emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: 244).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 15).isActive = true
    }
    
    func configure (emailSep : UIView) {
        emailSep.translatesAutoresizingMaskIntoConstraints = false
        emailSep.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
        scrollView.addSubview(emailSep)
        
        emailSep.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 4).isActive = true
        emailSep.heightAnchor.constraint(equalToConstant: 1).isActive = true
        emailSep.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 15).isActive = true
        emailSep.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -30).isActive = true
    }
    
    func configure (passLabel : UILabel) {
        passLabel.translatesAutoresizingMaskIntoConstraints = false
        passLabel.text = "Пароль"
        passLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        passLabel.textColor = UIColor(red: 121/255, green: 121/255, blue: 121/255, alpha: 1.0)
        scrollView.addSubview(passLabel)
        
        passLabel.topAnchor.constraint(equalTo: emailSep.bottomAnchor, constant: 12).isActive = true
        passLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        passLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 15).isActive = true
    }
    
    func configure (passTextField : UITextField) {
        passTextField.translatesAutoresizingMaskIntoConstraints = false
        passTextField.placeholder = "Введите пароль"
        passTextField.autocorrectionType = .no
        passTextField.returnKeyType = .done
        passTextField.addTarget(self, action: #selector(endEditing(sender:)), for: .editingDidEndOnExit)
        scrollView.addSubview(passTextField)
        
        passTextField.topAnchor.constraint(equalTo: passLabel.bottomAnchor, constant: 5).isActive = true
        passTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        passTextField.widthAnchor.constraint(equalToConstant: 130).isActive = true
        passTextField.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 15).isActive = true
    }
    
    func configure (passButton : UIButton) {
        passButton.translatesAutoresizingMaskIntoConstraints = false
        
        passButton.setTitle("Забыли пароль?", for: .normal)
        passButton.layer.borderWidth = 1
        passButton.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0).cgColor
        passButton.layer.cornerRadius = 4
        passButton.setTitleColor(UIColor(red: 121/255, green: 121/255, blue: 121/255, alpha: 1.0), for: .normal)
        passButton.titleLabel?.font = UIFont.systemFont(ofSize: 10.0, weight: .regular)
        scrollView.addSubview(passButton)
        
        passButton.bottomAnchor.constraint(equalTo: passSep.topAnchor, constant: -8).isActive = true
        passButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        passButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        passButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        
    }
    
    func configure (passSep : UIView) {
        passSep.translatesAutoresizingMaskIntoConstraints = false
        passSep.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
        scrollView.addSubview(passSep)
        
        passSep.topAnchor.constraint(equalTo: passTextField.bottomAnchor, constant: 4).isActive = true
        passSep.heightAnchor.constraint(equalToConstant: 1).isActive = true
        passSep.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 15).isActive = true
        passSep.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -30).isActive = true
    }
    
    func configure (loginButton : UIButton) {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.backgroundColor = UIColor(red: 1, green: 155/255, blue: 0, alpha: 1.0)
        loginButton.setTitle("Войти", for: .normal)
        loginButton.layer.cornerRadius = 23
        loginButton.addTarget(self, action: #selector(self.loginAction(sender:)), for: .touchUpInside)
        scrollView.addSubview(loginButton)
        
        loginButton.topAnchor.constraint(equalTo: passSep.bottomAnchor, constant: 34).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 147).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    }
    
    func configure (createAccButton : UIButton) {
        createAccButton.translatesAutoresizingMaskIntoConstraints = false
        createAccButton.setTitle("У меня еще нет аккаунта. Создать.", for: .normal)
        createAccButton.setTitleColor(UIColor(red: 56/255, green: 133/255, blue: 199/255, alpha: 1.0), for: .normal)
        passButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        scrollView.addSubview(createAccButton)
        
        createAccButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 21).isActive = true
        createAccButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        createAccButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        createAccButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrameValue = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else { return }
        let keyboardFrame = view.convert(keyboardFrameValue.cgRectValue, from: nil)
        scrollView.contentInset.bottom = keyboardFrame.size.height + (view.frame.height / 2) - 128
        view.setNeedsLayout()
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func endEditing(sender: UITextField) {
        if sender.tag == 0 {
            passTextField.becomeFirstResponder()
            scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height - 65 - scrollView.contentInset.bottom)
        }
    }
    
    @objc
    func loginAction(sender : UIButton) {
        if (!mark1 || !mark2) {
            let alert = UIAlertController(title: "Error", message: "Логин/пароль введены некорректно", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let provider = MoyaProvider<MoyaExampleService>()
            provider.request(.getWeather()) { result in
                switch result {
                case .success(let response):
                    if let parseResponse = try? JSONDecoder().decode(ResponseModel.self, from: response.data) {
                        let alert = UIAlertController(title: "Weather Saransk", message: parseResponse.list[0].dt_txt + " " + (String)(parseResponse.list[0].main.temp) + "C", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                case .failure(let error):
                print(error.errorDescription ?? "Unknown error")
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

