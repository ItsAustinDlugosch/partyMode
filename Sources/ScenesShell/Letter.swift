import Scenes
import Igis

class Letter :  RenderableEntity {

    let letter : Character
    
    init(character: Character) {
        letter = character.self
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Letter")        
    }

    
    
}
