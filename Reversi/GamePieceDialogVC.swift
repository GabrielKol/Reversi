
import UIKit

class GamePieceDialogVC: UIViewController {

    var difficulty = Difficulty.MEDIUM
    
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
    
    @IBAction func chooseBlackPiece(_ sender: UITapGestureRecognizer) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let offlineGameVC = storyBoard.instantiateViewController(withIdentifier: "offlineGameVC") as! OfflineGameVC
        offlineGameVC.difficulty = difficulty
        offlineGameVC.playerGamePiece = GamePiece.BLACK
        present(offlineGameVC, animated: true, completion: nil)
        
    }
    
    @IBAction func chooseWhitePiece(_ sender: UITapGestureRecognizer) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let offlineGameVC = storyBoard.instantiateViewController(withIdentifier: "offlineGameVC") as! OfflineGameVC
        offlineGameVC.difficulty = difficulty
        offlineGameVC.playerGamePiece = GamePiece.WHITE
        present(offlineGameVC, animated: true, completion: nil)
    }
    
}
