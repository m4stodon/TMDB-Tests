//
//  AppSession.swift
//  MovieDB
//
//  Created by Ermac on 9/11/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import Foundation
import Combine
import SwiftMessages

class AppSession {
    
    //    "Создать приложение для просмотра списка популярных фильмов используя следующее API developers.themoviedb.org...
    //    Задача:
    //    - Использовать: язык SWIFT, архитектуру (MVP)
    //    - Организовать отображение списка популярных фильмов developers.themoviedb.org...
    //    - При отсутствии интернета отображать сообщение ""Нет соединения"", а при появлении сети обновлять данные автоматически. Для мониторинга состояния сети использовать свою реализацию
    //    - сделать детальный экран проигрывания видео
    //    - сделать списак Фейворит фильмов использовать CoreData
    //    Будет плюсом:
    //    - Чистота и структурированность кода;
    //    - Поддержка Auto-rotation – портретная и ландшафтная ориентация;
    //    - Пагинация списка фильмов"
    
    
    static private(set) var current: AppSession!
    
    let storage = Storage()
    let router: AppRouter
    let tmdbNetwork = TMDBNetwork()
    
    private var cancellables = [AnyCancellable]()
    
    init(router: AppRouter) {
        self.router = router
        
        AppSession.current = self
        
        self.router.open(initial: .feed)
        
        cancellables.append(
            tmdbNetwork.isReachable.sink(receiveCompletion: { _ in }) { [weak self] isReachable in
                isReachable ? self?.hideNoNetwork() : self?.showNoNetwork()
            }
        )
    }
}

// MARK: - Private
private extension AppSession {
    func showNoNetwork() {
        let view = MessageView.viewFromNib(layout: .statusLine)
        view.configureTheme(.warning)
        view.configureContent(body: "No internet connection...")
        
        var config = SwiftMessages.Config()
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: .normal)
        config.interactiveHide = true
        config.prefersStatusBarHidden = true
        config.duration = SwiftMessages.Duration.forever
        
        SwiftMessages.show(config: config, view: view)
    }
    
    func hideNoNetwork() {
        SwiftMessages.hideAll()
    }
}
