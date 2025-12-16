package killbox.game.rooms;

class LeftRoom extends Room
{
	var bgBack:FlxSprite;
	var bgFront:FlxSprite;
    
    override function setupRoom():Void{        
		bgBack = new FlxSprite().loadGraphic('assets/images/night/roomLeft/leftRoomBack.png');
		bgBack.screenCenter();
		bgBack.scrollFactor.set(0, 0);
		add(bgBack);  
        
		bgFront = new FlxSprite().loadGraphic('assets/images/night/roomLeft/leftRoomPlaceholder.png');
		bgFront.screenCenter();
		add(bgFront);  

        possibleMovements = [
            RIGHT => 'main'
        ];
    }
	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		bgBack.scrollFactor.set(0.8, 0.8);
	}
}