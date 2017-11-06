
import UIKit

class DifficultyDialogVC: UIViewController {

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
    
    @IBAction func chooseBeginner(_ sender: UITapGestureRecognizer) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let gamePieceDialogVC = storyBoard.instantiateViewController(withIdentifier: "gamePieceDialogVC") as! GamePieceDialogVC
        gamePieceDialogVC.difficulty = Difficulty.BEGINNER
        gamePieceDialogVC.modalPresentationStyle = .overCurrentContext
        gamePieceDialogVC.modalTransitionStyle = .crossDissolve
        present(gamePieceDialogVC, animated: true, completion: nil)
    }
    
    @IBAction func chooseEasy(_ sender: UITapGestureRecognizer) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let gamePieceDialogVC = storyBoard.instantiateViewController(withIdentifier: "gamePieceDialogVC") as! GamePieceDialogVC
        gamePieceDialogVC.difficulty = Difficulty.EASY
        gamePieceDialogVC.modalPresentationStyle = .overCurrentContext
        gamePieceDialogVC.modalTransitionStyle = .crossDissolve
        present(gamePieceDialogVC, animated: true, completion: nil)
    }
    
    @IBAction func chooseMedium(_ sender: UITapGestureRecognizer) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let gamePieceDialogVC = storyBoard.instantiateViewController(withIdentifier: "gamePieceDialogVC") as! GamePieceDialogVC
        gamePieceDialogVC.difficulty = Difficulty.MEDIUM
        gamePieceDialogVC.modalPresentationStyle = .overCurrentContext
        gamePieceDialogVC.modalTransitionStyle = .crossDissolve
        present(gamePieceDialogVC, animated: true, completion: nil)
    }
    
    @IBAction func chooseHard(_ sender: UITapGestureRecognizer) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let gamePieceDialogVC = storyBoard.instantiateViewController(withIdentifier: "gamePieceDialogVC") as! GamePieceDialogVC
        gamePieceDialogVC.difficulty = Difficulty.HARD
        gamePieceDialogVC.modalPresentationStyle = .overCurrentContext
        gamePieceDialogVC.modalTransitionStyle = .crossDissolve
        present(gamePieceDialogVC, animated: true, completion: nil)
    }
    
    @IBAction func chooseExpert(_ sender: UITapGestureRecognizer) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let gamePieceDialogVC = storyBoard.instantiateViewController(withIdentifier: "gamePieceDialogVC") as! GamePieceDialogVC
        gamePieceDialogVC.difficulty = Difficulty.EXPERT
        gamePieceDialogVC.modalPresentationStyle = .overCurrentContext
        gamePieceDialogVC.modalTransitionStyle = .crossDissolve
        present(gamePieceDialogVC, animated: true, completion: nil)
    }
    
}
