import Scenes


class CrosswordScene: Scene {

    let backgroundLayer = CrosswordBackgroundLayer()
    let interactionLayer = CrosswordInteractionLayer()
    let foregroundLayer = CrosswordForegroundLayer()

    init() {
        super.init(name: "Crossword")
        insert(layer:backgroundLayer, at:.back)
        insert(layer:interactionLayer, at:.front)
        insert(layer:foregroundLayer, at:.front)
    }
} 
