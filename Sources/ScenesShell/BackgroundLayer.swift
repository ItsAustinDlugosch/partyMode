


import Igis
import Scenes

  /*
     This class is responsible for the background Layer.
     Internally, it maintains the RenderableEntities for this layer.
   */




class BackgroundLayer : Layer {
    // Insert Rects for Buttons, *** rect.topLeft.x = 0 then changed to canvasCenter within the Background       
    let background = Background()
    let letterA = Letter(character: "a", start: Point(x: 300, y: 550), scale: 20)
    let letterF = Letter(character: "f", start: Point(x: 500, y: 400), scale: 30)
    let letterY = Letter(character: "y", start: Point(x: 500, y: 700), scale: 15)
    let letterE = Letter(character: "e", start: Point(x: 500, y: 400), scale: 30)
    let letterO = Letter(character: "o", start: Point(x: 300, y: 550), scale: 20)
    let letterT = Letter(character: "t", start: Point(x: 100, y: 400), scale: 30)
    let letterM = Letter(character: "m", start: Point(x: 200, y: 500), scale: 30)

    init() {
        let background = Background()

        // Using a meaningful name can be helpful for debugging
          super.init(name:"Background")

          // We insert our RenderableEntities in the constructor
          insert(entity:background, at:.back)
          insert(entity:letterE, at:.front)
          insert(entity:letterO, at:.front)
          insert(entity:letterA, at:.front)
          insert(entity:letterF, at:.front)
          insert(entity:letterY, at:.front)
          insert(entity:letterT, at:.front)
          insert(entity:letterM, at:.front)
    }
}
