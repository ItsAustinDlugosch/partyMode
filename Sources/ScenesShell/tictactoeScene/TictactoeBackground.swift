import Scenes
import Igis

  /*
     This class is responsible for rendering the background.
   */


class TictactoeBackground : RenderableEntity, EntityMouseClickHandler {

    var boxes = [Rect?]()
    var boxNumber : Int? = nil
    var board : [[Bool?]] = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]

    var rect : Rect?
    
    init() {
        
          // Using a meaningful name can be helpful for debugging
          super.init(name:"TictactoeBackground")
    }

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

    // Returns an array of Int holding the index of the array then the index of the value in a two dimensional array based off of an Int
    func returnTwoDArrayLocation(array: [[Bool?]], index: Int) -> [Int] {
        var arrayLengths = [Int]()
        
        for i in array {
            arrayLengths.append(i.count)
        }

        var dimensionOne = 0
        var dimensionTwo = 0
        var workingNumber = index
        

        for i in arrayLengths {
            if workingNumber - i >= 0 {
                workingNumber -= i
                dimensionOne += 1
            }
        }

        dimensionTwo = workingNumber

        let location = [dimensionOne, dimensionTwo]
        return location
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

    func renderRowAppend(to canvas: Canvas, count: Int, spacing: Int, rect: Rect, fillMode: FillMode = .stroke,
                 strokeStyle: StrokeStyle = StrokeStyle(color: Color(.black)),
                 lineWidth: LineWidth = LineWidth(width: 1),
                 fillStyle: FillStyle = FillStyle(color: Color(.black)), append: inout [Rect?]) {

        for i in 0 ..< count {
            let rect = Rect(topLeft: Point(x: rect.topLeft.x + spacing * i + rect.size.width * i, y: rect.topLeft.y), size: Size(width: rect.size.width, height: rect.size.height))
            makeRectangle(to: canvas, rect: rect, fillMode: fillMode, strokeStyle: strokeStyle, lineWidth: lineWidth, fillStyle: fillStyle)
            append.append(rect)

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
    
    func renderGridAppend(to canvas: Canvas, rowCount: Int, columnCount: Int, spacing: Int, rect: Rect, fillMode: FillMode = .stroke,
                  strokeStyle: StrokeStyle = StrokeStyle(color: Color(.black)),
                  lineWidth: LineWidth = LineWidth(width: 1),
                  fillStyle: FillStyle = FillStyle(color: Color(.black)),
                  append: inout [Rect?]) {
        for i in 0 ..< rowCount { // Spacing between columns in renderRow, spacing between rows in renderGrid 
            renderRowAppend(to: canvas, count: columnCount, spacing: spacing, rect: Rect(topLeft: Point(x: rect.topLeft.x, y: rect.topLeft.y + spacing * i + rect.size.height * i), size: Size(width: rect.size.width, height: rect.size.height)), fillMode: fillMode, strokeStyle: strokeStyle, lineWidth: lineWidth, fillStyle: fillStyle, append: &append)
            
        }    
        
    }

    func renderText(to canvas: Canvas, location: Point, text: String, font: String) {
        let text = Text(location: location, text: text)
        text.font = font

        let fillStyle = FillStyle(color: Color(.black))

        canvas.render(fillStyle, text)
    }

    func drawX(to canvas: Canvas, rect: Rect) {
        let fifthOfSide = rect.size.width / 5

        let topLeft = rect.topLeft + Point(x: fifthOfSide, y: fifthOfSide)
        let bottomRight = rect.topLeft + Point(x: rect.size.width, y: rect.size.height) - Point(x: fifthOfSide, y: fifthOfSide)

        let path = Path(fillMode: .stroke)
        path.moveTo(topLeft)
        path.lineTo(bottomRight)
        path.moveTo(Point(x: bottomRight.x, y: topLeft.y))
        path.lineTo(Point(x: topLeft.x, y: bottomRight.y))

        let strokeStyle = StrokeStyle(color: Color(.gray))
        let lineWidth = LineWidth(width: fifthOfSide / 5)

        canvas.render(strokeStyle, lineWidth, path)        
    }

    func drawO(to canvas: Canvas, rect: Rect) {
        let fifthOfSide = rect.size.width / 5
        let radius = (rect.size.width - (2 * fifthOfSide)) / 2
        let midpoint = returnCenter(rect: rect)

        let path = Path(fillMode: .stroke)
        path.moveTo(midpoint + Point(x: 0, y: radius))
        path.arc(center: midpoint, radius: radius)
        
        let strokeStyle = StrokeStyle(color: Color(.gray))
        let lineWidth = LineWidth(width: fifthOfSide / 5)

        canvas.render(strokeStyle, lineWidth, path)        
    }

    // Returns the next location to play an O
    func firstMove(index: Int) -> [Int] {

        let corners = [[0,0], [0,2], [2,0], [2,2]]
        let outsides = [[0,1], [1,0], [1,2], [2,1]]
        
        let inputLocation = returnTwoDArrayLocation(array: board, index: index)

        if corners.contains(inputLocation) {
            return [1,1]
        }

        if outsides.contains(inputLocation) {
            switch inputLocation { 
            case [0,1]:
                return [2,1]
            case [1,0]:
                return [1,2]
            case [1,2]:
                return [1,0]
            case [2,1]:
                return [0,1]
            default:                
                fatalError("Location does not exist")
            }
        }

        else { // Input was the middle
            return [2,2]
        }
        
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        if let canvasSize = canvas.canvasSize {
            clearCanvas(canvas: canvas)
            let background = Rect(size: canvasSize)

            renderText(to: canvas, location: Point(x: 300, y: 100), text: "Impossible Tic-Tac-Toe", font: "30pt Verdana")

            let midpoint = returnCenter(rect: Rect(size: canvasSize))
            let gridSide = canvasSize.width / 3
            let gridRect = returnCenteredRect(rect: Rect(size: Size(width: gridSide, height: gridSide)), center: midpoint)
            
            let gridStartingRect = Rect(topLeft: gridRect.topLeft, size: Size(width: gridSide / 3, height: gridSide / 3))
            renderGridAppend(to: canvas, rowCount: 3, columnCount: 3, spacing: 0, rect: gridStartingRect, append: &boxes)

            rect = background
        }
        dispatcher.registerEntityMouseClickHandler(handler:self)

    }

    override func render(canvas: Canvas) {

            if boxNumber != nil {
                drawX(to: canvas, rect: boxes[boxNumber!]!)
                let boxCoordinate = returnTwoDArrayLocation(array: board, index: boxNumber!)
                let computerMoveLocation = firstMove(index: boxNumber!)
//                drawO()
                board[boxCoordinate[0]][boxCoordinate[1]] = true
                boxes[boxNumber!] = nil
                boxNumber = nil
            }


            

            
            
    }

    func onEntityMouseClick(globalLocation: Point) {
        for i in 0 ..< boxes.count {
            if boxes[i] != nil {
                if doesContain(rect: boxes[i]!, point: globalLocation) {
                    boxNumber = i
                }
            }
        }          
              
        if boxNumber != nil {
            switch boxNumber { // Switch scenes to each game scene
            case 0:
                boxNumber = 0
            case 1:
                boxNumber = 1
            case 2:
                boxNumber = 2
            case 3:
                boxNumber = 3
            case 4:
                boxNumber = 4
            case 5:
                boxNumber = 5
            case 6:
                boxNumber = 6
            case 7:
                boxNumber = 7
            case 8:
                boxNumber = 8
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
