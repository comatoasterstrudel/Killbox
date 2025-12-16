package killbox.game.rooms;

class RightRoom extends Room
{
    override function setupRoom():Void{        
        var coolSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFFFFFFFF);
        add(coolSprite);
        
        possibleMovements = [
            LEFT => 'main'
        ];
    }
}