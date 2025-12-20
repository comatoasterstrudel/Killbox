package killbox;

class InitState extends FlxState{
    override function create():Void{
        bgColor = FlxColor.BLACK;
                
        // initialize the cursor! 
        initCursor();
        
        // start the game !!
        FlxG.switchState(#if release Constants.INITIAL_STATE_RELEASE #end #if debug Constants.INITIAL_STATE_DEBUG #end);
    }
    
    /**
     * the cursor used for pixel perfect mouse detection across the whole game
     */
    public static var cursor:Cursor;
    
    /**
     * initialize the cursor! 
     */
    function initCursor():Void{
        FlxG.mouse.useSystemCursor = true;
        
		cursor = new Cursor();
		FlxG.plugins.addPlugin(cursor);
		FlxG.plugins.drawOnTop = true;
    }
}