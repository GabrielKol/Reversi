
import UIKit

class ConclusionVC: UIViewController {

    var difficulty = Difficulty.MEDIUM
    var playerGamePiece = GamePiece.BLACK
    var conclusionText = ""
    @IBOutlet weak var conclusionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        conclusionLabel.text = conclusionText
        
        if(conclusionText == "DRAW") {
            conclusionLabel.textColor = UIColor(colorLiteralRed:0.216, green:0.8, blue:0.361, alpha:1.0)
        }
        if(conclusionText == "VICTORY") {
            conclusionLabel.textColor = UIColor(colorLiteralRed:0.184, green:0.255, blue:0.655, alpha:1.0)
        }
        if(conclusionText == "DEFEAT") {
            conclusionLabel.textColor = UIColor(colorLiteralRed:0.757, green:0.137, blue:0.169, alpha:1.0)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func playAgain(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let offlineGameVC = storyBoard.instantiateViewController(withIdentifier: "offlineGameVC") as! OfflineGameVC
        offlineGameVC.difficulty = difficulty
        offlineGameVC.playerGamePiece = playerGamePiece
        present(offlineGameVC, animated: true, completion: nil)
    }
    
}
