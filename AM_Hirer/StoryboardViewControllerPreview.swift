import SwiftUI
import UIKit

/// A SwiftUI view that previews a UIViewController instantiated from a storyboard.
/// Usage:
/// - StoryboardViewControllerPreview("Main") // previews initial view controller
/// - StoryboardViewControllerPreview("Main", identifier: "MapViewController") // previews a specific VC by storyboard identifier
struct StoryboardViewControllerPreview: UIViewControllerRepresentable {
    private let storyboardName: String
    private let identifier: String?

    init(_ storyboardName: String, identifier: String? = nil) {
        self.storyboardName = storyboardName
        self.identifier = identifier
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        if let id = identifier, !id.isEmpty {
            return storyboard.instantiateViewController(withIdentifier: id)
        } else if let initial = storyboard.instantiateInitialViewController() {
            return initial
        } else {
            // Fallback placeholder if storyboard or identifier is misconfigured.
            let vc = UIViewController()
            vc.view.backgroundColor = .systemBackground
            let label = UILabel()
            label.text = "Storyboard ‘\(storyboardName)’ preview placeholder\n(Set initial VC or provide identifier)"
            label.textAlignment = .center
            label.textColor = .secondaryLabel
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            vc.view.addSubview(label)
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor),
                label.leadingAnchor.constraint(greaterThanOrEqualTo: vc.view.leadingAnchor, constant: 16),
                label.trailingAnchor.constraint(lessThanOrEqualTo: vc.view.trailingAnchor, constant: -16)
            ])
            return vc
        }
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No-op; previews do not need live updates by default.
    }
}
