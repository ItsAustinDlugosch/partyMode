import Scenes
import Igis

  /*
     This class is responsible for rendering the background.
   */


class TictactoeBackground : RenderableEntity, EntityMouseClickHandler {

    var boxes = [[Rect?]]()
    var boxLocation : [Int?] = [nil]
    var board : [[Bool?]] = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
    
    var playerOne = true
    var xScore = 0
    var oScore = 0

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

    func doesTwoDArrayContainNil(array: [[Any?]]) -> Bool {
        for i in array {
            for j in i {                
                if j == nil {
                    return true
                }
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
    func renderRectangle(to canvas: Canvas, rect: Rect, fillMode: FillMode = .stroke,
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
            renderRectangle(to: canvas, rect: Rect(topLeft: Point(x: rect.topLeft.x + spacing * i + rect.size.width * i, y: rect.topLeft.y),
                                                 size: Size(width: rect.size.width, height: rect.size.height)),
                          fillMode: fillMode, strokeStyle: strokeStyle, lineWidth: lineWidth, fillStyle: fillStyle)

        }
        
    }

    func renderRowAppend(to canvas: Canvas, count: Int, spacing: Int, rect: Rect, fillMode: FillMode = .stroke,
                 strokeStyle: StrokeStyle = StrokeStyle(color: Color(.black)),
                 lineWidth: LineWidth = LineWidth(width: 1),
                 fillStyle: FillStyle = FillStyle(color: Color(.black)), append: inout [[Rect?]]) {
        var rects = [Rect?]()

        for i in 0 ..< count {
            let rect = Rect(topLeft: Point(x: rect.topLeft.x + spacing * i + rect.size.width * i, y: rect.topLeft.y), size: Size(width: rect.size.width, height: rect.size.height))
            rects.append(rect)
            renderRectangle(to: canvas, rect: rect, fillMode: fillMode, strokeStyle: strokeStyle, lineWidth: lineWidth, fillStyle: fillStyle)
            

        }

        append.append(rects)        
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
                  append: inout [[Rect?]]) {
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

    func drawX(to canvas: Canvas, rect: Rect, strokeStyle : StrokeStyle = StrokeStyle(color: Color(.gray))) {
        let fifthOfSide = rect.size.width / 5

        let topLeft = rect.topLeft + Point(x: fifthOfSide, y: fifthOfSide)
        let bottomRight = rect.topLeft + Point(x: rect.size.width, y: rect.size.height) - Point(x: fifthOfSide, y: fifthOfSide)

        let path = Path(fillMode: .stroke)
        path.moveTo(topLeft)
        path.lineTo(bottomRight)
        path.moveTo(Point(x: bottomRight.x, y: topLeft.y))
        path.lineTo(Point(x: topLeft.x, y: bottomRight.y))

        let lineWidth = LineWidth(width: fifthOfSide / 5)

        canvas.render(strokeStyle, lineWidth, path)        
    }

    func drawO(to canvas: Canvas, rect: Rect, strokeStyle : StrokeStyle = StrokeStyle(color: Color(.gray))) {
        let fifthOfSide = rect.size.width / 5
        let radius = (rect.size.width - (2 * fifthOfSide)) / 2
        let midpoint = returnCenter(rect: rect)

        let path = Path(fillMode: .stroke)
        path.moveTo(midpoint + Point(x: radius, y: 0))
        path.arc(center: midpoint, radius: radius)
        
        let lineWidth = LineWidth(width: fifthOfSide / 5)

        canvas.render(strokeStyle, lineWidth, path)        
    }

    /*
     // An Attempt at making a algorithm that never loses Tic-Tac-Toe
    func returnRandomLocation() -> [Int] {
        let locations = [[0,0], [0,1], [0,2], [1,0], [1,1], [1,2], [2,0], [2,1], [2,2]]
        let nextMove = locations.randomElement()!
        return nextMove
    }

    // Returns the locations of any 2 given Bools (symbol) in a row, nil if none exists
    func blockTwoInARow(board: [[Bool?]], symbol: Bool) -> [Int]? {
        var inALine = 0
        var twoInARow : [[Int]]?
        var nextPlayLocation : [Int]? = nil

        let topHorizontal = [[0,0], [0,1], [0,2]]
        let middleHorizontal = [[1,0], [1,1], [1,2]]
        let bottomHorizontal = [[2,0], [2,1], [2,2]]
        let leftVertical = [[0,0], [1,0], [2,0]]
        let middleVertical = [[0,1], [1,1], [2,1]]
        let rightVertical = [[0,2], [1,2], [2,2]]
        let topLeftBottomRightDiagonal = [[0,0], [1,1], [2,2]]
        let bottomLeftTopRightDiagonal = [[2,0], [1,1], [0,2]]

        let lines = [topHorizontal, middleHorizontal, bottomHorizontal, leftVertical, middleVertical, rightVertical, topLeftBottomRightDiagonal, bottomLeftTopRightDiagonal]

        for i in 0 ..< lines.count {
            for j in lines[i] {
                if board[j[0]][j[1]] == symbol {
                    inALine += 1
                }
                

                if inALine == 2 {
                    twoInARow = lines[i]
                }
            }
            inALine = 0
        }

        if let row = twoInARow {
            for i in row {
                if board[i[0]][i[1]] == nil {
                    nextPlayLocation = i
                }
            }
        }

        return nextPlayLocation
    }

    // Returns the next location to play an O
    func calculateNextMove(location: [Int]) -> [Int]? {
        var nextMove : [Int]? = nil

        let corners = [[0,0], [0,2], [2,0], [2,2]]
        let outsides = [[0,1], [1,0], [1,2], [2,1]]

        switch turnCycleCount {
        case 0:
            if corners.contains(location) {
                nextMove = [1,1]
            }

            if outsides.contains(location) {
                switch location { 
                case [0,1]:
                    nextMove = [2,1]
                case [1,0]:
                    nextMove = [1,2]
                case [1,2]:
                    nextMove = [1,0]
                case [2,1]:
                    nextMove = [0,1]
                default:                
                    fatalError("Location does not exist")
                }
            }

            else { // Input was the middle
                nextMove = [2,2]
            }
        default:
            if let blocker = blockTwoInARow(board: board, symbol: true) {                
                return blocker
            }               

            if doesTwoDArrayContainNil(array: board) {
                var possibleRandomMove = returnRandomLocation()
                while board[possibleRandomMove[0]][possibleRandomMove[1]] == nil {
                    possibleRandomMove = returnRandomLocation()
                }
                nextMove = possibleRandomMove
            }            
            
        }
        
        return nextMove
    }
    
     */
    
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
        
        canvas.render(StrokeStyle(color: Color(.gray)), button)

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

    func returnVictoryRow (board: [[Bool?]], symbol: Bool) -> [[Int]]? {
        var inALine = 0
        var victoryRow : [[Int]]?
        
        
        let topHorizontal = [[0,0], [0,1], [0,2]]
        let middleHorizontal = [[1,0], [1,1], [1,2]]
        let bottomHorizontal = [[2,0], [2,1], [2,2]]
        let leftVertical = [[0,0], [1,0], [2,0]]
        let middleVertical = [[0,1], [1,1], [2,1]]
        let rightVertical = [[0,2], [1,2], [2,2]]
        let topLeftBottomRightDiagonal = [[0,0], [1,1], [2,2]]
        let bottomLeftTopRightDiagonal = [[2,0], [1,1], [0,2]]

        let lines = [topHorizontal, middleHorizontal, bottomHorizontal, leftVertical, middleVertical, rightVertical, topLeftBottomRightDiagonal, bottomLeftTopRightDiagonal]

        for i in 0 ..< lines.count {
            for j in lines[i] {
                if board[j[0]][j[1]] == symbol {
                    inALine += 1
                }
                

                if inALine == 3 {
                    victoryRow = lines[i]
                    return victoryRow
                }
            }
            inALine = 0
        }
        
        return nil
    }    


    override func setup(canvasSize: Size, canvas: Canvas) {
        if let canvasSize = canvas.canvasSize {
            clearCanvas(canvas: canvas)
            let background = Rect(size: canvasSize)

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

        if let canvasSize = canvas.canvasSize {            
            let midpoint = returnCenter(rect: Rect(size: canvasSize))
            let gridSide = canvasSize.width / 3
            let oneSixthCanvasWidth = canvasSize.width / 6
            let buttonWidth = canvasSize.width * 2 / 9
            let buttonOneCenter = Point(x: oneSixthCanvasWidth, y: midpoint.y)
            let buttonTwoCenter = Point(x: oneSixthCanvasWidth * 5, y: midpoint.y)
            let buttonOneRect = returnCenteredRect(rect: Rect(size: Size(width: buttonWidth, height: gridSide * 2 / 3)), center: buttonOneCenter)
            let buttonTwoRect = returnCenteredRect(rect: Rect(size: Size(width: buttonWidth, height: gridSide * 2 / 3)), center: buttonTwoCenter)
            let currentTurnFillStyle = FillStyle(color: Color(.mediumseagreen))
            let otherTurnFillStyle = FillStyle(color: Color(.darkgray))
            let whiteStrokeStyle = StrokeStyle(color: Color(.white))
            let diagonalStrokeStyle = StrokeStyle(color: Color(.darkgray))

            let gridRect = returnCenteredRect(rect: Rect(size: Size(width: gridSide, height: gridSide)), center: midpoint)
            
            let gridStartingRect = Rect(topLeft: gridRect.topLeft, size: Size(width: gridSide / 3, height: gridSide / 3))
            renderGrid(to: canvas, rowCount: 3, columnCount: 3, spacing: 0, rect: gridStartingRect)

            renderText(to: canvas, location: Point(x: buttonOneCenter.x, y: buttonOneRect.topLeft.y / 2), text: "\(xScore)", font: "50pt Helvetica")
            renderText(to: canvas, location: Point(x: buttonTwoCenter.x, y: buttonTwoRect.topLeft.y / 2), text: "\(oScore)", font: "50pt Helvetica")
            renderText(to: canvas, location: Point(x: midpoint.x, y: gridStartingRect.topLeft.y / 2), text: "Tic-Tac-Toe", font: "75pt Helvetica")
            
            if playerOne {
                canvas.render(currentTurnFillStyle)
                renderButton(to: canvas, rect: buttonOneRect, fillMode: .fillAndStroke, radius: gridSide / 9)
                
                drawX(to: canvas, rect: buttonOneRect, strokeStyle: whiteStrokeStyle)
                canvas.render(otherTurnFillStyle)
                renderButton(to: canvas, rect: buttonTwoRect, fillMode: .fillAndStroke, radius: gridSide / 9)
                drawO(to: canvas, rect: buttonTwoRect, strokeStyle: whiteStrokeStyle)
            } else {
                canvas.render(otherTurnFillStyle)
                renderButton(to: canvas, rect: buttonOneRect, fillMode: .fillAndStroke, radius: gridSide / 9)
                
                drawX(to: canvas, rect: buttonOneRect, strokeStyle: whiteStrokeStyle)
                canvas.render(currentTurnFillStyle)
                renderButton(to: canvas, rect: buttonTwoRect, fillMode: .fillAndStroke, radius: gridSide / 9)
                drawO(to: canvas, rect: buttonTwoRect, strokeStyle: whiteStrokeStyle)
            }

            if boxLocation != [nil] {
                if playerOne {
                    let xRect = boxes[boxLocation[0]!][boxLocation[1]!]!
                    drawX(to: canvas, rect: xRect)
                    board[boxLocation[0]!][boxLocation[1]!] = true
                } else {
                    let oRect = boxes[boxLocation[0]!][boxLocation[1]!]!
                    drawO(to: canvas, rect: oRect)
                    board[boxLocation[0]!][boxLocation[1]!] = false
                }
                
                boxLocation = [nil]
                playerOne = !playerOne
            }

            if let victoryRowX = returnVictoryRow(board: board, symbol: true) {
                xScore += 1
                var rowRects = [Rect]()
                for i in victoryRowX {
                    rowRects.append(boxes[i[0]][i[1]]!)
                }
                let pointOne = returnCenter(rect: rowRects[0])
                let pointTwo = returnCenter(rect: rowRects[2])
                let path = Path(fillMode: .stroke)
                path.moveTo(pointOne)
                path.lineTo(pointTwo)
                canvas.render(diagonalStrokeStyle, path)

                board = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
                clearCanvas(canvas: canvas)
            }
            if let victoryRowO = returnVictoryRow(board: board, symbol: false) {
                oScore += 1
                var rowRects = [Rect]()
                for i in victoryRowO {
                    rowRects.append(boxes[i[0]][i[1]]!)
                }
                let pointOne = returnCenter(rect: rowRects[0])
                let pointTwo = returnCenter(rect: rowRects[2])
                let path = Path(fillMode: .stroke)
                path.moveTo(pointOne)
                path.lineTo(pointTwo)
                canvas.render(diagonalStrokeStyle, path)

                board = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
                clearCanvas(canvas: canvas)
            }
            
        }           
    }

    func onEntityMouseClick(globalLocation: Point) {
        var boxNumber : Int? = nil
        for i in 0 ..< boxes.count {
            for j in 0 ..< boxes[i].count {
                if board[i][j] == nil {
                    if doesContain(rect: boxes[i][j]!, point: globalLocation) {
                        boxNumber = i * boxes.count + j
                    }
                }
            }
        }          
              
        if boxNumber != nil {
            boxLocation = returnTwoDArrayLocation(array: board, index: boxNumber!)
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
