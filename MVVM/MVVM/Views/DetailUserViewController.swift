//
//  DetailUserViewController.swift
//  MVVM
//
//  Created by Seok Young Jung on 2023/03/30.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailUserViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!

    var detaileUserViewModel: DetailUserViewModel
    private var disposBag = DisposeBag()
    
    init?(viewModel: DetailUserViewModel = DetailUserViewModel(), coder: NSCoder) {
        self.detaileUserViewModel = viewModel
        
        super.init(coder: coder)
        viewWillAppearBind()
    }

    required init?(coder: NSCoder) {
        self.detaileUserViewModel = DetailUserViewModel()
        super.init(coder: coder)
        viewWillAppearBind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

extension DetailUserViewController {
    
    private func viewWillAppearBind() {
        
        self.rx.viewWillAppear
            .subscribe(onNext: { [weak self] _ in
                self?.detaileUserViewModel.input.viewWillAppear()
            })
            .disposed(by: disposBag)
    }

    
    private func bind() {
        detaileUserViewModel.output.username
            .drive(usernameLabel.rx.text)
            .disposed(by: disposBag)
        
        detaileUserViewModel.output.email
            .drive(emailLabel.rx.text)
            .disposed(by: disposBag)
        
        detaileUserViewModel.output.address
            .drive(addressLabel.rx.text)
            .disposed(by: disposBag)
        
        detaileUserViewModel.output.website
            .drive(websiteLabel.rx.text)
            .disposed(by: disposBag)
        
        detaileUserViewModel.output.phoneNumber
            .drive(phoneLabel.rx.text)
            .disposed(by: disposBag)
        
        detaileUserViewModel.output.errorMessage
            .map {"\($0)"}
            .drive(onNext: (createAlert))
            .disposed(by: disposBag)
    }
}
