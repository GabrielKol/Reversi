
import Foundation

class Board {
    
    
    // Number of cols and rows would be the same (the board is NxN):
    private static let NUMBER_OF_COLS: Int = 8
    private static let NUMBER_OF_TILES: Int = NUMBER_OF_COLS*NUMBER_OF_COLS
    
    private var tiles: [[Tile]] = Array(repeating: Array(repeating: Tile(), count: NUMBER_OF_COLS), count: NUMBER_OF_COLS)
    
    // At the beginning there are 2 pieces on the board for each type of piece (4 pieces in total):
    private var numberOfEmptyTiles: Int = NUMBER_OF_TILES
    private var numberOfBlackPieces: Int = 0
    private var numberOfWhitePieces: Int = 0
    
    // Constructor:
    init() {
        
        // Initializing the array of tiles:
        let lastIndex = Board.NUMBER_OF_COLS - 1
        for i in 0...lastIndex {
            for j in 0...lastIndex {
                tiles[i][j] = Tile()
            }
        }
        
        // Placing 4 pieces in the middle of the board:
        tiles[Board.NUMBER_OF_COLS/2 - 1][Board.NUMBER_OF_COLS/2 - 1].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
        tiles[Board.NUMBER_OF_COLS/2 - 1][Board.NUMBER_OF_COLS/2].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
        tiles[Board.NUMBER_OF_COLS/2][Board.NUMBER_OF_COLS/2 - 1].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
        tiles[Board.NUMBER_OF_COLS/2][Board.NUMBER_OF_COLS/2].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
        
        numberOfEmptyTiles = Board.NUMBER_OF_TILES - 4
        numberOfBlackPieces = 2
        numberOfWhitePieces = 2
        
    }
    
    // Copy Constructor:
    init(other: Board) {
        
        // Copy tiles:
        let lastIndex = Board.NUMBER_OF_COLS - 1
        for i in 0...lastIndex {
            for j in 0...lastIndex {
                tiles[i][j] = Tile()
                tiles[i][j].setOccupyingGamePiece(occupyingGamePiece: other.getTile(positionI: i,positionJ: j).getOccupyingGamePiece())
                tiles[i][j].setRecentlyFlipped(recentlyFlipped: other.getTile(positionI: i,positionJ: j).isRecentlyFlipped())
            }
        }
        
        // Copy counters:
        numberOfEmptyTiles = other.getNumberOfEmptyTiles()
        numberOfBlackPieces = other.getNumberOfBlackPieces()
        numberOfWhitePieces = other.getNumberOfWhitePieces()
        
    }
    
    // Constructor for tutorial purposes:
    init(phaseNumber: Int, isBasic: Bool) {
        
        // Initializing the array of tiles:
        let lastIndex = Board.NUMBER_OF_COLS - 1
        for i in 0...lastIndex {
            for j in 0...lastIndex {
                tiles[i][j] = Tile()
            }
        }
        
        // If it's a basic tutorial:
        if(isBasic){
            
            if(phaseNumber == 4){
                var k=0
                for i in 0...lastIndex {
                    for j in 0...lastIndex {
                        if k < 51 {
                            tiles[i][j].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                        }
                        else {
                            tiles[i][j].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                        }
                        k+=1
                    }
                }
                numberOfEmptyTiles = 0
                numberOfBlackPieces = 51
                numberOfWhitePieces = 13
            }
            
            if(phaseNumber == 7){
                tiles[2][3].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[3][3].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[4][3].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[5][3].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                numberOfEmptyTiles = Board.NUMBER_OF_TILES - 4
                numberOfBlackPieces = 1
                numberOfWhitePieces = 3
            }
            
            if(phaseNumber == 8){
                tiles[1][0].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[4][0].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[0][7].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[6][3].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[1][6].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[2][1].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[2][5].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[3][2].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[3][4].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[4][1].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[4][2].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[5][3].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                numberOfEmptyTiles = Board.NUMBER_OF_TILES - 12
                numberOfBlackPieces = 4
                numberOfWhitePieces = 8
            }
            
        }
            
        // If it's an advanced tutorial:
        else {
            
            if(phaseNumber == 5){
                tiles[2][3].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[7][2].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[7][6].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[1][2].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[3][3].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[3][4].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[3][5].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[4][3].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[4][4].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[4][5].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[5][3].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[6][3].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[6][5].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[7][4].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[7][5].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                numberOfEmptyTiles = Board.NUMBER_OF_TILES - 15
                numberOfBlackPieces = 3
                numberOfWhitePieces = 12
            }
                
            else if(phaseNumber == 8){
                tiles[0][0].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[0][7].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[7][0].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[7][7].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                numberOfEmptyTiles = Board.NUMBER_OF_TILES - 4
                numberOfBlackPieces = 4
                numberOfWhitePieces = 0
            }
            
            else if(phaseNumber == 9){
                for i in 0...lastIndex {
                    for j in 0...lastIndex {
                        tiles[i][j].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                    }
                }
                tiles[4][4].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[0][0].setOccupyingGamePiece(occupyingGamePiece: nil)
                tiles[0][7].setOccupyingGamePiece(occupyingGamePiece: nil)
                tiles[7][0].setOccupyingGamePiece(occupyingGamePiece: nil)
                tiles[7][7].setOccupyingGamePiece(occupyingGamePiece: nil)
                numberOfEmptyTiles = 4
                numberOfBlackPieces = 1
                numberOfWhitePieces = 59
            }
                
            else if(phaseNumber == 12){
                tiles[4][0].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[5][0].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[5][1].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[2][1].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[2][2].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[2][3].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[3][1].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[3][2].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[3][3].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[4][1].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                numberOfEmptyTiles = Board.NUMBER_OF_TILES - 10
                numberOfBlackPieces = 3
                numberOfWhitePieces = 7
            }
                
            else if(phaseNumber == 17 || phaseNumber == 18){
                tiles[7][0].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[7][1].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[7][2].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[7][3].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[7][4].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[7][5].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[7][6].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[7][7].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[6][2].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[6][3].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[6][4].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[6][5].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[6][6].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[6][7].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[5][4].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[5][5].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[5][6].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[5][7].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[4][3].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[4][4].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[4][5].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[4][6].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[4][7].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[3][4].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[3][7].setOccupyingGamePiece(occupyingGamePiece: GamePiece.BLACK)
                tiles[2][3].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[2][4].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[2][5].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[2][6].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[2][7].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[3][2].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[3][3].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[3][5].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[3][6].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[4][1].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[4][2].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[5][0].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[5][1].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[5][2].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                tiles[5][3].setOccupyingGamePiece(occupyingGamePiece: GamePiece.WHITE)
                numberOfEmptyTiles = Board.NUMBER_OF_TILES - 40
                numberOfBlackPieces = 25
                numberOfWhitePieces = 15
            }
                
            else{
                // Return an empty board:
                numberOfEmptyTiles = Board.NUMBER_OF_TILES
                numberOfBlackPieces = 0
                numberOfWhitePieces = 0
            }
            
            
        }
    
    }
    
    
    public func addGamePiece(positionI: Int, positionJ: Int, gamePiece: GamePiece) {
    
        // Checking if the tile is already occupied:
        if(tiles[positionI][positionJ].getOccupyingGamePiece() != nil){
            return
        }
    
        refreshTiles()
        
        // Placing the piece:
        tiles[positionI][positionJ].setOccupyingGamePiece(occupyingGamePiece: gamePiece)
        increasePieceAmountByOne(gamePiece: gamePiece)
        numberOfEmptyTiles-=1
        
        // Flipping opponent's pieces:
        
        // Going through all the rows and cols with tiles that might surround the chosen spot:
        for i in positionI-1...positionI+1 {
            for j in positionJ-1...positionJ+1 {
                
                // Now we need to make sure for each of these tiles
                // that it actually exists within the borders of the board:
                if(i>=0 && i < Board.NUMBER_OF_COLS && j>=0 && j < Board.NUMBER_OF_COLS) {
                    //We also want to skip the chosen spot itself:
                    if(i != positionI || j != positionJ) {
                        
                        // If there is an opponent's piece, we continue to check tiles in this direction
                        // until we encounter a piece of the same type as the currently playing.
                        if(tiles[i][j].getOccupyingGamePiece() != gamePiece &&
                            tiles[i][j].getOccupyingGamePiece() != nil){
                            
                            var sequentialPositionI = i
                            var sequentialPositionJ = j
                            
                            var continueChecking = true
                            
                            while(continueChecking) {
                                
                                // Advancing the position in the correct direction:
                                if (i < positionI) { sequentialPositionI-=1 }
                                if (i > positionI) { sequentialPositionI+=1 }
                                if (j < positionJ) { sequentialPositionJ-=1 }
                                if (j > positionJ) { sequentialPositionJ+=1 }
                                
                                // Make sure that the new position exists within the borders of the board:
                                if(sequentialPositionI >= 0 && sequentialPositionI < Board.NUMBER_OF_COLS &&
                                    sequentialPositionJ >= 0 && sequentialPositionJ < Board.NUMBER_OF_COLS){
                                    
                                    // If the tile is occupied by a piece of the currently playing type:
                                    if(tiles[sequentialPositionI][sequentialPositionJ].getOccupyingGamePiece() == gamePiece){
                                        
                                        // Flipping the tiles (the checkup is finished for this direction):
                                        while(sequentialPositionI != i || sequentialPositionJ != j){
                                            
                                            // Going back:
                                            if (i < positionI) { sequentialPositionI+=1 }
                                            if (i > positionI) { sequentialPositionI-=1 }
                                            if (j < positionJ) { sequentialPositionJ+=1 }
                                            if (j > positionJ) { sequentialPositionJ-=1 }
                                            
                                            // Flipping the piece:
                                            increasePieceAmountByOne(gamePiece: gamePiece)
                                            decreasePieceAmountByOne(gamePiece: tiles[sequentialPositionI][sequentialPositionJ].getOccupyingGamePiece())
                                            tiles[sequentialPositionI][sequentialPositionJ].setOccupyingGamePiece(occupyingGamePiece: gamePiece)
                                            tiles[sequentialPositionI][sequentialPositionJ].setRecentlyFlipped(recentlyFlipped: true)
                                            
                                        }
                                        
                                        // We found and flipped all the pieces that needed to be flipped
                                        // (in this direction).
                                        continueChecking = false //(the checkup is finished).
                                    }
                                        
                                        // If the tile is empty:
                                    else if (tiles[sequentialPositionI][sequentialPositionJ].getOccupyingGamePiece() == nil) {
                                        // There are no pieces needed to be flipped (in this direction).
                                        continueChecking = false //(the checkup is finished).
                                    }
                                    
                                    // Otherwise we found another opponent's piece and the checkup will simply continue.
                                    
                                }
                                    
                                    // Otherwise there is no point to continue to check.
                                else {
                                    // There are no pieces needed to be flipped (in this direction).
                                    continueChecking = false //(the checkup is finished).
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        
        // The game piece has been placed successfully.
    
    }
    
    
    
    
    public func getPlayableTiles (gamePiece: GamePiece?) -> Array<Int>?{
    
        // If the input is not a logical one:
        if(gamePiece == nil) {
            return nil
        }
        
        // Preparing a set for the playable tiles (a collection without duplicates):
        var playableTiles = Set<Int>()
        
        // Going through all tiles:
        let lastIndex = Board.NUMBER_OF_COLS - 1
        for positionI in 0...lastIndex {
            for positionJ in 0...lastIndex {
                
                // If we found a matching piece we can continue to check from that spot to all directions:
                if(tiles[positionI][positionJ].getOccupyingGamePiece() == gamePiece){
                    
                    // Going through all the rows and cols with tiles that might surround the chosen spot:
                    for i in positionI-1...positionI+1 {
                        for j in positionJ-1...positionJ+1 {
                            
                            // Now we need to make sure for each of these tiles
                            // that they actually exist within the borders of the board:
                            if (i >= 0 && i < Board.NUMBER_OF_COLS && j >= 0 && j < Board.NUMBER_OF_COLS) {
                                //We also want to skip the chosen spot itself:
                                if (i != positionI || j != positionJ) {
                                    
                                    // If there is an opponent's piece, we continue to check tiles in this direction
                                    // until we encounter an empty tile.
                                    if(tiles[i][j].getOccupyingGamePiece() != gamePiece &&
                                        tiles[i][j].getOccupyingGamePiece() != nil){
                                        
                                        var sequentialPositionI = i
                                        var sequentialPositionJ = j
                                        
                                        var continueChecking = true
                                        
                                        while(continueChecking) {
                                            
                                            // Advancing the position in the correct direction:
                                            if (i < positionI) { sequentialPositionI-=1 }
                                            if (i > positionI) { sequentialPositionI+=1 }
                                            if (j < positionJ) { sequentialPositionJ-=1 }
                                            if (j > positionJ) { sequentialPositionJ+=1 }
                                            
                                            // Make sure that the new position exists within the borders of the board:
                                            if(sequentialPositionI >= 0 && sequentialPositionI < Board.NUMBER_OF_COLS &&
                                                sequentialPositionJ >= 0 && sequentialPositionJ < Board.NUMBER_OF_COLS){
                                                
                                                // If the tile is empty (the checkup is finished for this direction):
                                                if(tiles[sequentialPositionI][sequentialPositionJ].getOccupyingGamePiece() == nil){
                                                    
                                                    // Adding this tile's position to the set:
                                                    playableTiles.insert(sequentialPositionI*Board.NUMBER_OF_COLS + sequentialPositionJ)
                                                    
                                                    // We found a playable tile (in this direction).
                                                    continueChecking = false
                                                    
                                                }
                                                    
                                                    // If the tile has a piece of the same type as the currently playing:
                                                else if (tiles[sequentialPositionI][sequentialPositionJ].getOccupyingGamePiece() == gamePiece) {
                                                    // Playable tile was not found (in this direction).
                                                    continueChecking = false
                                                }
                                                
                                                // Otherwise we found another opponents's piece and the checkup will simply continue.
                                                
                                            }
                                                
                                                // Otherwise there is no point to continue to check.
                                            else {
                                                // Playable tile was not found (in this direction).
                                                continueChecking = false
                                            }
                                            
                                        }
                                    }
                                    
                                    
                                }
                            }
                            
                        }
                    }
                    
                    
                }
                
                
            }
        }
        
        // Returning an ArrayList of the playable tiles' positions:
        return Array<Int>(playableTiles)
    
    }
    
    
    
    
    
    // The following function is useful in case the apps include animations.
    // After all the recently-flipped tiles will finish to flip and the animation will end,
    // this function should be used somewhere before the next animation (relevant UI change)
    // will take place so the next animation would be a proper one.
    // [This function is used only in addGamePiece() before a new piece is added to the board].
    
    public func refreshTiles(){
    
        // Enough time has passed, so none of the tiles should be seen as "recently flipped":
        let lastIndex = Board.NUMBER_OF_COLS - 1
        for i in 0...lastIndex {
            for j in 0...lastIndex {
                tiles[i][j].setRecentlyFlipped(recentlyFlipped: false)
            }
        }
    
    }
    
    
    
    // The following 2 functions are used to add/remove piece type to/from the board:
    
    private func increasePieceAmountByOne(gamePiece: GamePiece?){
        if gamePiece == GamePiece.BLACK {
            numberOfBlackPieces+=1
        }
        if gamePiece == GamePiece.WHITE {
            numberOfWhitePieces+=1
        }
    }
    
    private func decreasePieceAmountByOne(gamePiece: GamePiece?){
        if gamePiece == GamePiece.BLACK {
            numberOfBlackPieces-=1
        }
        if gamePiece == GamePiece.WHITE {
            numberOfWhitePieces-=1
        }
    }
    
    
    // Getters:
    
    public static func getNumberOfCols() -> Int {
        return Board.NUMBER_OF_COLS
    }
    
    public static func getNumberOfTiles() -> Int {
        return Board.NUMBER_OF_TILES
    }
    
    public func getTile(positionI: Int, positionJ: Int) -> Tile {
        return tiles[positionI][positionJ]
    }
    
    public func getNumberOfEmptyTiles() -> Int {
        return numberOfEmptyTiles
    }
    
    public func getNumberOfBlackPieces() -> Int {
        return numberOfBlackPieces
    }
    
    public func getNumberOfWhitePieces() -> Int {
        return numberOfWhitePieces
    }
    
    
}
