package killbox.game.rooms;

class MainRoom extends Room
{
	var bgBack:FlxSprite;
	var bgFront:FlxSprite;
	
	override function setupRoom():Void
	{     
		bgBack = new FlxSprite().loadGraphic('assets/images/night/roomMain/mainRoomPlaceholderBack.png');
		bgBack.screenCenter();
		bgBack.scrollFactor.set(0, 0);
		add(bgBack);  
        
		bgFront = new FlxSprite().loadGraphic('assets/images/night/roomMain/mainRoomPlaceholder.png');
		bgFront.screenCenter();
		add(bgFront);  

        possibleMovements = [
            LEFT => 'left',
            UP => 'ceiling',
            RIGHT => 'right',
        ];
    }
	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		bgBack.scrollFactor.set(0.6, 0.6);
	}
}