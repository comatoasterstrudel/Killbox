package killbox.game.pause;

/**
 * the buttons that appear on the pause menu
 */
class PauseButton extends KbText
{
    /**
     * the option this button is tied tp
     */
    var option:PauseOption;
    
    /**
     * the substate that this button is on
     */
    var pauseSubState:PauseSubState;
    
    public function new(y:Float, option:PauseOption, pauseSubState:PauseSubState):Void{
        super(0, y, 0, option.name, 20);
        
        screenCenter(X);
        
        this.option = option;        
        this.pauseSubState = pauseSubState;
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        if(FlxG.mouse.overlaps(this)){
            color = FlxColor.WHITE;
            
            if(FlxG.mouse.justPressed){
                pressButton();
            }
        } else {
            color = FlxColor.GRAY;
        }
        
        if(FlxG.keys.justPressed.ESCAPE && option.pressEscape) pressButton();
    }
    
    /**
     * call this when the button should be pressed
     */
    function pressButton():Void{
        option.onClick();
        if(option.close) pauseSubState.close();
    }
}