


import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windoScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windoScene)
        window.makeKeyAndVisible()
        
        let viewController = AnimateTextViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        window.rootViewController = navigationController
        
        self.window = window
    }
}

