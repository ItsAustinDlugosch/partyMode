import Foundation
import Scenes
import Igis

  /*
     This class is responsible for rendering the background.
   */


class WordsearchBackground : RenderableEntity, MouseMoveHandler {

    var red = 255
    var green = 0
    var blue = 0
    var state = 0

    var centerPoint : Point

    var rect: Rect?
   
    
    init() {

        centerPoint = Point(x: -100, y: -100)
        
          // Using a meaningful name can be helpful for debugging
          super.init(name:"WordsearchBackground")
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        if let canvasSize = canvas.canvasSize {
            rect = Rect(size: canvasSize)
            let blueBackground = FillStyle(color: Color(.cornflowerblue))
            canvas.render(blueBackground)
            canvas.render(Rectangle(rect: rect!, fillMode: .fill))
        }
        dispatcher.registerMouseMoveHandler(handler:self)
    }

    override func render(canvas: Canvas) {
        switch state {
        case 0:
            // + Green
            if green < 255 {
                green += 1 
            } else if green == 255 {
                state += 1
            }        
        case 1:
            // - Red
            if red > 0 {
                red -= 1
            } else if red == 0 {
                state += 1
            }
        case 2:
            // + Blue
            if blue < 255 {
                blue += 1
            } else if blue == 255 {
                state += 1
            }
        case 3:            
            // - Green
            if green > 0 {
                green -= 1
            } else if green == 0 {
                state += 1
            }
        case 4:
            // + Red
            if red < 255 {
                red += 1
            } else if red == 255 {
                state += 1
            }
        case 5:
            //- Blue
            if blue > 0 {
                blue -= 1
            } else if blue == 0 {
                state = 0
            }
        default:
            fatalError("State does not exist")
            
        }
        let cursorTrailColor = Color(red: UInt8(red), green: UInt8(green), blue: UInt8(blue))
        let antiCursorTrailColor = Color(red: UInt8(abs(red - 255)), green: UInt8(abs(green - 255)), blue: UInt8(abs(blue - 255)))
        
        let ellipse = Ellipse(center: centerPoint, radiusX: 50, radiusY: 50, fillMode: .fillAndStroke)
        canvas.render(StrokeStyle(color: antiCursorTrailColor), FillStyle(color: cursorTrailColor), ellipse)
    }

    func onMouseMove(globalLocation: Point, movement: Point) {
        centerPoint = globalLocation
    }
    
    override func teardown() {
        dispatcher.unregisterMouseMoveHandler(handler:self)
    }

    override func boundingRect() -> Rect {
        return Rect(size: Size(width: Int.max, height: Int.max))
    }
    
}
