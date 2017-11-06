
import UIKit

class RestartDialogVC: UIViewController {

    var difficulty = Difficulty.MEDIUM
    var playerGamePiece = GamePiece.BLACK
    
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
    
    @IBAction func restartGame(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let offlineGameVC = storyBoard.instantiateViewController(withIdentifier: "offlineGameVC") as! OfflineGameVC
        offlineGameVC.difficulty = difficulty
        offlineGameVC.playerGamePiece = playerGamePiece
        present(offlineGameVC, animated: true, completion: nil)
    }
    
}
