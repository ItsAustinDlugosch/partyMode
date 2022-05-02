import Scenes
import Igis

  /*
     This class is responsible for rendering the background.
   */


class WordleBackground : RenderableEntity {

    var buttons = [Rect?]()
    var rect : Rect?
    
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
        
    }


}

