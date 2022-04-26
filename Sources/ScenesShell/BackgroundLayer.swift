import Igis
import Scenes

  /*
     This class is responsible for the background Layer.
     Internally, it maintains the RenderableEntities for this layer.
   */




class BackgroundLayer : Layer {
    let background = Background()
    let letterA = Letter(character: "a", start: Point(x: 500, y: 400), scale: 30)

      init() {
          // Using a meaningful name can be helpful for debugging
          super.init(name:"Background")

          // We insert our RenderableEntities in the constructor
          insert(entity:background, at:.back)
          insert(entity:letterA, at:.front)
      }
  }
