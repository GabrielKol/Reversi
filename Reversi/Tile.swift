
class Tile {
    
    private var recentlyFlipped: Bool = false
    private var occupyingGamePiece: GamePiece? = nil
    
    
    // All methods are simply getters and setters:
    
    public func isRecentlyFlipped() -> Bool {
        return recentlyFlipped
    }
    
    public func getOccupyingGamePiece() -> GamePiece? {
        return occupyingGamePiece
    }
    
    
    public func setRecentlyFlipped(recentlyFlipped: Bool) {
        self.recentlyFlipped = recentlyFlipped
    }
    
    public func setOccupyingGamePiece(occupyingGamePiece: GamePiece?) {
        self.occupyingGamePiece = occupyingGamePiece
    }
    
}
