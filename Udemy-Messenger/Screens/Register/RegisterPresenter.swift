//
//  RegisterPresenter.swift
//  Udemy-Messenger
//
//  Created by The Ngoc on 2022/07/04.
//

import Foundation

class RegisterPresenter: RegisterContract.Presenter {
    
    weak private var view: RegisterContract.View?
    private var model: RegisterContract.Model
    
    required init(_ model: RegisterContract.Model) {
        self.model = model
    }
    
    func attachView(_ view: RegisterContract.View) {
        self.view = view
    }
    
    func detach() {
        self.view = nil
    }
    
    func validateFields(email: String, name: String, password: String) {
        let message = model.validateFields(email: email, name: name, password: password)
        
        // Validate success
        if message.isEmpty {
            model.checkForExistingEmail(email, completion: { [weak self] errorMessage in
                guard let self = self else {
                    return
                }
                
                if errorMessage.isEmpty {
                    self.model.registerUser(name, email: email, password: password) { errorMessage in
                        if errorMessage.isEmpty {
                            self.view?.showAlert()
                        } else {
                            self.view?.showNotice(withMessage: errorMessage)
                        }
                    }
                } else {
                    self.view?.showNotice(withMessage: errorMessage)
                }
            })
        } else {
            view?.showNotice(withMessage: message)
        }
    }
}
