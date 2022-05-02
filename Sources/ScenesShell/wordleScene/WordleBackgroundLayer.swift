import Igis
import Scenes

  /*
     This class is responsible for the background Layer.
     Internally, it maintains the RenderableEntities for this layer.
   */


class WordleBackgroundLayer : Layer {

    

    init() {
        // Using a meaningful name can be helpful for debugging
        super.init(name:"WordleBackground")

        // We insert our RenderableEntities in the constructor
    }
}
