/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The detail view controller used for displaying the Golden Gate Bridge either in a popover for iPad,
 or in a modal view controller for iPhone.
*/

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = imageView.image {
            preferredContentSize = image.size
        }
    }
    
    @IBAction private func doneAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
import SwiftUI

private func instantiateViewController<T: UIViewController>(storyboardName: String, identifier: String, as type: T.Type) -> T {
    let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
    // Try to instantiate by identifier; if it fails, fall back to initial VC or a new instance
    if let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? T {
        return vc
    }
    if let vc = storyboard.instantiateInitialViewController() as? T {
        return vc
    }
    return T(nibName: nil, bundle: nil)
}

#Preview("Main storyboard – DetailNavController") {
    // Previews the navigation controller scene that wraps the detail screen.
    let nav: UINavigationController = instantiateViewController(storyboardName: "Main", identifier: "DetailNavController", as: UINavigationController.self)
    return nav
}

#Preview("Main storyboard – DetailViewController") {
    // Previews the detail view controller scene directly by its storyboard identifier.
    let detail: DetailViewController = instantiateViewController(storyboardName: "Main", identifier: "DetailViewController", as: DetailViewController.self)
    return detail
}

