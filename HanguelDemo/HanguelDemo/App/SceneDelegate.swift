


import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windoScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windoScene)
        window.makeKeyAndVisible()
        
        let tabBarController = UITabBarController()
        
        let animateVC = AnimateTextViewController()
        animateVC.tabBarItem = UITabBarItem(title: "View", image: UIImage.actions, tag: 0)
        let nav = UINavigationController(rootViewController: animateVC)
        
        let animateDrawingVC = AnimateDrawingController()
        animateDrawingVC.tabBarItem = UITabBarItem(title: "Draw", image: UIImage.add, tag: 1)
        let nav2 = UINavigationController(rootViewController: animateDrawingVC)
        
        tabBarController.setViewControllers([nav, nav2], animated: true)
        
        window.rootViewController = tabBarController
        
        self.window = window
    }
}

