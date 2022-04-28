
import Foundation
import Scenes
import Igis

class Letter :  RenderableEntity {

    let letter : Character
    var currentPoint : Point
    let path : Path
    let scaler : Int
    
    init(character: Character, start: Point, scale: Int) {
        letter = character
        currentPoint = start
        scaler = scale
        path = Path(fillMode: .fillAndStroke)
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Letter")        
    }

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
    func lineToCardinal(path: Path, currentPoint: inout Point, by: Point) {
        currentPoint += by
        path.lineTo(currentPoint)
        
    }
    
    func drawA(path: Path, point: Point, scale: Int) {
        // Start of Development = bottomLeft of Left Leg
        let startingPoint = point
        var currentPoint = point
        path.moveTo(currentPoint)

        // Look into turtle graphics because they might have more precision (they use DoublePoint)
        
        lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale * 2, y: 0))
        lineToDiagonal(path: path, currentPoint: &currentPoint, length: scale * 2, angle: 165)
        lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale * 2, y: 0))
        lineToDiagonal(path: path, currentPoint: &currentPoint, length: scale * 2, angle: 15)
        lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale * 2, y: 0))
        lineToDiagonal(path: path, currentPoint: &currentPoint, length: scale * 8, angle: 195)
        lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale * -3, y: 0))
        lineToDiagonal(path: path, currentPoint: &currentPoint, length: scale * 8, angle: 345)        

        path.lineTo(startingPoint)        
    }
    func drawB(path: Path, point: Point, scale: Int) {

    }
    func drawC(path: Path, point: Point, scale: Int) {

    }
    func drawD(path: Path, point: Point, scale: Int) {
        // Start of Development = Top Left of D
        let startingPoint = point
        var currentPoint = point
        path.moveTo(currentPoint)

        lineToCardinal(path: path, currentPoint: &currentPoint, by: Point(x: scale * 1, y: 0))
        currentPoint -= Point(x: 0, y: -3 * scale)
        path.moveTo(currentPoint + Point(x: scale * 2, y:0)) //Move to start angle of arc
        path.arc(center: currentPoint, radius: scale * 2, startAngle:, endAngle:)
        
    }
    func drawE(path: Path, point: Point, scale: Int) {
        // Start of Development = Top Left of E
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
    }
    func drawF(path: Path, point: Point, scale: Int) {

    }
    func drawG(path: Path, point: Point, scale: Int) {

    }
    func drawH(path: Path, point: Point, scale: Int) {

    }
    func drawI(path: Path, point: Point, scale: Int) {

    }
    func drawJ(path: Path, point: Point, scale: Int) {

    }
    func drawK(path: Path, point: Point, scale: Int) {

    }
    func drawL(path: Path, point: Point, scale: Int) {

    }
    func drawM(path: Path, point: Point, scale: Int) {
      // Start of Development = Top Left of M
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
    }
    func drawN(path: Path, point: Point, scale: Int) {

    }
    func drawO(path: Path, point: Point, scale: Int) {
        // Start of Development = Top of O
        let startingPoint = point        

        path.arc(center: startingPoint, radius: scale * 2)
        path.moveTo(startingPoint + Point(x: scale * 3, y: 0))
        path.arc(center: startingPoint, radius: scale * 3, antiClockwise: true)
        
        path.moveTo(startingPoint)
    }
    func drawP(path: Path, point: Point, scale: Int) {

    }
    func drawQ(path: Path, point: Point, scale: Int) {

    }
    func drawR(path: Path, point: Point, scale: Int) {

    }
    func drawS(path: Path, point: Point, scale: Int) {

    }
    func drawT(path: Path, point: Point, scale: Int) {
        // Start of Development = Top Left of T
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
    }    
    func drawU(path: Path, point: Point, scale: Int) {

    }
    func drawV(path: Path, point: Point, scale: Int) {

    }
    func drawW(path: Path, point: Point, scale: Int) {

    }
    func drawX(path: Path, point: Point, scale: Int) {

    }
    func drawY(path: Path, point: Point, scale: Int) {

    }
    func drawZ(path: Path, point: Point, scale: Int) {

    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        switch letter {
        case "a":
            drawA(path: path, point: currentPoint, scale: scaler)
        case "b":
            drawB(path: path, point: currentPoint, scale: scaler)
        case "c":
            drawC(path: path, point: currentPoint, scale: scaler)
        case "d":
            drawD(path: path, point: currentPoint, scale: scaler)
        case "e":
            drawE(path: path, point: currentPoint, scale: scaler)
        case "f":
            drawF(path: path, point: currentPoint, scale: scaler)
        case "g":
            drawG(path: path, point: currentPoint, scale: scaler)
        case "h":
            drawH(path: path, point: currentPoint, scale: scaler)
        case "i":
            drawI(path: path, point: currentPoint, scale: scaler)
        case "j":
            drawJ(path: path, point: currentPoint, scale: scaler)
        case "k":
            drawK(path: path, point: currentPoint, scale: scaler)
        case "l":
            drawL(path: path, point: currentPoint, scale: scaler)
        case "m":
            drawM(path: path, point: currentPoint, scale: scaler)
        case "n":
            drawN(path: path, point: currentPoint, scale: scaler)
        case "o":
            drawO(path: path, point: currentPoint, scale: scaler)
        case "p":
            drawP(path: path, point: currentPoint, scale: scaler)
        case "q":
            drawQ(path: path, point: currentPoint, scale: scaler)
        case "r":
            drawR(path: path, point: currentPoint, scale: scaler)
        case "s":
            drawS(path: path, point: currentPoint, scale: scaler)
        case "t":
            drawT(path: path, point: currentPoint, scale: scaler)
        case "u":
            drawU(path: path, point: currentPoint, scale: scaler)
        case "v":
            drawV(path: path, point: currentPoint, scale: scaler)
        case "w":
            drawW(path: path, point: currentPoint, scale: scaler)
        case "x":
            drawX(path: path, point: currentPoint, scale: scaler)
        case "y":
            drawY(path: path, point: currentPoint, scale: scaler)
        case "z":
            drawZ(path: path, point: currentPoint, scale: scaler)
        default:
            print("Not a valid character")                          
        }
        canvas.render(path)
    }
    
    
}
