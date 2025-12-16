package killbox.game.rooms;

class LeftRoom extends Room
{
    override function setupRoom():Void{        
        var coolSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFFFFFFFF);
        add(coolSprite);
        
        possibleMovements = [
            RIGHT => 'main'
        ];
    }
}