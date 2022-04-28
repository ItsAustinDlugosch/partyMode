import Igis
import Scenes

  /*
     This class is responsible for the background Layer.
     Internally, it maintains the RenderableEntities for this layer.
   */




class BackgroundLayer : Layer {
    let background = Background()
    let letterA = Letter(character: "a", start: Point(x: 300, y: 550), scale: 20)
    let letterF = Letter(character: "f", start: Point(x: 500, y: 400), scale: 30)
    let letterY = Letter(character: "y", start: Point(x: 500, y: 700), scale: 15)

      init() {
          // Using a meaningful name can be helpful for debugging
          super.init(name:"Background")

          // We insert our RenderableEntities in the constructor
          insert(entity:background, at:.back)
          insert(entity:letterA, at:.front)
          insert(entity:letterF, at:.front)
          insert(entity:letterY, at:.front)
      }
}
