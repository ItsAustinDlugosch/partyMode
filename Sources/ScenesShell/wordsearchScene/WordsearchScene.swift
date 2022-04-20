import Scenes

class WordsearchScene : Scene {

    let backgroundLayer = WordsearchBackgroundLayer()
    let interactionLayer = WordsearchInteractionLayer()
    let foregroundLayer = WordsearchForegroundLayer()

    init() {
        super.init(name: "Wordsearch")
        insert(layer: backgroundLayer, at: .back)
        insert(layer: interactionLayer, at: .front)
        insert(layer: foregroundLayer, at: .front)
    }
}
