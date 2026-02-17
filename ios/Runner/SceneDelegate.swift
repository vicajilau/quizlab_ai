import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
    
    override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        super.scene(scene, willConnectTo: session, options: connectionOptions)
        
        if let urlContext = connectionOptions.urlContexts.first {
            handleOpenUrl(urlContext.url)
        }
    }
    
    override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let urlContext = URLContexts.first {
            handleOpenUrl(urlContext.url)
        }
    }
    
    private func handleOpenUrl(_ url: URL) {
        guard url.pathExtension == "quiz" else {
            print("File is not a QUIZ file, ignoring...")
            return
        }
        
        guard let controller = window?.rootViewController as? FlutterViewController else {
            return
        }
        
        let channel = FlutterMethodChannel(name: "quiz.file", binaryMessenger: controller.binaryMessenger)
        channel.invokeMethod("openFile", arguments: url.path) { result in
             if let error = result as? FlutterError {
                 print("Failed to open file: \(error.message ?? "Unknown error")")
             }
         }
    }
}
