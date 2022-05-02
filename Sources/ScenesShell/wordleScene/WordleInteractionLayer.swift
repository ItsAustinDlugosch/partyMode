import Scenes

  /*
     This class is responsible for the interaction Layer.
     Internally, it maintains the RenderableEntities for this layer.
   */


class WordleInteractionLayer : Layer {
    
    
    init() {
        let interaction = WordleInteraction()
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Interaction")

        // We insert our RenderableEntities in the constructor
        insert(entity: interaction, at: .back)
    }
}
