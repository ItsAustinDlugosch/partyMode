import Scenes

  /*
     This class is responsible for the background Layer.
     Internally, it maintains the RenderableEntities for this layer.
   */


class CrosswordBackgroundLayer : Layer {
      let crosswordBackground = CrosswordBackground()

      init() {
          // Using a meaningful name can be helpful for debugging
          super.init(name:"CrosswordBackground")

          // We insert our RenderableEntities in the constructor
          insert(entity:crosswordBackground, at:.back)
      }
  }
