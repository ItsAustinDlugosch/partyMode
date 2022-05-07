import Scenes
import Igis

  /*
     This class is responsible for rendering the background.
   */


class Background : RenderableEntity, EntityMouseClickHandler {

    var buttons = [Rect?]()
    var rect : Rect?
    
    init() {
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
          let topLeft = Point(x: center.x - rect.size.width / 2, y: center.y - rect.size.height / 2)
          let centeredRect = Rect(topLeft: topLeft, size: rect.size)
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
      func renderButton(to canvas: Canvas, rect: Rect, fillMode: FillMode, radius: Int, centered: Bool = false, title: String? = nil) {
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

         if title != nil { // include text that is centered on the button
             var textLocation = returnCenter(rect: rect) + Point(x: 0, y: 5)
              if centered { // Offset if the button is centered
                  textLocation -= Point(x: rect.size.width / 2, y: rect.size.height / 2)
              }
              
              let text = Text(location: textLocation, text: title!)
              let fillStyle = FillStyle(color: Color(.white))
              text.font = "30pt Comic Sans MS"
              text.alignment = .center
              text.baseline = .middle
              canvas.render(fillStyle, text)
          }          
      }
      
      // Override Functions
      override func setup(canvasSize: Size, canvas: Canvas) {
          if let canvasSize = canvas.canvasSize {
              let background = Rect(size: canvasSize)
              renderRectangle(to: canvas, rect: background, fillMode: .fill, fillStyle: FillStyle(color: Color(.thistle)))
              let canvasCenter = returnCenter(rect: background)

              let crosswordButton = Rect(topLeft: Point(x: canvasCenter.x, y: 300), size: Size(width: 300, height: 50))
              let wordleButton = Rect(topLeft: Point(x: canvasCenter.x, y: 375), size: Size(width: 300, height: 50))
              let wordsearchButton = Rect(topLeft: Point(x: canvasCenter.x, y: 450), size: Size(width: 300, height: 50))
              buttons.append(crosswordButton)
              buttons.append(wordleButton)
              buttons.append(wordsearchButton)
              
              let buttonColors : [Color.Name] = [.mediumaquamarine, .deepskyblue, .lightseagreen]
              let buttonTitles : [String] = ["Crossword", "Wordle", "Wordsearch"]

              precondition(buttons.count == buttonColors.count && buttons.count == buttonTitles.count && !buttons.contains(nil), "Number of buttons does not equal number of colors.")
              for i in 0 ..< buttons.count {
                  let canvasCenteredButton = returnCenteredRect(rect: buttons[i]!, center: Point(x: canvasCenter.x, y: buttons[i]!.topLeft.y + buttons[i]!.size.height / 2))
                  buttons[i] = canvasCenteredButton
                  let fillStyle = FillStyle(color:Color(buttonColors[i]))
                  canvas.render(fillStyle)
                  renderButton(to: canvas, rect: buttons[i]!, fillMode: .fillAndStroke, radius: 20, centered: false, title: buttonTitles[i])
              }

              // Fix**

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
              let nextScene: Scene
              switch gameNumber { // Switch scenes to each game scene
              case 0:
                  nextScene = CrosswordScene()                  
              case 1:
                  nextScene = WordleScene()                  
              case 2:
                  nextScene = WordsearchScene()                  
              default:
                  fatalError("Button does not exist")
              }
              guard let director = self.director as? ShellDirector else {
                  fatalError("ShellDirector required for scene transition")
              }
              director.enqueueScene(scene: nextScene)
              director.transitionToNextScene()
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

