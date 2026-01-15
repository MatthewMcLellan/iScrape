import SwiftUI
import UIKit

/// A SwiftUI wrapper to preview a storyboard-based UIViewController in the canvas.
struct StoryboardViewControllerPreview: UIViewControllerRepresentable {
    let storyboardName: String
    let viewControllerIdentifier: String?

    init(_ storyboardName: String, identifier: String? = nil) {
        self.storyboardName = storyboardName
        self.viewControllerIdentifier = identifier
    }

    func makeUIViewController(context: Context) -> UIViewController {
        // Attempt to load the storyboard and instantiate the requested view controller.
        // If anything fails, return a friendly placeholder so previews still render.
        let storyboard: UIStoryboard
        if Bundle.main.path(forResource: storyboardName, ofType: "storyboardc") != nil {
            storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        } else if Bundle.main.path(forResource: storyboardName, ofType: "storyboard") != nil {
            storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        } else {
            return placeholder(message: "Storyboard '\(storyboardName)' not found.")
        }

        if let id = viewControllerIdentifier {
            let vc = storyboard.instantiateViewController(withIdentifier: id)
            return vc
        } else if let vc = storyboard.instantiateInitialViewController() {
            return vc
        } else {
            return placeholder(message: "No initial view controller in '\(storyboardName)'.")
        }
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No-op
    }

    private func placeholder(message: String) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.systemBackground

        let label = UILabel()
        label.text = message
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        vc.view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: vc.view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(lessThanOrEqualTo: vc.view.trailingAnchor, constant: -20)
        ])

        return vc
    }
}

#Preview("Storyboard: Main (Initial)") {
    StoryboardViewControllerPreview("Main")
}

#Preview("Storyboard: Main - DetailNavController") {
    StoryboardViewControllerPreview("Main", identifier: "DetailNavController")
}
