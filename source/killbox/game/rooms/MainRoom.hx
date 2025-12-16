package killbox.game.rooms;

class MainRoom extends Room
{
	override function setupRoom():Void
	{     
		var coolSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFFB43C3C);
		add(coolSprite);   
        
		var textFart = new FlxText(0, 0, 0, 'this is the main room !');
		textFart.screenCenter();
		add(textFart);
        
        possibleMovements = [
            LEFT => 'left',
            UP => 'ceiling',
            RIGHT => 'right',
        ];
    }
}