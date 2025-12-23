package killbox.game.rooms.right;

class RightRoom extends Room
{
	var bgBack:FlxSprite;
	var bgTube:FlxSprite;
	var bgFront:FlxSprite;
    
    override function setupRoom():Void{        
		bgBack = new FlxSprite().loadGraphic('assets/images/night/rooms/right/rightRoomBg.png');
		bgBack.screenCenter();
		add(bgBack);

		bgTube = new FlxSprite().loadGraphic('assets/images/night/rooms/right/rightRoomTube.png');
		bgTube.screenCenter();
		add(bgTube);

		bgFront = new FlxSprite().loadGraphic('assets/images/night/rooms/right/rightRoomFrontDesk.png');
		bgFront.screenCenter();
		add(bgFront);  
        
        possibleMovements = [
            LEFT => 'main'
        ];
    }
	override function update(elapsed:Float):Void {
		super.update(elapsed);

		bgBack.scrollFactor.set(0.6, 0.6);
		bgTube.scrollFactor.set(0.8, 0.8);
	}
}