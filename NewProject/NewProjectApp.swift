//
//  NewProjectApp.swift
//  NewProject
//
//  Created by Reyhan Muhammad on 06/11/25.
//

import SwiftUI
import NavigationBackport

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - UIKit Wrapper (simulates UINavigationController embedding)

struct UIKitWrapperView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let viewController = HostingViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isHidden = true
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

// Separate view to manage the modal's navigation state
struct ModalNavigationView: View {
    @State private var path: [Int] = []
    
    var body: some View {
        NBNavigationStack(path: $path) {
            Text("Hello")
        }
    }
}


class HostingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        embedSwiftUIView()
    }
    
    func embedSwiftUIView() {
        let contentView = ContentView()
        let hostingController = UIHostingController(rootView: contentView)
        
        addChild(hostingController)
        hostingController.view.backgroundColor = .white
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - SwiftUI Views

struct ContentView: View {
    @State var path: NBNavigationPath = NBNavigationPath()
    
    var body: some View {
        NBNavigationStack(path: $path) {
            //            SplashScreen(path: $path)
            ScreenView(screen: Screen.first)
                .nbNavigationDestination(for: Screen.self) { screen in
                    ScreenView(screen: screen)
                }
        }
    }
}

struct SplashScreen: View {
    @Binding var path: NBNavigationPath
    
    var body: some View {
        VStack {
            Spacer()
            Text("0")
                .font(.largeTitle)
            Spacer()
            Button("Next") {
                path.push(Screen.first)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}

struct ScreenView: View {
    @EnvironmentObject var coordinator: PathNavigator
    var screen: Screen
    
    var body: some View {
        VStack {
            Spacer()
            Text(screen.number)
                .font(.largeTitle)
            Spacer()
            Button(screen.nextScreen != nil ? "Next" : "Pop to Root") {
                if let nextScreen = screen.nextScreen {
                    coordinator.push(nextScreen)
                } else {
                    // This triggers the fatal error:
                    // "Fatal error: No ObservableObject of type DestinationBuilderHolder found"
                    coordinator.popToRoot()
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}

// MARK: - Model

enum Screen: Hashable {
    case first
    case second
    case third
    case fourth
    case fifth
    
    var number: String {
        switch self {
        case .first: return "1"
        case .second: return "2"
        case .third: return "3"
        case .fourth: return "4"
        case .fifth: return "5"
        }
    }
    
    var nextScreen: Screen? {
        switch self {
        case .first: return .second
        case .second: return .third
        case .third: return nil
        case .fourth: return .fifth
        case .fifth: return nil
        }
    }
}
