package killbox.game.night.ui.movement;

class MovementUI extends FlxTypedGroup<MovementBar>
{
    var movementBars:Array<MovementBar> = [];
    
    public var possibleMovements:Map<MovementTypes, String> = [];
    public var changeRoom:String->Void;
    
    public function new(changeRoom:String->Void):Void{
        super();
        
        this.changeRoom = changeRoom;
        
        var left = new MovementBar(LEFT, this);
        add(left);
        
        var right = new MovementBar(RIGHT, this);
        add(right);
        
        var down = new MovementBar(DOWN, this);
        add(down);
        
        var up = new MovementBar(UP, this);
        add(up);
        
        movementBars = [left, right, down, up];
    }
    
    public function updateActiveButtons(possibleMovements:Map<MovementTypes, String>):Void{
        this.possibleMovements = possibleMovements;
        
        for(i in movementBars){
            i.changeButtonStatus(this.possibleMovements.exists(i.movementType));
        }
    }
    
    public function hide():Void{
        for(i in movementBars){
            i.changeButtonStatus(false);
        }
    }
}