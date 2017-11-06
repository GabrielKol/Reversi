
import Foundation

class Game {
    
    
    private var board: Board = Board()
    private var currentlyPlaying: GamePiece = GamePiece.BLACK // PLayer with black pieces starts the game.
    private var gameStatus: GameStatus = GameStatus.ONGOING
    
    
    // Risk Zones from best to riskiest spots to play (for A.I. to make better moves):
    
    private static let RISK_ZONE0: [Int] = [0,7,56,63] // Corners.
    private static let RISK_ZONE1: [Int] = [2,3,4,5,16,23,24,31,32,39,40,47,58,59,60,61] // Margins (not including corners and spots around corners).
    private static let RISK_ZONE2: [Int] = [18,19,20,21,26,27,28,29,34,35,36,37,42,43,44,45] // Central area of the board.
    private static let RISK_ZONE3: [Int] = [10,11,12,13,17,22,25,30,33,38,41,46,50,51,52,53] // Near margins (not including spots around corners).
    private static let RISK_ZONE4: [Int] = [1,6,8,15,48,55,57,62] // Adjacent to Corners (but not diagonal).
    private static let RISK_ZONE5: [Int] = [9,14,49,54] // Adjacent and Diagonal to Corners.
    private static let RISK_ZONE6: [Int] = [1,6,8,9,14,15,48,49,54,55,57,62] // Around Corners (zones4+5).
    
    private static let INFINITY: Int = 1000000
    
    
    public enum GameStatus: String {
        
        case ONGOING = "Ongoing"
        case PLAYER_BLACK_WON = "Player Black Won"
        case PLAYER_WHITE_WON = "Player White Won"
        case DRAW = "Draw"
        
    }
    
    
    public func playTile(positionI: Int, positionJ: Int) {
        
        // Checking if the tile is already occupied:
        if(board.getTile(positionI: positionI, positionJ: positionJ).getOccupyingGamePiece() != nil){
            return
        }
        
        // Adding a piece of game to the board:
        board.addGamePiece(positionI: positionI, positionJ: positionJ, gamePiece: currentlyPlaying)
        
        if(board.getNumberOfEmptyTiles() == 0) {
            endGame()
        }
        else{
            
            // Determining opponent's game piece:
            var opponentPiece: GamePiece
            if (currentlyPlaying == GamePiece.BLACK) { opponentPiece = GamePiece.WHITE }
            else { opponentPiece = GamePiece.BLACK }
            
            // Checking If opponent can play:
            if(!board.getPlayableTiles(gamePiece: opponentPiece)!.isEmpty) {
                toggleTurn()
            }
                
                // Otherwise, if both players can't play
            else if(board.getPlayableTiles(gamePiece: currentlyPlaying)!.isEmpty) {
                endGame()
            }
            
            // Otherwise, the same player will simply get another turn. :p
            
        }
    
    
    }
    
    
    
    private func toggleTurn() {
    
        if(currentlyPlaying == GamePiece.BLACK) {
            currentlyPlaying = GamePiece.WHITE
        }
        else {
            currentlyPlaying = GamePiece.BLACK
        }
    
    }
    
    
    
    private func endGame() {
    
        if(board.getNumberOfBlackPieces() > board.getNumberOfWhitePieces()) {
            gameStatus = GameStatus.PLAYER_BLACK_WON
        }
        else if(board.getNumberOfBlackPieces() < board.getNumberOfWhitePieces()){
            gameStatus = GameStatus.PLAYER_WHITE_WON
        }
        else {
            gameStatus = GameStatus.DRAW
        }
    
    }
    
    
    
    
    // Getters:
    
    public func getBoard() -> Board {
        return board
    }
    
    public func getCurrentlyPlaying() -> GamePiece{
        return currentlyPlaying
    }
    
    public func getGameStatus() -> GameStatus{
        return gameStatus
    }
    
    // Getters used by advanced tutorial:
    
    public static func getRiskZone0() -> [Int] {
        return RISK_ZONE0
    }
    
    public static func getRiskZone1() -> [Int] {
        return RISK_ZONE1
    }
    
    public static func getRiskZone2() -> [Int] {
        return RISK_ZONE2
    }
    
    public static func getRiskZone3() -> [Int] {
        return RISK_ZONE3
    }
    
    public static func getRiskZone4() -> [Int] {
        return RISK_ZONE4
    }
    
    public static func getRiskZone5() -> [Int] {
        return RISK_ZONE5
    }
    
    public static func getRiskZone6() -> [Int] {
        return RISK_ZONE6
    }
    
    
    // Setter that used only in online game when a player concedes:
    
    public func setGameStatus(gameStatus: GameStatus) {
        self.gameStatus = gameStatus
    }
    
    
    
    
    
    // The rest of the methods are useful for A.I. :
    
    
    public func makeAIMove(difficulty: Difficulty) {
    
        // If Difficulty is BEGINNER:
        // Make a random move.
        
        // If Difficulty is EASY:
        // Make a random move with a basic strategy that attempts to capture the corners.
        
        // If Difficulty is MEDIUM:
        // Attempt to capture the corners while making the move that results with more flipped pieces.
        
        // If Difficulty is HARD:
        // Picking the best zone to play out of all legal moves and making the move
        // that results with more flipped pieces within that zone.
        
        // If Difficulty is EXPERT:
        // Using the alpha beta pruning algorithm to calculate a few steps ahead, while relying on
        // an advanced zone-based strategy.
        
        if (difficulty == Difficulty.BEGINNER) { makeRandomMove() }
        else if (difficulty == Difficulty.EASY) { makeCornerStrategyMove() }
        else if (difficulty == Difficulty.MEDIUM) { makeCornerMaximalStrategyMove() }
        else if (difficulty == Difficulty.HARD) { makeCornerMaximalStrategyMove() }
        else if (difficulty == Difficulty.EXPERT) { makeOptimalMove() }
    
    }
    
    
    private func makeRandomMove() {
    
    
        // Playable Tiles:
        let playableTiles: Array<Int> = board.getPlayableTiles(gamePiece: currentlyPlaying)!
        
        // Making a random legal move:
        let index = Int(arc4random_uniform(UInt32(playableTiles.count)))
        let position = playableTiles[index]
        playTile(positionI: position/Board.getNumberOfCols(), positionJ: position%Board.getNumberOfCols())
        
    
    }
    
    
    private func makeCornerStrategyMove() {
    
    
        // Playable Tiles:
        let playableTiles: Array<Int> = board.getPlayableTiles(gamePiece: currentlyPlaying)!
        
        // Trying to capture one of the corners:
        for i in 0...Game.RISK_ZONE0.count-1 {
            if(playableTiles.contains(Game.RISK_ZONE0[i])){
                playTile(positionI: Game.RISK_ZONE0[i]/Board.getNumberOfCols(), positionJ: Game.RISK_ZONE0[i]%Board.getNumberOfCols())
                return
            }
        }
        
        // Making a random legal move:
        let index = Int(arc4random_uniform(UInt32(playableTiles.count)))
        let position = playableTiles[index]
        playTile(positionI: position/Board.getNumberOfCols(), positionJ: position%Board.getNumberOfCols())
        
    
    }
    
    
    private func makeCornerMaximalStrategyMove() {
    
    
        // Playable Tiles:
        let playableTiles: Array<Int> = board.getPlayableTiles(gamePiece: currentlyPlaying)!
        
        // The play with maximum flipped pieces:
        var maxPlayFlippedAmount = -1
        var maxPlayPosition = -1
        
        
        // Trying to capture one of the corners (with a preference for flipping maximum pieces):
        
        for i in 0...Game.RISK_ZONE0.count-1 {
            if(playableTiles.contains(Game.RISK_ZONE0[i])){
                
                let flippedAmount = predictOneTurnFlippedAmount(position: Game.RISK_ZONE0[i])
                
                if(flippedAmount > maxPlayFlippedAmount){
                    maxPlayFlippedAmount = flippedAmount
                    maxPlayPosition = Game.RISK_ZONE0[i]
                }
                
            }
        }
        
        
        // If one of the corners or more are playable:
        if(maxPlayPosition != -1) {
            // Play the corner that results with more flipped pieces:
            playTile(positionI: maxPlayPosition / Board.getNumberOfCols(), positionJ: maxPlayPosition % Board.getNumberOfCols())
            return
        }
        
        // Otherwise, make another move that results with maximum flipped pieces:
        
        for i in 0...playableTiles.count-1 {
            
            let flippedAmount = predictOneTurnFlippedAmount(position: playableTiles[i])
            
            if(flippedAmount > maxPlayFlippedAmount){
                maxPlayFlippedAmount = flippedAmount
                maxPlayPosition = playableTiles[i]
            }
            
        }
        
        // Play a tile that results with more flipped pieces:
        playTile(positionI: maxPlayPosition / Board.getNumberOfCols(), positionJ: maxPlayPosition % Board.getNumberOfCols())
        
    
    }
    
    
    private func makeZoneMaximalStrategyMove() {
    
        // Better Playable Tiles:
        let betterPlayableTiles: Array<Int> = getBetterPlayableTiles(playableTiles: board.getPlayableTiles(gamePiece: currentlyPlaying)!, applyAdvancedStrategy: false, board: nil)
        
        // The play with maximum flipped pieces:
        var maxPlayFlippedAmount = -1
        var maxPlayPosition = -1
        
        // Going through all better playable tiles:
        for position in 0...betterPlayableTiles.count-1 {
            
            let flippedAmount = predictOneTurnFlippedAmount(position: position)
            
            if(flippedAmount > maxPlayFlippedAmount){
                maxPlayFlippedAmount = flippedAmount
                maxPlayPosition = position
            }
            
        }
        
        // Play a tile within the best playable zone that results with more flipped pieces:
        playTile(positionI: maxPlayPosition / Board.getNumberOfCols(), positionJ: maxPlayPosition % Board.getNumberOfCols())
        
    }
    
    
    
    
    private func getBetterPlayableTiles(playableTiles: Array<Int>, applyAdvancedStrategy: Bool, board: Board?) -> Array<Int> {
    
        var playableTiles = playableTiles
        
        // Better Playable Tiles:
        var betterPlayableTiles = Array<Int>()
        
        
        // Checking if can capture RISK_ZONE0:
        for i in 0...Game.RISK_ZONE0.count-1 {
            if(playableTiles.contains(Game.RISK_ZONE0[i])){
                betterPlayableTiles.append(Game.RISK_ZONE0[i])
            }
        }
        if(!betterPlayableTiles.isEmpty) {
            return betterPlayableTiles
        }
        
        
        // Using a more stable strategy:
        if(applyAdvancedStrategy){
            
            
            // Out of all playable tiles, we want to ignore those that gives the opponent an opportunity
            // to capture the corners next turn (if we can):
            
            var currentlyNotPlaying: GamePiece
            if(currentlyPlaying == GamePiece.BLACK) { currentlyNotPlaying = GamePiece.WHITE }
            else { currentlyNotPlaying = GamePiece.BLACK }
            
            var preventCornerPlayableTiles = Array<Int>()
            
            for i in 0...playableTiles.count-1 {
                
                let newBoard = Board(other: board!)
                newBoard.addGamePiece(positionI: playableTiles[i] / Board.getNumberOfCols(), positionJ: playableTiles[i] % Board.getNumberOfCols(), gamePiece: currentlyPlaying)
                
                let opponentNextTurnPlayable: Array<Int> = newBoard.getPlayableTiles(gamePiece: currentlyNotPlaying)!
                
                // If opponent won't be able to capture a corner next turn:
                
                var canOpponentCapture = false
                for k in 0...Game.RISK_ZONE0.count-1 {
                    if (opponentNextTurnPlayable.contains(Game.RISK_ZONE0[k])){
                        canOpponentCapture = true
                        break
                    }
                }
                
                if(!canOpponentCapture) { preventCornerPlayableTiles.append(playableTiles[i]) }
                
            }
            
            if(!preventCornerPlayableTiles.isEmpty) {
                playableTiles = preventCornerPlayableTiles
            }
            
            
            // To make it even smarter, w'ell try to prevent the opponent from capturing RISK_ZONE1 next turn:
            
            var preventMarginPlayableTiles = Array<Int>()
            
            for i in 0...playableTiles.count-1 {
                
                let newBoard = Board(other: board!)
                newBoard.addGamePiece(positionI: playableTiles[i] / Board.getNumberOfCols(), positionJ: playableTiles[i] % Board.getNumberOfCols(), gamePiece: currentlyPlaying)
                
                let opponentNextTurnPlayable: Array<Int> = newBoard.getPlayableTiles(gamePiece: currentlyNotPlaying)!
                
                // If opponent won't be able to capture the margins next turn:
                
                var canOpponentCapture = false
                for k in 0...Game.RISK_ZONE1.count-1 {
                    if (opponentNextTurnPlayable.contains(Game.RISK_ZONE1[k])){
                        canOpponentCapture = true
                        break
                    }
                }
                
                if(!canOpponentCapture) { preventMarginPlayableTiles.append(playableTiles[i]) }
                
            }
            
            if(!preventMarginPlayableTiles.isEmpty) {
                playableTiles = preventMarginPlayableTiles
            }
            
            
            // In some cases, capturing RISK_ZONE4 might be actually great.
            // If the opponent can't capture the corners nor the margins, RISK_ZONE4 will simply give
            // the player more board control.
            if(!preventCornerPlayableTiles.isEmpty && !preventMarginPlayableTiles.isEmpty){
                
                // Checking if can capture RISK_ZONE4:
                for i in 0...Game.RISK_ZONE4.count-1 {
                    if(playableTiles.contains(Game.RISK_ZONE4[i])){
                        betterPlayableTiles.append(Game.RISK_ZONE4[i])
                    }
                }
                if(!betterPlayableTiles.isEmpty) {
                    return betterPlayableTiles
                }
                
            }
            
            
            
            
        }
        
        
        // Checking if can capture RISK_ZONE1:
        for i in 0...Game.RISK_ZONE1.count-1 {
            if(playableTiles.contains(Game.RISK_ZONE1[i])){
                betterPlayableTiles.append(Game.RISK_ZONE1[i])
            }
        }
        if(!betterPlayableTiles.isEmpty) {
            return betterPlayableTiles
        }
        
        
        // Checking if can capture RISK_ZONE2:
        for i in 0...Game.RISK_ZONE2.count-1 {
            if(playableTiles.contains(Game.RISK_ZONE2[i])){
                betterPlayableTiles.append(Game.RISK_ZONE2[i])
            }
        }
        if(!betterPlayableTiles.isEmpty) {
            return betterPlayableTiles
        }
        
        
        // Checking if can capture RISK_ZONE3:
        for i in 0...Game.RISK_ZONE3.count-1 {
            if(playableTiles.contains(Game.RISK_ZONE3[i])){
                betterPlayableTiles.append(Game.RISK_ZONE3[i])
            }
        }
        if(!betterPlayableTiles.isEmpty) {
            return betterPlayableTiles
        }
        
        return playableTiles
        
    
    }
    
    
    
    private func makeOptimalMove() {
    
        
        let MAX_MOVES_AHEAD = 3
        
        
        // Better Playable Tiles:
        var betterPlayableTiles = getBetterPlayableTiles(playableTiles: board.getPlayableTiles(gamePiece: currentlyPlaying)!, applyAdvancedStrategy: true, board: board)
        
        
        var maxPieceAmount = -Game.INFINITY
        var optimalPiecePosition = -1
        
        
        // Going through all possible plays:
        for i in 0...betterPlayableTiles.count-1 {
            
            // Creating new board:
            let newBoard = Board(other: board)
            
            // Simulating a move:
            newBoard.addGamePiece(positionI: betterPlayableTiles[i] / Board.getNumberOfCols(), positionJ: betterPlayableTiles[i] % Board.getNumberOfCols(), gamePiece: currentlyPlaying)
            
            var newPieceAmount: Int
            if(currentlyPlaying == GamePiece.BLACK) { newPieceAmount = newBoard.getNumberOfBlackPieces() }
            else { newPieceAmount = newBoard.getNumberOfWhitePieces() }
            
            // If the new board is full:
            if(newBoard.getNumberOfEmptyTiles() == 0){
                if(newPieceAmount > maxPieceAmount){
                    maxPieceAmount = newPieceAmount
                    optimalPiecePosition = betterPlayableTiles[i]
                }
            }
            else{
                
                // Determining opponent's game piece:
                var currentlyNotPlaying: GamePiece
                if (currentlyPlaying == GamePiece.BLACK) { currentlyNotPlaying = GamePiece.WHITE }
                else { currentlyNotPlaying = GamePiece.BLACK }
                
                // Checking If opponent can play:
                if(!newBoard.getPlayableTiles(gamePiece: currentlyNotPlaying)!.isEmpty){
                    
                    newPieceAmount = getMinimalPosition(board: Board(other: newBoard), movesAhead: MAX_MOVES_AHEAD, alpha: -1000, beta: 1000, isAncestorMax: true)
                    if(newPieceAmount > maxPieceAmount){
                        maxPieceAmount = newPieceAmount
                        optimalPiecePosition = betterPlayableTiles[i]
                    }
                    
                }
                    
                    // Otherwise, if both players can't play
                else if(newBoard.getPlayableTiles(gamePiece: currentlyPlaying)!.isEmpty){
                    
                    if(newPieceAmount > maxPieceAmount){
                        maxPieceAmount = newPieceAmount
                        optimalPiecePosition = betterPlayableTiles[i]
                    }
                    
                }
                    
                    
                    // Otherwise (same player gets another turn):
                else{
                    newPieceAmount = getMaximalPosition(board: Board(other: newBoard), movesAhead: MAX_MOVES_AHEAD, alpha: -1000, beta: 1000, isAncestorMin: false)
                    if(newPieceAmount > maxPieceAmount){
                        maxPieceAmount = newPieceAmount
                        optimalPiecePosition = betterPlayableTiles[i]
                    }
                }
                
            }
            
        }
        
        
        // Making the optimal move:
        playTile(positionI: optimalPiecePosition / Board.getNumberOfCols(), positionJ: optimalPiecePosition % Board.getNumberOfCols())
        
    
    }
    
    
    
    
    
    
    
    private func getMaximalPosition(board: Board, movesAhead: Int, alpha: Int, beta: Int, isAncestorMin: Bool) -> Int {
    
        
        // Better Playable Tiles:
        var betterPlayableTiles = getBetterPlayableTiles(playableTiles: board.getPlayableTiles(gamePiece: currentlyPlaying)!, applyAdvancedStrategy: true, board: board)
        
        
        var maxPieceAmount = -Game.INFINITY
        
        
        // Going through all possible plays:
        for i in 0...betterPlayableTiles.count-1 {
            
            // Creating new board:
            let newBoard = Board(other: board)
            
            // Simulating a move:
            newBoard.addGamePiece(positionI: betterPlayableTiles[i] / Board.getNumberOfCols(), positionJ: betterPlayableTiles[i] % Board.getNumberOfCols(), gamePiece: currentlyPlaying)
            
            var newPieceAmount: Int
            if(currentlyPlaying == GamePiece.BLACK) { newPieceAmount = newBoard.getNumberOfBlackPieces() }
            else { newPieceAmount = newBoard.getNumberOfWhitePieces() }
            
            // If the new board is full or we went through enough moves:
            if(newBoard.getNumberOfEmptyTiles() == 0 || movesAhead == 0){
                if(newPieceAmount > maxPieceAmount){
                    maxPieceAmount = newPieceAmount
                }
            }
            else{
                
                // Determining opponent's game piece:
                var currentlyNotPlaying: GamePiece
                if (currentlyPlaying == GamePiece.BLACK) { currentlyNotPlaying = GamePiece.WHITE }
                else { currentlyNotPlaying = GamePiece.BLACK }
                
                // Checking If opponent can play:
                if(!newBoard.getPlayableTiles(gamePiece: currentlyNotPlaying)!.isEmpty){
                    
                    newPieceAmount = getMinimalPosition(board: Board(other: newBoard), movesAhead: movesAhead - 1, alpha: maxPieceAmount, beta: beta, isAncestorMax: true)
                    if(newPieceAmount > maxPieceAmount){
                        maxPieceAmount = newPieceAmount
                    }
                    
                }
                    
                    // Otherwise, if both players can't play
                else if(newBoard.getPlayableTiles(gamePiece: currentlyPlaying)!.isEmpty){
                    
                    if(newPieceAmount > maxPieceAmount){
                        maxPieceAmount = newPieceAmount
                    }
                    
                }
                    
                    
                    // Otherwise (same player gets another turn):
                else{
                    newPieceAmount = getMaximalPosition(board: Board(other: newBoard), movesAhead: movesAhead - 1, alpha: maxPieceAmount, beta: beta, isAncestorMin: false)
                    if(newPieceAmount > maxPieceAmount){
                        maxPieceAmount = newPieceAmount
                    }
                }
                
            }
            
            
            // Pruning:
            if(isAncestorMin && maxPieceAmount >= beta) {
                return maxPieceAmount
            }
            
            
        }
        
        
        return maxPieceAmount
        
    
    }
    
    
    
    private func getMinimalPosition(board: Board, movesAhead: Int, alpha: Int, beta: Int, isAncestorMax: Bool) -> Int {
    
        
        // Determining opponent's game piece:
        var currentlyNotPlaying: GamePiece
        if (currentlyPlaying == GamePiece.BLACK) { currentlyNotPlaying = GamePiece.WHITE }
        else { currentlyNotPlaying = GamePiece.BLACK }
        
        
        // Better Playable Tiles:
        var betterPlayableTiles = getBetterPlayableTiles(playableTiles: board.getPlayableTiles(gamePiece: currentlyNotPlaying)!, applyAdvancedStrategy: true, board: board)
        
        
        var minPieceAmount = Game.INFINITY
        
        
        // Going through all possible plays:
        for i in 0...betterPlayableTiles.count-1 {
            
            // Creating new board:
            let newBoard = Board(other: board)
            
            // Simulating a move:
            newBoard.addGamePiece(positionI: betterPlayableTiles[i] / Board.getNumberOfCols(), positionJ: betterPlayableTiles[i] % Board.getNumberOfCols(), gamePiece: currentlyNotPlaying)
            
            var newPieceAmount: Int
            if(currentlyPlaying == GamePiece.BLACK) { newPieceAmount = newBoard.getNumberOfBlackPieces() }
            else { newPieceAmount = newBoard.getNumberOfWhitePieces() }
            
            // If the new board is full or we went through enough moves:
            if(newBoard.getNumberOfEmptyTiles() == 0 || movesAhead == 0){
                if(newPieceAmount < minPieceAmount){
                    minPieceAmount = newPieceAmount
                }
            }
            else{
                
                // Checking If opponent can play:
                if(!newBoard.getPlayableTiles(gamePiece: currentlyPlaying)!.isEmpty){
                    
                    newPieceAmount = getMaximalPosition(board: Board(other: newBoard), movesAhead: movesAhead - 1, alpha: alpha, beta: minPieceAmount, isAncestorMin: true)
                    if(newPieceAmount < minPieceAmount){
                        minPieceAmount = newPieceAmount
                    }
                    
                }
                    
                    // Otherwise, if both players can't play:
                else if(newBoard.getPlayableTiles(gamePiece: currentlyNotPlaying)!.isEmpty){
                    
                    if(newPieceAmount < minPieceAmount){
                        minPieceAmount = newPieceAmount
                    }
                    
                }
                    
                    
                    // Otherwise (same player gets another turn):
                else{
                    newPieceAmount = getMinimalPosition(board: Board(other: newBoard), movesAhead: movesAhead - 1, alpha: alpha, beta: minPieceAmount, isAncestorMax: false)
                    if(newPieceAmount < minPieceAmount){
                        minPieceAmount = newPieceAmount
                    }
                }
                
            }
            
            
            // Pruning:
            if(isAncestorMax && minPieceAmount <= alpha) {
                return minPieceAmount
            }
            
            
        }
        
        
        return minPieceAmount
        
    
    }
    
    
    
    
    private func predictOneTurnFlippedAmount(position: Int) -> Int {
        
        let newBoard = Board(other: board)
        
        newBoard.addGamePiece(positionI: position/Board.getNumberOfCols(), positionJ: position%Board.getNumberOfCols(), gamePiece: currentlyPlaying)
        
        
        var flippedAmount = 0
        
        if(currentlyPlaying == GamePiece.BLACK) {
            flippedAmount = newBoard.getNumberOfBlackPieces() - board.getNumberOfBlackPieces()
        }
        else {
            flippedAmount = newBoard.getNumberOfWhitePieces() - board.getNumberOfWhitePieces()
        }
        
        
        return flippedAmount
    
    }
    
    
    
    
}
