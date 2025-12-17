package killbox.game.movement;

class MovementBar extends FlxSprite 
{
    public var movementType:MovementTypes;
    
    final buttonSpacing:Float = 30;
    
    var buttonActive:Bool = false;
    
    var cooldown:Bool = false;
    
    var movementUI:MovementUI;
    
    public function new(movementType:MovementTypes, movementUI:MovementUI){
        super();
        
        this.movementType = movementType;
        this.movementUI = movementUI;
        
		loadGraphic('assets/images/night/movement.png');
		setGraphicSize(Std.int(width * .7));
		updateHitbox();
		screenCenter();
                
        alpha = .4;
        
        switch(movementType){
            case LEFT:
				angle = 90;
                x -= ((FlxG.width / 2) - buttonSpacing);
            case RIGHT:
				angle = 270;
                x += ((FlxG.width / 2) - buttonSpacing); 
            case UP:
                angle = 180;
                y -= ((FlxG.height / 2) - buttonSpacing); 
            case DOWN:
                angle = 0;
                y += ((FlxG.height / 2) - buttonSpacing); 
        }
    } 
    
    public function changeButtonStatus(buttonActive:Bool):Void{
        this.buttonActive = buttonActive;
        
        visible = this.buttonActive;
    }
    
    override function update(elapsed:Float) {
        super.update(elapsed);
     
		if (buttonActive && Cursor.mouseIsTouching(this))
		{
            if(cooldown){
                alpha = .1;
            } else {
                movementUI.changeRoom(movementUI.possibleMovements.get(movementType));   
                cooldown = true;             
            }
		}
		else if (cooldown && buttonActive && !Cursor.mouseIsTouching(this, false))
		{
            cooldown = false;
            alpha = .4;
        }
    }
}