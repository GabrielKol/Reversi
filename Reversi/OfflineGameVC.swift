

import UIKit
import AVFoundation

class OfflineGameVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var opponentCounterView: AwesomeView!
    @IBOutlet weak var opponentCounterLabel: UILabel!
    @IBOutlet weak var playerCounterView: AwesomeView!
    @IBOutlet weak var playerCounterLabel: UILabel!
    
    var victorySound: AVAudioPlayer?
    var shakeSound: AVAudioPlayer?
    var putPieceSound: AVAudioPlayer?
    var popSound: AVAudioPlayer?
    var flipPieceSound: AVAudioPlayer?
    var defeatSound: AVAudioPlayer?
    
    let whiteToBlackImages: [UIImage] = [UIImage(named: "piece_white_to_black1")!, UIImage(named: "piece_white_to_black2")!, UIImage(named: "piece_white_to_black3")!, UIImage(named: "piece_white_to_black4")!, UIImage(named: "piece_white_to_black5")!, UIImage(named: "piece_white_to_black6")!, UIImage(named: "piece_white_to_black7")!, UIImage(named: "piece_black")!]
    
    let blackToWhiteImages: [UIImage] = [UIImage(named: "piece_white_to_black7")!, UIImage(named: "piece_white_to_black6")!, UIImage(named: "piece_white_to_black5")!, UIImage(named: "piece_white_to_black4")!, UIImage(named: "piece_white_to_black3")!, UIImage(named: "piece_white_to_black2")!, UIImage(named: "piece_white_to_black1")!, UIImage(named: "piece_white")!]
    
    var game = Game()
    var playerGamePiece = GamePiece.BLACK
    var difficulty = Difficulty.MEDIUM
    var isAllowedToPlay = false
    var playableTiles: Array<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        game = Game()
        
        if(playerGamePiece == GamePiece.BLACK) {
            playerCounterView.backgroundColor = UIColor(colorLiteralRed:0.0, green:0.0, blue:0.0, alpha:1.0)
            opponentCounterView.backgroundColor = UIColor(colorLiteralRed:1.0, green:1.0, blue:1.0, alpha:1.0)
            playerCounterLabel.textColor = UIColor(colorLiteralRed:1.0, green:1.0, blue:1.0, alpha:1.0)
            isAllowedToPlay = true
            playableTiles = game.getBoard().getPlayableTiles(gamePiece: GamePiece.BLACK)!
        }
        else {
            playerCounterView.backgroundColor = UIColor(colorLiteralRed:1.0, green:1.0, blue:1.0, alpha:1.0)
            opponentCounterView.backgroundColor = UIColor(colorLiteralRed:0.0, green:0.0, blue:0.0, alpha:1.0)
            opponentCounterLabel.textColor = UIColor(colorLiteralRed:1.0, green:1.0, blue:1.0, alpha:1.0)
            isAllowedToPlay = false
            playableTiles = []
            let when = DispatchTime.now() + 0.2
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.makeAIMove()
            }
        }
        
        // initialize the sound
        victorySound = setupAudioPlayer(withFile: "victory_sound", type: "mp3")
        shakeSound = setupAudioPlayer(withFile: "shake_sound", type: "wav")
        putPieceSound = setupAudioPlayer(withFile: "put_piece_sound", type: "mp3")
        popSound = setupAudioPlayer(withFile: "pop_sound", type: "mp3")
        flipPieceSound = setupAudioPlayer(withFile: "flip_piece_sound", type: "wav")
        defeatSound = setupAudioPlayer(withFile: "defeat_sound", type: "mp3")
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Board.getNumberOfCols()*Board.getNumberOfCols()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath as IndexPath) as! CollectionViewCell
        
        cell.backgroundColor = UIColor(colorLiteralRed:0.216, green:0.8, blue:0.361, alpha:1.0)
        
        // Settin images and sprites:
        
        if(getTile(position: indexPath.row).getOccupyingGamePiece() == nil) {
            cell.imageView.image = UIImage(named: "piece_none")
        }
        else if (getTile(position: indexPath.row).getOccupyingGamePiece() == GamePiece.BLACK){
            if(!getTile(position: indexPath.row).isRecentlyFlipped()) {
                cell.imageView.image = UIImage(named: "piece_black")
            }
            else {
                cell.imageView.image = UIImage(named: "piece_black")
                cell.imageView.animationImages = whiteToBlackImages
                cell.imageView.animationDuration = 0.4
                cell.imageView.animationRepeatCount = 1
                cell.imageView.startAnimating()
            }
        }
        else {
            if(!getTile(position: indexPath.row).isRecentlyFlipped()) {
                cell.imageView.image = UIImage(named: "piece_white")
            }
            else{
                cell.imageView.image = UIImage(named: "piece_white")
                cell.imageView.animationImages = blackToWhiteImages
                cell.imageView.animationDuration = 0.4
                cell.imageView.animationRepeatCount = 1
                cell.imageView.startAnimating()
            }
            
        }
        
        // Setting guidline animation:
        
        if (playableTiles.contains(indexPath.row)){
            let greenColor = UIColor(colorLiteralRed:0.297, green:0.964, blue:0.462, alpha:1.0)
            
            UIView.animate(withDuration: 0.4, delay: 0.0, options:[.allowUserInteraction, .curveEaseOut, .repeat, .autoreverse], animations: {
                cell.backgroundColor = greenColor
            }, completion:nil)
        }
        
        
        return cell
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Making sure the game hasn't ended and that its a proper timing to let the player make his turn.
        if (game.getGameStatus() == Game.GameStatus.ONGOING && isAllowedToPlay) {
            
            // If this tile is playable:
            if (playableTiles.contains(indexPath.row)){
                
                isAllowedToPlay = false // Disabling the player to play for now.
                
                // Cancel guidlines
                playableTiles = []
                game.getBoard().refreshTiles()
                collectionView.reloadData()
                
                // Making the play and updating collectionView:
                game.playTile(positionI: indexPath.row / Board.getNumberOfCols(), positionJ: indexPath.row % Board.getNumberOfCols())
                collectionView.reloadData()
                
                putPieceSound?.play() // Playing proper sound.
                
                updateCounters() // Updating counters.
                
                let when1 = DispatchTime.now() + 0.2
                DispatchQueue.main.asyncAfter(deadline: when1) {
                    
                    self.flipPieceSound?.play() // Playing proper sound.
                    
                    let when2 = DispatchTime.now() + 0.5
                    DispatchQueue.main.asyncAfter(deadline: when2) {
                        
                        // If game is still ongoing:
                        if(self.game.getGameStatus() == Game.GameStatus.ONGOING){
                            
                            // If turn was toggled:
                            if(self.game.getCurrentlyPlaying() != self.playerGamePiece) {
                                
                                // Now A.I. opponent should make a move:
                                self.makeAIMove();
                                
                            }
                                
                                // Otherwise, player gets another turn:
                            else {
                                self.playableTiles = self.game.getBoard().getPlayableTiles(gamePiece: self.playerGamePiece)!
                                self.game.getBoard().refreshTiles()
                                self.collectionView.reloadData()
                                self.isAllowedToPlay = true
                            }
                            
                        }
                            
                        else{ // Otherwise, game has ended.
                            self.handleGameEnding()
                        }
                        
                    }
                    
                }
                
            }
        }
        
    }
    
    func makeAIMove() {
        
        // Getting A.I.'s game peace type:
        let opponentPiece = game.getCurrentlyPlaying()
        
        // Making the play:
        game.makeAIMove(difficulty: difficulty)
        
        // Updating the collectionView:
        collectionView.reloadData()
        
        putPieceSound?.play() // Playing proper sound.
        
        updateCounters() // Updating counters.
        
        let when1 = DispatchTime.now() + 0.2
        DispatchQueue.main.asyncAfter(deadline: when1) {
            
            self.flipPieceSound?.play() // Playing proper sound.
            
            let when = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: when) {
                
                // If game is still ongoing:
                if(self.game.getGameStatus() == Game.GameStatus.ONGOING){
                    
                    // If turn was toggled:
                    if(self.game.getCurrentlyPlaying() != opponentPiece) {
                        
                        // Update playableTiles:
                        self.playableTiles = self.game.getBoard().getPlayableTiles(gamePiece: self.playerGamePiece)!
                        
                        // Now Player should make a move:
                        self.game.getBoard().refreshTiles()
                        self.collectionView.reloadData()
                        self.isAllowedToPlay = true
                        
                    }
                        
                        // Otherwise, opponent gets another turn:
                    else {
                        self.makeAIMove()
                    }
                    
                }
                    
                else { // Otherwise (game has ended)
                    self.handleGameEnding()
                }
                
            }
            
        }

    }
    
    func updateCounters() {
        if(playerGamePiece == GamePiece.BLACK) {
            playerCounterLabel.text = String(game.getBoard().getNumberOfBlackPieces())
            opponentCounterLabel.text = String(game.getBoard().getNumberOfWhitePieces())
        }
        else {
            playerCounterLabel.text = String(game.getBoard().getNumberOfWhitePieces())
            opponentCounterLabel.text = String(game.getBoard().getNumberOfBlackPieces())
        }
    }
    
    @IBAction func showRestartDialog(_ sender: UITapGestureRecognizer) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let restartDialogVC = storyBoard.instantiateViewController(withIdentifier: "restartDialogVC") as! RestartDialogVC
        restartDialogVC.difficulty = difficulty
        restartDialogVC.playerGamePiece = playerGamePiece
        restartDialogVC.modalPresentationStyle = .overCurrentContext
        restartDialogVC.modalTransitionStyle = .crossDissolve
        present(restartDialogVC, animated: true, completion: nil)
        
    }
    
    
    func handleGameEnding() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let conclusionVC = storyBoard.instantiateViewController(withIdentifier: "conclusionVC") as! ConclusionVC
        
        // If draw:
        if(game.getGameStatus() == Game.GameStatus.DRAW) {
            conclusionVC.conclusionText = "DRAW"
            victorySound?.play()
        }
        // If player won:
        else if((game.getGameStatus() == Game.GameStatus.PLAYER_BLACK_WON && playerGamePiece == GamePiece.BLACK) || (game.getGameStatus() == Game.GameStatus.PLAYER_WHITE_WON && playerGamePiece == GamePiece.WHITE)) {
            conclusionVC.conclusionText = "VICTORY"
            victorySound?.play()
        }
        // If player lost:
        else {
            conclusionVC.conclusionText = "DEFEAT"
            defeatSound?.play()
        }
        
        conclusionVC.difficulty = difficulty
        conclusionVC.playerGamePiece = playerGamePiece
        
        conclusionVC.modalPresentationStyle = .overCurrentContext
        conclusionVC.modalTransitionStyle = .crossDissolve
        present(conclusionVC, animated: true, completion: nil)
        
    }
    
    func getTile(position: Int) -> Tile {
        let posI: Int = position / Board.getNumberOfCols()
        let posJ: Int = position % Board.getNumberOfCols()
        return game.getBoard().getTile(positionI: posI, positionJ: posJ)
    }

    
    func setupAudioPlayer(withFile file: String, type: String) -> AVAudioPlayer? {
        let path = Bundle.main.path(forResource: file, ofType: type)
        let url = NSURL.fileURL(withPath: path!)
        return try? AVAudioPlayer(contentsOf: url)
    }
    
    
    
    
    
    
    
    
    
    
    
    


}
