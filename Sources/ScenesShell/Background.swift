import Scenes
import Igis

  /*
     This class is responsible for rendering the background.
   */


class Background : RenderableEntity {

      init() {
          // Using a meaningful name can be helpful for debugging
          super.init(name:"Background")
      }

      // Returns center of a particular
      func returnCenter(rect: Rect) -> Point {           
          return Point(x: (rect.size.width / 2) + rect.topLeft.x, y: (rect.size.height / 2) + rect.topLeft.y)          
      }

      // Simple function that renders a rectangle
      // Add options for StrokeStyle, LineWidth, and FillStyle with default values
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
              var textLocation = returnCenter(rect: rect)
              if centered { // Offset if the button is centered
                  textLocation -= Point(x: rect.size.width / 2, y: rect.size.height / 2)
              }
              
              let renderableText = Text(location: textLocation, text: text!)
              let fillStyle = FillStyle(color: Color(.white))
              renderableText.font = "30pt Comic Sans MS"
              renderableText.alignment = .center
              renderableText.baseline = .bottom
              canvas.render(fillStyle, renderableText)
          }          
      }
      
      // Override Functions
      override func setup(canvasSize: Size, canvas: Canvas) {
          if let canvasSize = canvas.canvasSize {
              let background = Rect(size: canvasSize)
              renderRectangle(to: canvas, rect: background, fillMode: .fill, fillStyle: FillStyle(color: Color(.lightcyan)))

              let canvasCenter = returnCenter(rect: background)
              
              let wordleButton = Rect(topLeft: canvasCenter, size: Size(width: 300, height: 50))
              let fillStyle = FillStyle(color: Color(.deepskyblue))
              canvas.render(fillStyle)
              renderButton(to: canvas, rect: wordleButton, fillMode: .fillAndStroke, radius: 20, centered: true, text: "Wordle")
          }
          }          
}
