package killbox.util;

class Cursor extends FlxSprite
{
    public function new():Void{
        super();
        
        makeGraphic(6, 6, FlxColor.RED);
        
        updateCursorPosition();
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        updateCursorPosition();
    }
    
    function updateCursorPosition():Void{
        visible = false;
        scrollFactor.set(1,1);
        x = FlxG.mouse.x - 3;
        y = FlxG.mouse.y - 3;
        camera = FlxG.cameras.list[FlxG.cameras.list.length - 1];
    }
    
    public static function mouseIsTouching(sprite:FlxSprite, pixelPerfect:Bool = true):Bool{
        var thecursor = Main.cursor;
        
        thecursor.updateCursorPosition();
        
        return pixelPerfect ? FlxG.pixelPerfectOverlap(sprite, thecursor, 10) : FlxG.overlap(sprite, thecursor);
    }
}