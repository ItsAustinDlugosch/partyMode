import Scenes


class crosswordScene: Scene {

    let backgroundLayer = CrosswordBackgroundLayer()
    let interactionLayer = CrosswordInteractionLayer()
    let foregroundLayer = CrosswordForeroundLayer()

    init() {
        super.init(name: "Crossword")
        insert(layer:backgroundLayer, at:.back)
        insert(layer:interactionLayer, at:.front)
        insert(layer:foregroundLayer, at:.front)
    }
} 
