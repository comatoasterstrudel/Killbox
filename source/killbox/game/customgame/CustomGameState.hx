package killbox.game.customgame;

/**
 * the state where you can customize the games stats and make your own level
 */
class CustomGameState extends FlxState
{
    var topText:KbText;
    
    public function new():Void{
        super();
    }
    
    override function create():Void{
        super.create();
        
            
        topText = new KbText(0,50, 0, 'Custom Game', 30);
        topText.screenCenter(X);
        add(topText);
    }
}