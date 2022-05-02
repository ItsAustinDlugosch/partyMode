


import Igis
import Scenes

  /*
     This class is responsible for the background Layer.
     Internally, it maintains the RenderableEntities for this layer.
   */




class BackgroundLayer : Layer {
    // Insert Rects for Buttons, *** rect.topLeft.x = 0 then changed to canvasCenter within the Background       
    let background = Background()
    let letterP = Letter(character: "p", start: Point(x: 100, y: 550), scale: 20)
    init() {
        let background = Background()

        // Using a meaningful name can be helpful for debugging
          super.init(name:"Background")

          // We insert our RenderableEntities in the constructor
          insert(entity:background, at:.back)
          insert(entity:letterP, at:.front)
    }
}
