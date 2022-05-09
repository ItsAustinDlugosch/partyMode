import Scenes
import Igis
import Foundation

  /*
     This class is responsible for rendering the background.
   */


class WordleInteraction : RenderableEntity, EntityMouseClickHandler {

    var buttons = [Rect?]()
    var rect : Rect?

    var fiveLetterWords = [String]()
    var answer = [Character?]()

    var guessCount = 0
    var currentGuess = [Character?]()
    var entered = false
    
    var victory = false

    var frame = 0
    var animationBool = false
    
    init() {
        // Using a meaningful name can be helpful for debugging
        super.init(name:"WordleInteraction")
    }

    // Functions:
    func pullWords() throws {
        let dictionaryURL = URL.init(fileURLWithPath: "/usr/share/dict/words")
        let contents = try String(contentsOf: dictionaryURL, encoding: .utf8)
        let words = contents.split(separator: "\n")

        for word in words {
            if word.count == 5 && !word.contains("'") && !word.contains("é"){
                fiveLetterWords.append(word.uppercased())
            }
        }

        let selectedAnswer = fiveLetterWords.randomElement()!
        for c in selectedAnswer {
            answer.append(c)
        }
        
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
    
    // This function makes a rectangle, with other customizeable options, such as appearance factors and an option to include a letter
    func makeRectangle(to canvas: Canvas, rect: Rect, fillMode: FillMode = .stroke,
                       strokeStyle: StrokeStyle = StrokeStyle(color: Color(.black)),
                       lineWidth: LineWidth = LineWidth(width: 1),
                       fillStyle: FillStyle = FillStyle(color: Color(.black)),
                       letter: Character? = nil) {
        
        canvas.render(strokeStyle, lineWidth, fillStyle, Rectangle(rect: rect, fillMode: fillMode))

        if letter != nil { // include text that is centered on the button
             let textLocation = returnCenter(rect: rect) + Point(x: 0, y: 5)
              
             let text = Text(location: textLocation, text: String(letter!))
              let textFillStyle = FillStyle(color: Color(.black))
              text.font = "15pt Helvetica"
              text.alignment = Text.Alignment.center
              text.baseline = Text.Baseline.middle              
              canvas.render(textFillStyle, text)
          }          

    }

    // This function makes a row of renctangles, with the customizeable options, such as appearance factors and an option to include a letter
    func renderRow(to canvas: Canvas, count: Int, spacing: Int, rect: Rect, fillMode: FillMode = .stroke,
                 strokeStyle: StrokeStyle = StrokeStyle(color: Color(.black)),
                 lineWidth: LineWidth = LineWidth(width: 1),
                 fillStyle: FillStyle = FillStyle(color: Color(.black)),
                 letters: [Character?] = [nil], colors: [Color.Name?] = [nil]) {
        var fillColor = fillStyle
        var rectText = letters
        var rectColors = colors
        while rectText.count != count {
            rectText.append(nil)
        }
        while rectColors.count != count {
            rectColors.append(nil)
        }
                
        for i in 0 ..< count {
            if rectColors[i] != nil {
                fillColor = FillStyle(color: Color(rectColors[i]!))
            }
            makeRectangle(to: canvas, rect: Rect(topLeft: Point(x: rect.topLeft.x + spacing * i + rect.size.width * i, y: rect.topLeft.y),
                                                 size: Size(width: rect.size.width, height: rect.size.height)),
                          fillMode: fillMode, strokeStyle: strokeStyle, lineWidth: lineWidth, fillStyle: fillColor,
                          letter: rectText[i])
        }
        
    }

    // This function makes a grid, either from a topLeft point generating down and right, or from a center point
    func renderGrid(to canvas: Canvas, rowCount: Int, columnCount: Int, spacing: Int, rect: Rect, fillMode: FillMode = .stroke,
                  strokeStyle: StrokeStyle = StrokeStyle(color: Color(.black)),
                  lineWidth: LineWidth = LineWidth(width: 1),
                  fillStyle: FillStyle = FillStyle(color: Color(.black))) {
        for i in 0 ..< rowCount { // Spacing between columns in renderRow, spacing between rows in renderGrid 
            renderRow(to: canvas, count: columnCount, spacing: spacing, rect: Rect(topLeft: Point(x: rect.topLeft.x, y: rect.topLeft.y + (spacing * i) + (rect.size.height * i)), size: Size(width: rect.size.width, height: rect.size.height)), fillMode: fillMode, strokeStyle: strokeStyle, lineWidth: lineWidth, fillStyle: fillStyle)
            
        }    
        
    }

        func renderText(to canvas: Canvas, location: Point, text: String, font: String) {
        let text = Text(location: location, text: text)
        text.font = font

        let fillStyle = FillStyle(color: Color(.black))

        canvas.render(fillStyle, text)
    }


    // Function that adds rounded corners to a rectangle, with a title in the center
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

      // Function that renders a tow of buttons each with its own name
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

      // Returns an array of colors used for answers in wordle
      func returnColorSequence(answer: [Character?], guess: [Character?]) -> [Color.Name?] {
          var answerArray = answer
         
          var colorSequence : [Color.Name?] = [nil, nil, nil, nil, nil]
          for i in 0 ..< guess.count {
              if guess[i]! == answerArray[i] {
                  colorSequence[i] = .mediumseagreen
                  answerArray[i] = nil // Remove the green letter from the answer to account for green letters
              }
          }
              for i in 0 ..< guess.count {
                  if answerArray.contains(guess[i]!)  && colorSequence[i] != .green {
                      colorSequence[i] = .darkkhaki
                  }
              }          
          for i in 0 ..< colorSequence.count {
              if colorSequence[i] == nil {
                  colorSequence[i] = .gray
              }
          }
          return colorSequence
      }

    // Override Functions:

    override func setup(canvasSize: Size, canvas: Canvas) {
        if let canvasSize = canvas.canvasSize {
            // Clear the title screen from canvas
            clearCanvas(canvas: canvas)
            let background = Rect(size: canvasSize)

            do {
                try pullWords()
            } catch {
                fatalError("Unable to obtain dictionary")
            }

            print(answer)
            
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
            buttons.append(enterButton)
            let deleteButton = Rect(topLeft: Point(x: zButton.topLeft.x + canvasScaleFactor * 42, y: zButton.topLeft.y), size: Size(width: canvasScaleFactor * 15 / 2, height: canvasScaleFactor * 7))
            renderButton(to: canvas, rect: deleteButton, fillMode: .fill, radius: canvasScaleFactor / 2)
            buttons.append(deleteButton)
            rect = background
         
        }
        
        dispatcher.registerEntityMouseClickHandler(handler:self)
    }

    override func render(canvas: Canvas) {
        if let canvasSize = canvas.canvasSize {
            
            if guessCount != 6 && !victory {
            let midpoint = returnCenter(rect: Rect(size: canvasSize))
            let canvasScaleFactor = canvasSize.height / 90
            let wordleAnswerBoxSize = Size(width: canvasScaleFactor * 7, height: canvasScaleFactor * 7)
            let spacing = canvasScaleFactor
            // Multiply width of each box by number of columns, and spacing by number of columns minus one, similar for height
            let wordleGridSize = Size(width: (wordleAnswerBoxSize.width * 5) + (spacing * 4), height: (wordleAnswerBoxSize.height * 6) + (spacing * 5))
            let wordleGridCenterPoint = Point(x: midpoint.x, y: canvasSize.height) - Point(x: 0, y: canvasScaleFactor * 54)
            let wordleGridRect = returnCenteredRect(rect: Rect(size: wordleGridSize), center: wordleGridCenterPoint)            

            
            let darkgrayStrokeStyle = StrokeStyle(color: Color(.black))
            let whiteFillStyle = FillStyle(color: Color(.white))
            let rowTopLeft = wordleGridRect.topLeft + Point(x: 0, y: (guessCount * canvasScaleFactor * 8))
            renderRow(to: canvas, count: 5, spacing: spacing, rect: Rect(topLeft: rowTopLeft, size: wordleAnswerBoxSize), fillMode: .fillAndStroke, strokeStyle: darkgrayStrokeStyle, fillStyle: whiteFillStyle, letters: currentGuess)

            func characterArrayToString (array: [Character?]) -> String {
                var string = ""
                for c in array {
                    string.append(String(c!))
                }
                return string
            }

            if entered {
                let answerWord = characterArrayToString(array: answer)
                let guessWord = characterArrayToString(array: currentGuess)
                print("Answer: \(answerWord), Guess: \(guessWord)")
                if currentGuess.count == answer.count  && !currentGuess.contains(nil) {


                    if fiveLetterWords.contains(guessWord) {
                        renderRow(to: canvas, count: 5, spacing: spacing, rect: Rect(topLeft: rowTopLeft, size: wordleAnswerBoxSize), fillMode: .fillAndStroke, strokeStyle: darkgrayStrokeStyle, fillStyle: whiteFillStyle, letters: currentGuess, colors: returnColorSequence(answer: answer, guess: currentGuess))
                        if returnColorSequence(answer: answer, guess: currentGuess) == [.mediumseagreen,.mediumseagreen,.mediumseagreen,.mediumseagreen,.mediumseagreen,] {
                            victory = true
                            
                            
                        }
                        
                        currentGuess = [Character?]()
                        guessCount += 1
                    } else {
                        print("Not a real word.")
                    }
                    

                }


                entered = false
            }

            // renderButtonRow(to: canvas, rect: Rect, fillMode: FillMode, radius: Int, columnCount: Int, spacing: Int)
            }
            if victory == true {
                let midpoint = returnCenter(rect: Rect(size: canvasSize))
                let canvasScaleFactor = canvasSize.height / 90
                let wordleAnswerBoxSize = Size(width: canvasScaleFactor * 7, height: canvasScaleFactor * 7)
                let spacing = canvasScaleFactor
                let darkgrayStrokeStyle = StrokeStyle(color: Color(.black))
                let whiteFillStyle = FillStyle(color: Color(.white))
                let winRowRect = returnCenteredRect(rect: Rect(size: Size(width: wordleAnswerBoxSize.width * 5 + spacing * 4, height: wordleAnswerBoxSize.height)), center: midpoint)
                let victoryPage = Rect(size: canvasSize)
                canvas.render(FillStyle(color: Color(.green)), Rectangle(rect: victoryPage, fillMode: .fill))
                renderRow(to: canvas, count: 5, spacing: spacing, rect: Rect(topLeft: winRowRect.topLeft, size: wordleAnswerBoxSize), fillMode: .fillAndStroke, strokeStyle: darkgrayStrokeStyle, fillStyle: whiteFillStyle, letters: answer, colors: returnColorSequence(answer: answer, guess: answer))                    
                if frame / 60 == 1 {
                    animationBool = !animationBool

                }
                if animationBool {
                    renderText(to: canvas, location: Point(x: midpoint.x, y: midpoint.y / 2), text: "YOU WIN!!", font: "80pt Arial")
                } else {
                    renderText(to: canvas, location: Point(x: midpoint.x, y: midpoint.y * 3 / 2), text: "YOU WIN!!", font: "80pt Arial")
                }
                frame = (frame + 1) % 61
                print(frame)
                print(animationBool)
            }
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

          if characterNumber != nil {
              var addLetter : Character = "."
              switch characterNumber { // Switch scenes to each game scene
              case 0:
                  addLetter = "Q"
              case 1:
                  addLetter = "W"
              case 2:
                  addLetter = "E"
              case 3:
                  addLetter = "R"
              case 4:
                  addLetter = "T"
              case 5:
                  addLetter = "Y"
              case 6:
                  addLetter = "U"
              case 7:
                  addLetter = "I"
              case 8:
                  addLetter = "O"
              case 9:
                  addLetter = "P"
              case 10:
                  addLetter = "A"
              case 11:
                  addLetter = "S"
              case 12:
                  addLetter = "D"
              case 13:
                  addLetter = "F"
              case 14:
                  addLetter = "G"
              case 15:
                  addLetter = "H"
              case 16:
                  addLetter = "J"
              case 17:
                  addLetter = "K"
              case 18:
                  addLetter = "L"
              case 19:
                  addLetter = "Z"
              case 20:
                  addLetter = "X"
              case 21:
                  addLetter = "C"
              case 22:
                  addLetter = "V"
              case 23:
                  addLetter = "B"
              case 24:
                  addLetter = "N"
              case 25:
                  addLetter = "M"
              case 26:
                  if currentGuess.count == 5 {                      
                      entered = true
                  }
              case 27:
                  if currentGuess.count != 0 {
                      currentGuess.remove(at: currentGuess.count - 1)
                  }
              default:
                  fatalError("Button does not exist")
              }
              if currentGuess.count < 5 && addLetter != "."{
                  currentGuess.append(addLetter)
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

