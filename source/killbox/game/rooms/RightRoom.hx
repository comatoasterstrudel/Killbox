package killbox.game.rooms;

class RightRoom extends Room
{
    override function setupRoom():Void{        
		var coolSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFFAA6CB3);
		add(coolSprite);   
        
		var textFart = new FlxText(0, 0, 0, 'this is the right room !');
		textFart.screenCenter();
		add(textFart);
        
        possibleMovements = [
            LEFT => 'main'
        ];
    }
}