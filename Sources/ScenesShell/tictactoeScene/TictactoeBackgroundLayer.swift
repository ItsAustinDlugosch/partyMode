
import Scenes

  /*
     This class is responsible for the background Layer.
     Internally, it maintains the RenderableEntities for this layer.
   */


class TictactoeBackgroundLayer : Layer {
    let tictactoeBackground = TictactoeBackground()

      init() {
          // Using a meaningful name can be helpful for debugging
          super.init(name:"TictactoeBackground")

          // We insert our RenderableEntities in the constructor
          insert(entity:tictactoeBackground, at:.back)
      }
  }
