import Foundation
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

      // Letters:
      func calculatePoint(point: Point, length: Int, angle: Double) -> Point {
          let newPoint : Point
          let radianAngle : CGFloat = angle * Double.pi / 180.0
          let x = Int((sin(radianAngle)) * CGFloat(length))
          let y = Int((cos(radianAngle)) * CGFloat(length))
          newPoint = point + Point(x: x, y: y)
          return newPoint
      }
      
      func lineToDiagonal(path: Path, currentPoint: inout Point, length: Int, angle: Double) {
          currentPoint = calculatePoint(point: currentPoint, length: length, angle: angle)
          path.lineTo(currentPoint)
      }
      func moveToDiagonal(path: Path, currentPoint: inout Point, length: Int, angle: Double) {
          currentPoint = calculatePoint(point: currentPoint, length: length, angle: angle)
          path.moveTo(currentPoint)
      }
      func lineToCardinal(path: Path, currentPoint: inout Point, by: Point) {
          currentPoint += by
          path.lineTo(currentPoint)

      }
      func drawP(to canvas: Canvas, point: Point, scale: Int) {
          let path = Path(fillMode: .fillAndStroke)
          var currentPoint = point
          path.moveTo(currentPoint)
          currentPoint += Point(x: 0, y: -2 * scale)
          path.arc(center: currentPoint, radius: scale * 2, startAngle: Double.pi * 0.5, endAngle: Double.pi * 1.5, antiClockwise: true)
          currentPoint += Point(x: 0, y: -2 * scale)
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: -1 * scale, y: 0))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: 0, y: scale * 6))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale * 1, y: 0))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: 0, y: scale * -2))
          currentPoint += Point(x: 0, y: -2 * scale)
          path.moveTo(currentPoint)
          path.arc(center: currentPoint, radius: scale, startAngle: Double.pi * 1.5, endAngle: Double.pi * 0.5, antiClockwise: false)
          currentPoint += Point(x: 0, y: -2 * scale)
          path.close()
          canvas.render(path)
      }
      func drawA(to canvas: Canvas, point: Point, scale: Int) {
          let path = Path(fillMode: .fillAndStroke)
          let startingPoint = point
          var currentPoint = point
          path.moveTo(currentPoint)
          lineToDiagonal(path: path, currentPoint: &currentPoint, length: scale * 4, angle: 345)
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale, y: 0))
          lineToDiagonal(path: path, currentPoint: &currentPoint, length: scale, angle: 165)
          let bottomLeftInnerA = calculatePoint(point: currentPoint, length: scale, angle: 165)
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale, y: 0))
          let bottomRightInnerA = calculatePoint(point: currentPoint, length: scale, angle: 195)
          lineToDiagonal(path: path, currentPoint: &currentPoint, length: scale, angle: 15)
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale, y: 0))
          lineToDiagonal(path: path, currentPoint: &currentPoint, length: scale * 4, angle: 195)
          path.lineTo(startingPoint)
          path.moveTo(bottomRightInnerA)
          currentPoint = bottomRightInnerA
          let topRightInnerA = calculatePoint(point: currentPoint, length: scale, angle: 195)
          path.lineTo(bottomLeftInnerA)
          currentPoint = bottomLeftInnerA
          lineToDiagonal(path: path, currentPoint: &currentPoint, length: scale, angle: 165)
          path.lineTo(topRightInnerA)
          path.lineTo(bottomRightInnerA)
          canvas.render(path)
      }
      func drawR(to canvas: Canvas, point: Point, scale: Int) {
          let path = Path(fillMode: .fillAndStroke)
          var currentPoint = point
          path.moveTo(currentPoint)
          currentPoint += Point(x: 0, y: -2 * scale)
          let startOfRCurve = calculatePoint(point: currentPoint, length: 2 * scale, angle: 30)
          let endOfRCurve = currentPoint + Point(x: 0, y: scale * -2)
          path.moveTo(endOfRCurve)
          path.arc(center: currentPoint, radius: scale * 2, startAngle: Double.pi * 1.5, endAngle: Double.pi * 2 / 6, antiClockwise: false)
          currentPoint = startOfRCurve
          lineToDiagonal(path: path, currentPoint: &currentPoint, length: scale * 3, angle: 40)
          let bottomLeftDiagonalLeg = currentPoint
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: -1 * scale, y: 0))
          lineToDiagonal(path: path, currentPoint: &currentPoint, length: scale * 3, angle: 220)
          currentPoint = Point(x: currentPoint.x, y: bottomLeftDiagonalLeg.y)
          path.lineTo(currentPoint)
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: -1 * scale, y: 0))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: 0, y: scale * -6))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale * 1, y: 0))
          path.lineTo(endOfRCurve)
          currentPoint += Point(x: 0, y: 2 * scale)
          path.moveTo(currentPoint - Point(x: 0, y: scale))
          path.arc(center: currentPoint, radius: scale, startAngle: Double.pi * 0.5, endAngle: Double.pi * 1.5, antiClockwise: true)
          path.lineTo(currentPoint - Point(x: 0, y: scale))
          canvas.render(path)
      }
      func drawT(to canvas: Canvas, point: Point, scale: Int) {
          let path = Path(fillMode: .fillAndStroke)
          let startingPoint = point
          var currentPoint = point
          path.moveTo(currentPoint)
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale * 3, y: 0))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: 0, y: scale * 1))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale * -1, y: 0))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: 0, y: scale * 4))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale * -1, y: 0))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: 0, y: scale * -4))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale * -1, y: 0))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: 0, y: scale * -1))
          path.lineTo(startingPoint)
          canvas.render(path)
      }
      func drawY(to canvas: Canvas, point: Point, scale: Int) {
          let path = Path(fillMode: .fillAndStroke)
          let startingPoint = point
          var currentPoint = point
          path.moveTo(currentPoint)
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: 0, y: scale * -4))
          lineToDiagonal(path: path, currentPoint: &currentPoint, length: scale * 9, angle: 200)
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale * 2, y: 0))
          lineToDiagonal(path: path, currentPoint: &currentPoint, length: scale * 6, angle: 20)
          lineToDiagonal(path: path, currentPoint: &currentPoint, length: scale * 6, angle: 160)
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale * 2, y: 0))
          lineToDiagonal(path: path, currentPoint: &currentPoint, length: scale * 9,  angle: 340)
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: 0, y: scale * 4))
          path.lineTo(startingPoint)
          canvas.render(path)
      }
      func drawM(to canvas: Canvas, point: Point, scale: Int) {
          let path = Path(fillMode: .fillAndStroke)
          let startingPoint = point
          var currentPoint = point
          path.moveTo(currentPoint)
          lineToDiagonal(path: path, currentPoint: &currentPoint, length: scale * 3 , angle: 195)
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: 0, y: scale * 3))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale * -1, y: 0))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: 0, y: scale * -5))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale * 1, y: 0))
          lineToDiagonal(path: path, currentPoint: &currentPoint, length: scale * 4 , angle: 15)
          lineToDiagonal(path: path, currentPoint: &currentPoint, length: scale * 4 , angle: 165)
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale * 1, y: 0))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: 0, y: scale * 5))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale * -1, y: 0))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: 0, y: scale * -3))
          lineToDiagonal(path: path, currentPoint: &currentPoint, length: scale * 3 , angle: 345)
          path.lineTo(startingPoint)
          canvas.render(path)
      }
      func drawO(to canvas: Canvas, point: Point, scale: Int) {
          let path = Path(fillMode: .fillAndStroke)
          let startingPoint = point
          path.arc(center: startingPoint, radius: scale * 2)
          path.moveTo(startingPoint + Point(x: scale * 3, y: 0))
          path.arc(center: startingPoint, radius: scale * 3, antiClockwise: true)
          path.moveTo(startingPoint)
          canvas.render(path)
      }      
      func drawD(to canvas: Canvas, point: Point, scale: Int) {
          let path = Path(fillMode: .fillAndStroke)
          var currentPoint = point
          path.moveTo(currentPoint)
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale * 1, y: 0))
          currentPoint -= Point(x: 0, y: -3 * scale)
          path.arc(center: currentPoint, radius: scale * 3, startAngle: Double.pi * 1.5, endAngle: Double.pi * 0.5)
          currentPoint -= Point(x: 0, y: -3 * scale)
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale * -1, y: 0))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: 0, y: scale * -6))
          currentPoint += Point(x: scale, y: scale * 3)
          path.moveTo(currentPoint + Point(x: 0, y: scale * 2))
          path.arc(center: currentPoint, radius: scale * 2, startAngle: Double.pi * 0.5, endAngle: Double.pi * 1.5, antiClockwise: true)
          currentPoint += Point(x: 0, y: scale * 2)
          path.close()
          canvas.render(path)
      }
      func drawE(to canvas: Canvas, point: Point, scale: Int) {
          let path = Path(fillMode: .fillAndStroke)
          let startingPoint = point
          var currentPoint = point
          path.moveTo(currentPoint)
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale * 3, y: 0))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: 0, y: scale * 1))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale * -2, y: 0))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: 0, y: scale * 1))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale * 1, y: 0))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: 0, y: scale * 1))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale * -1, y: 0))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: 0, y: scale * 1))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale * 2, y: 0))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: 0, y: scale * 1))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale * -3, y: 0))
          lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: 0, y: scale * -5))
          path.lineTo(startingPoint)
          canvas.render(path)
      }


      
      // Override Functions
      override func setup(canvasSize: Size, canvas: Canvas) {
          if let canvasSize = canvas.canvasSize {
              let background = Rect(size: canvasSize)
              renderRectangle(to: canvas, rect: background, fillMode: .fill, fillStyle: FillStyle(color: Color(.thistle)))
              let canvasCenter = returnCenter(rect: background)

              let TicTacToeButton = Rect(topLeft: Point(x: canvasCenter.x, y: 300), size: Size(width: 300, height: 50))
              let wordleButton = Rect(topLeft: Point(x: canvasCenter.x, y: 375), size: Size(width: 300, height: 50))
              let crossWordButton = Rect(topLeft: Point(x: canvasCenter.x, y: 450), size: Size(width: 300, height: 50))
              buttons.append(TicTacToeButton)
              buttons.append(wordleButton)
              buttons.append(crossWordButton)
              
              let buttonColors : [Color.Name] = [.darkseagreen, .lightblue, .lightpink]
              let buttonTitles : [String] = ["Tic-Tac-Toe", "Wordle", "Rainbow Mouse"]

              precondition(buttons.count == buttonColors.count && buttons.count == buttonTitles.count && !buttons.contains(nil), "Number of buttons does not equal number of colors.")
              for i in 0 ..< buttons.count {
                  let canvasCenteredButton = returnCenteredRect(rect: buttons[i]!, center: Point(x: canvasCenter.x, y: buttons[i]!.topLeft.y + buttons[i]!.size.height / 2))
                  buttons[i] = canvasCenteredButton
                  let fillStyle = FillStyle(color:Color(buttonColors[i]))
                  canvas.render(fillStyle)
                  renderButton(to: canvas, rect: buttons[i]!, fillMode: .fillAndStroke, radius: 20, centered: false, title: buttonTitles[i])
              }


              drawP(to: canvas, point: Point(x: 40, y: 100), scale: 25)
              drawA(to: canvas, point: Point(x: 100, y: 190), scale: 33)
              drawR(to: canvas, point: Point(x: 240, y: 460), scale: 25)
              drawT(to: canvas, point: Point(x: 320, y: 560), scale: 30)
              drawY(to: canvas, point: Point(x: 470, y: 900), scale: 13)
              drawM(to: canvas, point: Point(x: 1550, y: 200), scale: 30)
              drawO(to: canvas, point: Point(x: 1650, y: 320), scale: 22)
              drawD(to: canvas, point: Point(x: 1700, y: 440), scale: 25)
              drawE(to: canvas, point: Point(x: 1800, y: 640), scale: 30)
              

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

