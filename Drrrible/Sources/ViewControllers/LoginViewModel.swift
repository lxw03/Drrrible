//
//  LoginViewReactor.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 07/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift
import RxSwiftUtilities

protocol LoginViewReactorType {
  // Input
  var loginButtonDidTap: PublishSubject<Void> { get }

  // Output
  var loginButtonIsHidden: Driver<Bool> { get }
  var activityIndicatorViewIsAnimating: Driver<Bool> { get }
  var presentMainScreen: Observable<MainTabBarViewReactorType> { get }
}

final class LoginViewReactor: LoginViewReactorType {

  // MARK: Input

  let loginButtonDidTap: PublishSubject<Void> = .init()


  // MARK: Output

  let loginButtonIsHidden: Driver<Bool>
  let activityIndicatorViewIsAnimating: Driver<Bool>
  let presentMainScreen: Observable<MainTabBarViewReactorType>


  // MARK: Initializing

  init(provider: ServiceProviderType) {
    let isLoading = ActivityIndicator()

    self.loginButtonIsHidden = isLoading.asDriver()
    self.activityIndicatorViewIsAnimating = self.loginButtonIsHidden

    self.presentMainScreen = self.loginButtonDidTap
      .flatMap { provider.authService.authorize().trackActivity(isLoading) }
      .flatMap { provider.userService.fetchMe() }
      .map { MainTabBarViewReactor(provider: provider) }
  }

}
