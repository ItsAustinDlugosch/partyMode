
import Scenes


class CrosswordScene: Scene {

    let backgroundLayer = TictactoeBackgroundLayer()
    let interactionLayer = TictactoeInteractionLayer()
    let foregroundLayer = TictactoeForegroundLayer()

    init() {
        super.init(name: "Crossword")
        insert(layer:backgroundLayer, at:.back)
        insert(layer:interactionLayer, at:.front)
        insert(layer:foregroundLayer, at:.front)
    }
} 
