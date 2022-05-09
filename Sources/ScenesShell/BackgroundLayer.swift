import Igis
import Scenes

  /*
     This class is responsible for the background Layer.
     Internally, it maintains the RenderableEntities for this layer.
   */




class BackgroundLayer : Layer {
    let background = Background()
    let letterP = Letter(character: "p", start: Point(x: 40, y: 100), scale: 25)
    let letterA = Letter(character: "a", start: Point(x: 100, y: 190), scale: 33)
    let letterR = Letter(character: "r", start: Point(x: 240, y: 460), scale: 25)
    let letterT = Letter(character: "t", start: Point(x: 320, y: 560), scale: 30)
    let letterY = Letter(character: "y", start: Point(x: 470, y: 900), scale: 13)
    
    let letterM = Letter(character: "m", start: Point(x: 1550, y: 200), scale: 30)
    let letterO = Letter(character: "o", start: Point(x: 1650, y: 320), scale: 20)
    let letterD = Letter(character: "d", start: Point(x: 1700, y: 440), scale: 25)
    let letterE = Letter(character: "e", start: Point(x: 1800, y: 640), scale: 30)
    
    let letterF = Letter(character: "f", start: Point(x: 500, y: 400), scale: 30)
   
    init() {
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Background")
        
        // We insert our RenderableEntities in the constructor
        insert(entity:background, at:.back)
        insert(entity:letterP, at:.front)
        insert(entity:letterA, at:.front)
        insert(entity:letterR, at:.front)
        insert(entity:letterT, at:.front)
        insert(entity:letterY, at:.front)
        
        insert(entity:letterM, at:.front)
        insert(entity:letterO, at:.front)
        insert(entity:letterD, at:.front)
        insert(entity:letterE, at:.front)

    }
}
