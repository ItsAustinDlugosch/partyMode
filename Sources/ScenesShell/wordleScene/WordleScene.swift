import Scenes

class WordleScene : Scene {

    let backgroundLayer = WordleBackgroundLayer()
    let interactionLayer = WordleInteractionLayer()
    let foregroundLayer = WordleForegroundLayer()

    init() {
        super.init(name: "Wordle")
        insert(layer:backgroundLayer, at:.back)
        insert(layer:interactionLayer, at:.front)
        insert(layer:foregroundLayer, at:.front)        
    }
    
}
