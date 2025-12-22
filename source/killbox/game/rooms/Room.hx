package killbox.game.rooms;

class Room extends FlxSpriteGroup
{
    var playState:PlayState;
    
    public var roomActive:Bool = false;
    
	public var possibleMovements:Map<MovementTypes, String> = [];
    
    public function new(playState:PlayState){
        super();
        this.playState = playState;
        
        setupRoom();
    }
    
    function setupRoom():Void{
        //    
    }
    
	public function sendBox(id:Int, boxSendType:BoxSendType):Void
	{
		//
	}
    
    public static function getRoomFromName(room:String, playState:PlayState):Room
    {
        switch(room){
            case 'main':
                return new MainRoom(playState);
            case 'left':
                return new LeftRoom(playState);
            case 'right':
                return new RightRoom(playState);
			case 'top':
				return new TopRoom(playState);
            default: 
                return new Room(playState);
        }
    }
	public function toggleRoomVisibility():Void
	{
		visible = roomActive;
	}
}