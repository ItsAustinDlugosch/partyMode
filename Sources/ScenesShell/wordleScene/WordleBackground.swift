import Scenes
import Igis

  /*
     This class is responsible for rendering the background.
   */


class WordleBackground : RenderableEntity, EntityMouseClickHandler {
    
    init() {        
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Background")
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


    // Override Functions:

    override func setup(canvasSize: Size, canvas: Canvas) {
        if let canvasSize = canvas.canvasSize {
            // Clear the title screen from canvas
            clearCanvas(canvas: canvas)            
            /*
             The wordle grid has 6 rows and 5 columns, by identifying the size of each box and the spacing inbetween them,
             we can find the total size of the grid and center it around the middle of the canvas
             */
            let midpoint = returnCenter(rect: Rect(size: canvasSize))
            let wordleAnswerBoxSize = Size(width: 60, height: 60)
            let spacing = 8
            // Multiply width of each box by number of columns, and spacing by number of columns minus one, similar for height
            let wordleGridSize = Size(width: (wordleAnswerBoxSize.width * 5) + (spacing * 4), height: (wordleAnswerBoxSize.height * 6) + (spacing * 5))
            let wordleGridCenterPoint = midpoint - Point(x: 0, y: canvasSize.height / 6)
            let wordleGridRect = returnCenteredRect(rect: Rect(size: wordleGridSize), center: wordleGridCenterPoint)            
            let strokeStyle = StrokeStyle(color: Color(.darkgray))
            let lineWidth = LineWidth(width: 2)
            renderGrid(to: canvas, rowCount: 6, columnCount: 5, spacing: 8, rect: Rect(topLeft: wordleGridRect.topLeft, size: wordleAnswerBoxSize), fillMode: .stroke, strokeStyle: strokeStyle, lineWidth: lineWidth)

            let topLine = Path(fillMode: .stroke)
            topLine.moveTo(Point(x:0, y:50))
            topLine.lineTo(Point(x:canvasSize.width, y: 50))
            canvas.render(topLine)
        }
        
        dispatcher.registerEntityMouseClickHandler(handler:self)
    }
    
    func onEntityMouseClick(globalLocation: Point) {

    }

    override func teardown() {
        dispatcher.unregisterEntityMouseClickHandler(handler:self)
    }


}

