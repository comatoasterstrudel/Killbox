package killbox.game.pause;

/**
 * the substate that appears when you pause the game
 */
class PauseSubState extends FlxSubState
{   
    /**
     * camera
     */
    var camPause:FlxCamera;
    
    /**
     * sprites
     */
    var bg:KbSprite;
    
    /**
     * the buttons for the pause menu
     */
    var buttons:FlxTypedGroup<PauseButton>;
    
    /**
     * the options for this pause menu
     */
    var options:Array<PauseOption> = [];
    
    public function new(options:Array<PauseOption>):Void{
        super();
        
        this.options = options;
        
        camPause = new FlxCamera();
        camPause.bgColor.alpha = 0;
        FlxG.cameras.add(camPause, false);
        
        bg = new KbSprite().createColorBlock(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = .85;
        bg.camera = camPause;
        add(bg);
        
        buttons = new FlxTypedGroup<PauseButton>();
        buttons.camera = camPause;
        add(buttons);
        
        var y:Float = 250;
        
        for(i in 0...options.length){
            var button = new PauseButton(y, options[i], this);
            buttons.add(button);
            
            y += 50;
        }
    }
}