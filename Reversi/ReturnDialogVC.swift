
import UIKit

class ReturnDialogVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissDialog(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelDialog(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
