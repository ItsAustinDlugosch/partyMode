import Scenes
import Igis

  /*
     This class is responsible for rendering the background.
   */


class WordleInteraction : RenderableEntity, EntityMouseClickHandler {
    var guessCount = 3
    var currentGuess = ""
    var buttons = [Rect?]()
    var rect : Rect?
    
    init() {

        // Using a meaningful name can be helpful for debugging
        super.init(name:"WordleInteraction")
    }

    // Functions:

    // This function clears the entire canvas of other objects
    func clearCanvas(canvas:Canvas) {
        if let canvasSize = canvas.canvasSize {
            let canvasRect = Rect(topLeft:Point(), size:canvasSize)
            let canvasClearRectangle = Rectangle(rect:canvasRect, fillMode:.clear)
            canvas.render(canvasClearRectangle)
        }
    }

    // This returns the midpoint of any given rect
    func returnCenter(rect: Rect) -> Point {           
        return Point(x: (rect.size.width / 2) + rect.topLeft.x, y: (rect.size.height / 2) + rect.topLeft.y)          
    }

    // Returns true iff a given point is within a Rect
    func doesContain(rect: Rect, point: Point) -> Bool {
        let bottomRight : Point = rect.topLeft + Point(x: rect.size.width, y: rect.size.height)

        if point.x > rect.topLeft.x && point.x < bottomRight.x {
            if point.y > rect.topLeft.y && point.y < bottomRight.y {
                return true
            }
        }
        return false
    }

    // Returns a Rect that is centered around a given point
    func returnCenteredRect(rect: Rect, center: Point) -> Rect {
        let centeredRect = Rect(topLeft: center - Point(x: rect.size.width / 2, y: rect.size.height / 2), size: rect.size)
        return centeredRect
    }


    
    // This function makes a rectangle, with other customizeable options
    func makeRectangle(to canvas: Canvas, rect: Rect, fillMode: FillMode = .stroke,
                       strokeStyle: StrokeStyle = StrokeStyle(color: Color(.black)),
                       lineWidth: LineWidth = LineWidth(width: 1),
                       fillStyle: FillStyle = FillStyle(color: Color(.black))) {
        
        canvas.render(strokeStyle, lineWidth, fillStyle, Rectangle(rect: rect, fillMode: fillMode))
        
    }

    // This function makes a row of renctangles, with the customizeable options
    func renderRow(to canvas: Canvas, count: Int, spacing: Int, rect: Rect, fillMode: FillMode = .stroke,
                 strokeStyle: StrokeStyle = StrokeStyle(color: Color(.black)),
                 lineWidth: LineWidth = LineWidth(width: 1),
                 fillStyle: FillStyle = FillStyle(color: Color(.black))) {

        for i in 0 ..< count {
            makeRectangle(to: canvas, rect: Rect(topLeft: Point(x: rect.topLeft.x + spacing * i + rect.size.width * i, y: rect.topLeft.y),
                                                 size: Size(width: rect.size.width, height: rect.size.height)),
                          fillMode: fillMode, strokeStyle: strokeStyle, lineWidth: lineWidth, fillStyle: fillStyle)

        }
        
    }

    // This function makes a grid, either from a topLeft point generating down and right, or from a center point
    func renderGrid(to canvas: Canvas, rowCount: Int, columnCount: Int, spacing: Int, rect: Rect, fillMode: FillMode = .stroke,
                  strokeStyle: StrokeStyle = StrokeStyle(color: Color(.black)),
                  lineWidth: LineWidth = LineWidth(width: 1),
                  fillStyle: FillStyle = FillStyle(color: Color(.black))) {
        for i in 0 ..< rowCount { // Spacing between columns in renderRow, spacing between rows in renderGrid 
            renderRow(to: canvas, count: columnCount, spacing: spacing, rect: Rect(topLeft: Point(x: rect.topLeft.x, y: rect.topLeft.y + spacing * i + rect.size.height * i), size: Size(width: rect.size.width, height: rect.size.height)), fillMode: fillMode, strokeStyle: strokeStyle, lineWidth: lineWidth, fillStyle: fillStyle)
            
        }    
        
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
          
          canvas.render(FillStyle(color: Color(.lightgray)), button)

         if title != nil { // include text that is centered on the button
             var textLocation = returnCenter(rect: rect) + Point(x: 0, y: 5)
              if centered { // Offset if the button is centered
                  textLocation -= Point(x: rect.size.width / 2, y: rect.size.height / 2)
              }
              
              let text = Text(location: textLocation, text: title!)
              let fillStyle = FillStyle(color: Color(.black))
              text.font = "15pt Helvetica"
              text.alignment = .center
              text.baseline = .middle
              canvas.render(fillStyle, text)
          }          
      }

      func renderButtonRow(to canvas: Canvas, rect: Rect, fillMode: FillMode, radius: Int, centered: Bool = false, titles: [String?] = [nil], columnCount: Int, spacing: Int) {
          var buttonNames = titles
          while buttonNames.count != columnCount {
              buttonNames.append(nil)
          }
          var currentPoint = rect.topLeft
          for i in 0 ..< columnCount {
              let currentRect = Rect(topLeft: currentPoint, size: rect.size)
              renderButton(to: canvas, rect: currentRect, fillMode: fillMode, radius: radius, centered: centered, title: buttonNames[i])
              currentPoint.x += rect.width + spacing
              buttons.append(currentRect)
          }
      }

    // Override Functions:

    override func setup(canvasSize: Size, canvas: Canvas) {
        if let canvasSize = canvas.canvasSize {
            // Clear the title screen from canvas
            clearCanvas(canvas: canvas)
            let background = Rect(size: canvasSize)

            /*
             The wordle grid has 6 rows and 5 columns, by identifying the size of each box and the spacing inbetween them,
             we can find the total size of the grid and center it around the middle of the canvas

             The Layout of wordle has distance between objects at a scale mesured at a 1/16 of an inch. We can use measurements on the real website to accurately place objects on the background These are teh measurements:

             Canvas Height -     90
             Top Line -          84
             Top of Grid -       78
             Center of Grid -    54
             Bottom of Grid -    30
             Box size -           7
             Box Spacing -        1
             Top of Letters -    24
             Letter Height -      7
             Letter Width -              
             Bottom of Letters -  1
             */
            
            let midpoint = returnCenter(rect: Rect(size: canvasSize))
            let canvasScaleFactor = canvasSize.height / 90

            let wordleAnswerBoxSize = Size(width: canvasScaleFactor * 7, height: canvasScaleFactor * 7)
            let spacing = canvasScaleFactor
            // Multiply width of each box by number of columns, and spacing by number of columns minus one, similar for height
            let wordleGridSize = Size(width: (wordleAnswerBoxSize.width * 5) + (spacing * 4), height: (wordleAnswerBoxSize.height * 6) + (spacing * 5))
            let wordleGridCenterPoint = Point(x: midpoint.x, y: canvasSize.height) - Point(x: 0, y: canvasScaleFactor * 54)
            let wordleGridRect = returnCenteredRect(rect: Rect(size: wordleGridSize), center: wordleGridCenterPoint)            
            let strokeStyle = StrokeStyle(color: Color(.darkgray))
            let lineWidth = LineWidth(width: 2)
            renderGrid(to: canvas, rowCount: 6, columnCount: 5, spacing: 8, rect: Rect(topLeft: wordleGridRect.topLeft, size: wordleAnswerBoxSize), fillMode: .stroke, strokeStyle: strokeStyle, lineWidth: lineWidth)

            let topLine = Path(fillMode: .stroke)
            topLine.moveTo(Point(x:0, y:canvasScaleFactor * 6)) // Topline is 84, 90 - 84 = 6
            topLine.lineTo(Point(x:canvasSize.width, y: canvasScaleFactor * 6))
            canvas.render(topLine)
            
            // Render the Rects here then input them into
            let bottomMiddle = Point(x: midpoint.x, y: canvasSize.height)
            let row1ButtonNames = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
            let row2ButtonNames = ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
            let row3ButtonNames = ["Z", "X", "C", "V", "B", "N", "M"]
            // Starting letter of each row
            let zButton = Rect(topLeft: bottomMiddle - Point(x: canvasScaleFactor * 41 / 2, y: canvasScaleFactor + canvasScaleFactor * 7), size: Size(width: canvasScaleFactor * 5, height: canvasScaleFactor * 7))
            let aButton = Rect(topLeft: Point(x: zButton.topLeft.x - canvasScaleFactor * 6, y: bottomMiddle.y - canvasScaleFactor * 16), size: Size(width: canvasScaleFactor * 5, height: canvasScaleFactor * 7))
            let qButton = Rect(topLeft: Point(x: aButton.topLeft.x - canvasScaleFactor * 5 / 2, y: bottomMiddle.y - canvasScaleFactor * 24), size: Size(width: canvasScaleFactor * 5, height: canvasScaleFactor * 7))

            renderButtonRow(to: canvas, rect: qButton, fillMode: .fill, radius: canvasScaleFactor / 2, titles: row1ButtonNames, columnCount: row1ButtonNames.count, spacing: canvasScaleFactor)
            renderButtonRow(to: canvas, rect: aButton, fillMode: .fill, radius: canvasScaleFactor / 2, titles: row2ButtonNames, columnCount: row2ButtonNames.count, spacing: canvasScaleFactor)
            renderButtonRow(to: canvas, rect: zButton, fillMode: .fill, radius: canvasScaleFactor / 2, titles: row3ButtonNames, columnCount: row3ButtonNames.count, spacing: canvasScaleFactor)

            let enterButton = Rect(topLeft: Point(x: qButton.topLeft.x, y: zButton.topLeft.y), size: Size(width: canvasScaleFactor * 15 / 2, height: canvasScaleFactor * 7))
            renderButton(to: canvas, rect: enterButton, fillMode: .fill, radius: canvasScaleFactor / 2, title: "ENTER")
            let deleteButton = Rect(topLeft: Point(x: zButton.topLeft.x + canvasScaleFactor * 42, y: zButton.topLeft.y), size: Size(width: canvasScaleFactor * 15 / 2, height: canvasScaleFactor * 7))
            renderButton(to: canvas, rect: deleteButton, fillMode: .fill, radius: canvasScaleFactor / 2)
            rect = background
        }
        
        dispatcher.registerEntityMouseClickHandler(handler:self)
    }

    override func render(canvas: Canvas) {
        if let canvasSize = canvas.canvasSize {
            let midpoint = returnCenter(rect: Rect(size: canvasSize))
            let canvasScaleFactor = canvasSize.height / 90
            
            let rowTopLeft = Point(x: midpoint.x - canvasScaleFactor * 39 / 2, y: canvasSize.height) - Point(x: 0, y: canvasScaleFactor * 78 - (guessCount * canvasScaleFactor * 8)) // This is scuffed but it lines up
            canvas.render(Rectangle(rect: Rect(topLeft: rowTopLeft, size: Size(width: 20, height: 20)), fillMode: .stroke))

//            renderButtonRow(to: canvas, rect: Rect, fillMode: FillMode, radius: Int, columnCount: Int, spacing: Int)
        }
    }
    
    func onEntityMouseClick(globalLocation: Point) {
        var characterNumber : Int? = nil
          if !buttons.contains(nil) {
              for i in 0 ..< buttons.count {
                  if doesContain(rect: buttons[i]!, point: globalLocation) {
                      characterNumber = i
                  }
              }
          }

          if characterNumber != nil && currentGuess.count <= 5{
              switch characterNumber { // Switch scenes to each game scene
              case 0:
                  currentGuess.append("Q")
              case 1:
                  currentGuess.append("W")
              case 2:
                  currentGuess.append("E")
              case 3:
                  currentGuess.append("R")
              case 4:
                  currentGuess.append("T")
              case 5:
                  currentGuess.append("Y")
              case 6:
                  currentGuess.append("U")
              case 7:
                  currentGuess.append("I")
              case 8:
                  currentGuess.append("O")
              case 9:
                  currentGuess.append("P")
              case 10:
                  currentGuess.append("A")
              case 11:
                  currentGuess.append("S")
              case 12:
                  currentGuess.append("D")
              case 13:
                  currentGuess.append("F")
              case 14:
                  currentGuess.append("G")
              case 15:
                  currentGuess.append("H")
              case 16:
                  currentGuess.append("J")
              case 17:
                  currentGuess.append("K")
              case 18:
                  currentGuess.append("L")
              case 19:
                  currentGuess.append("Z")
              case 20:
                  currentGuess.append("X")
              case 21:
                  currentGuess.append("C")
              case 22:
                  currentGuess.append("V")
              case 23:
                  currentGuess.append("B")
              case 24:
                  currentGuess.append("N")
              case 25:
                  currentGuess.append("M")
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

