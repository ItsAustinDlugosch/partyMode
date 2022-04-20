
import Scenes
import Igis

  /*
     This class is responsible for rendering the background.
   */


class WordleBackground : RenderableEntity, EntityMouseClickHandler {

    var buttons : [Rect?]
    var rect : Rect?
    
    init() {        
        buttons = [nil] // ask how to make this better
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Background")
    }

      // Returns center of a particular
      func returnCenter(rect: Rect) -> Point {           
          return Point(x: (rect.size.width / 2) + rect.topLeft.x, y: (rect.size.height / 2) + rect.topLeft.y)          
      }

      func doesContain(rect: Rect, point: Point) -> Bool {
          let bottomRight : Point = rect.topLeft + Point(x: rect.size.width, y: rect.size.height)

          if point.x > rect.topLeft.x && point.x < bottomRight.x {
              if point.y > rect.topLeft.y && point.y < bottomRight.y {
                  return true
              }
          }
          return false
      }

      func returnCenteredRect(rect: Rect, center: Point) -> Rect {
          let centeredRect = Rect(topLeft: rect.topLeft - Point(x: rect.size.width / 2, y: rect.size.height / 2), size: rect.size)
          return centeredRect
      }

      // Simple function that renders a rectangle
      func renderRectangle(to canvas: Canvas, rect: Rect, fillMode: FillMode,
                           strokeStyle: StrokeStyle = StrokeStyle(color: Color(.black)),
                           lineWidth: LineWidth = LineWidth(width: 1),
                           fillStyle: FillStyle = FillStyle(color: Color(.black)),
                           centered : Bool = false) {
          var rect = rect
          if centered {
              rect.topLeft.x -= rect.size.width / 2
              rect.topLeft.y -= rect.size.height / 2
          }
          canvas.render(strokeStyle, lineWidth, fillStyle, Rectangle(rect: rect, fillMode: fillMode))
      }

      // Function that adds rounded corners to a rectangle
      func renderButton(to canvas: Canvas, rect: Rect, fillMode: FillMode, radius: Int, centered: Bool = false, text: String? = nil) {
          // New width and height accounting for rounded corners
          let width = rect.size.width - (2 * radius) 
          let height = rect.size.height - (2 * radius)
          
          let button = Path(fillMode: fillMode)

          // Start the path at the topLeft of the original rect, but move right by the radius
          var currentPoint = Point(x: rect.topLeft.x + radius, y: rect.topLeft.y)
          if centered {
              currentPoint -= Point(x: rect.size.width / 2, y: rect.size.height / 2)
          }
          
          button.moveTo(currentPoint)
          
          currentPoint.x += width
          button.lineTo(currentPoint)
          
          currentPoint.y += radius // Move down to center arc
          button.arc(center: currentPoint, radius: radius, startAngle: 1.5 * Double.pi, endAngle: 2 * Double.pi)
          currentPoint.x += radius
          
          currentPoint.y += height
          button.lineTo(currentPoint)

          currentPoint.x -= radius // Move left to center arc
          button.arc(center: currentPoint, radius: radius, startAngle: 2 * Double.pi, endAngle: 0.5 * Double.pi)
          currentPoint.y += radius

          currentPoint.x -= width
          button.lineTo(currentPoint)

          currentPoint.y -= radius
          button.arc(center: currentPoint, radius: radius, startAngle: 0.5 * Double.pi, endAngle: Double.pi)
          currentPoint.x -= radius

          currentPoint.y -= height
          button.lineTo(currentPoint)

          currentPoint.x += radius
          button.arc(center: currentPoint, radius: radius, startAngle:  Double.pi, endAngle: 1.5 * Double.pi)         
          
          canvas.render(button)

          if text != nil { // include text that is centered on the button
              var textLocation = returnCenter(rect: rect) + Point(x: 0, y: 5) // Comic Sans is top heavy
              if centered { // Offset if the button is centered
                  textLocation -= Point(x: rect.size.width / 2, y: rect.size.height / 2)
              }
              
              let renderableText = Text(location: textLocation, text: text!)
              let fillStyle = FillStyle(color: Color(.white))
              renderableText.font = "30pt Comic Sans MS"
              renderableText.alignment = .center
              renderableText.baseline = .middle
              canvas.render(fillStyle, renderableText)
          }          
      }
      
      // Override Functions
      override func setup(canvasSize: Size, canvas: Canvas) {
          if let canvasSize = canvas.canvasSize {
              let background = Rect(size: canvasSize)
              renderRectangle(to: canvas, rect: background, fillMode: .fill, fillStyle: FillStyle(color: Color(.lightcyan)))
              buttons.remove(at: 0) // THIS IS BAD ASK MR. BEN
              let canvasCenter = returnCenter(rect: background)

              let crosswordButton = Rect(topLeft: Point(x: canvasCenter.x, y: 300), size: Size(width: 300, height: 50))
              let crosswordFill = FillStyle(color: Color(.mediumaquamarine))
              canvas.render(crosswordFill)
              renderButton(to: canvas, rect: crosswordButton, fillMode: .fillAndStroke, radius: 20, centered: true, text: "Crossword")
              // Append the centered rect
              buttons.append(returnCenteredRect(rect: crosswordButton, center: crosswordButton.topLeft))
              
              let wordleButton = Rect(topLeft: Point(x: canvasCenter.x, y: 375), size: Size(width: 300, height: 50))
              let wordleFill = FillStyle(color: Color(.deepskyblue))
              canvas.render(wordleFill)
              renderButton(to: canvas, rect: wordleButton, fillMode: .fillAndStroke, radius: 20, centered: true, text: "Wordle")
              // Append the centered rect
              buttons.append(returnCenteredRect(rect: wordleButton, center: wordleButton.topLeft))


              let wordsearchButton = Rect(topLeft: Point(x: canvasCenter.x, y: 450), size: Size(width: 300, height: 50))
              let wordsearchFill = FillStyle(color: Color(.lightseagreen))
              canvas.render(wordsearchFill)
              renderButton(to: canvas, rect: wordsearchButton, fillMode: .fillAndStroke, radius: 20, centered: true, text: "Wordsearch")
              // Append the centered rect
              buttons.append(returnCenteredRect(rect: wordsearchButton, center: wordsearchButton.topLeft))                            

              rect = background
          }
          dispatcher.registerEntityMouseClickHandler(handler:self)
      }

      func onEntityMouseClick (globalLocation: Point) {
          var gameNumber : Int? = nil
          if !buttons.contains(nil) {
              for i in 0 ..< buttons.count {
                  if doesContain(rect: buttons[i]!, point: globalLocation) {
                      gameNumber = i
                  }
              }
          }

          if gameNumber != nil {
              switch gameNumber {
              case 0:
                  print("Crossword")
              case 1:
                  print("Wordle")
              case 2:
                  print("Wordsearch")
              default:
                  fatalError("Button does not exist")
              }
          }
          
      }
      
      override func teardown() {
          dispatcher.unregisterEntityMouseClickHandler(handler:self)
      }

      override func boundingRect() -> Rect {
          if let rect = rect {
              return rect
          } else {
              return Rect()
          }
      }

}

