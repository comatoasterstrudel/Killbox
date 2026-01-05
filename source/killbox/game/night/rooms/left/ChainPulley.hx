package killbox.game.night.rooms.left;

/**
 * the chain pulley in the left room that triggers the box press
 * think of a train horn!
 */
class ChainPulley extends FlxSpriteGroup
{   
    /**
     * sprites
     */
    public var pressChain:KbSprite;
	public var pressHandle:KbSprite;
	
	/**
	 * was the press handle clicked on and are you holding the mouse?
	 */
	public var pressHandlePressed:Bool = false;
	
	/**
	 * the y position you pulled the handle at 
	 */
	public var pressHandlePressedY:Float = 0;
	
	/**
	 * is the press handle all the way down?
	 */
	public var pressHandleDown:Bool = false;
	
	/**
	 * is the press handle going back up after being pulled down?
	 */
	public var pressHandleWindingBack:Bool = false;
	
	/**
     * function to call when the pulley is pressed down
     */
    var pressedDown:Void->Void;
    
    public function new(pressedDown:Void->Void):Void{
        super();
        
        this.pressedDown = pressedDown;
        
        pressChain = new KbSprite().createColorBlock(20, 400, 0xFF212121);
		add(pressChain);
		
		pressHandle = new KbSprite(0, Constants.CHAIN_PULLEY_BASE_PRESS_HANDLE_POSITION).createColorBlock(200, 40, 0xFFD5C5C5);
		pressHandle.lerpManager.lerpY = true;
		pressHandle.lerpManager.lerpSpeed = 5;
		add(pressHandle);
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);

		if(pressHandleDown){
			pressHandle.color = 0xFFE37171;
			pressHandlePressed = false;
			pressHandle.lerpManager.targetPosition.y = Constants.CHAIN_PULLEY_BASE_PRESS_HANDLE_POSITION + Constants.CHAIN_PULLEY_PRESS_DOWN_POSITION_ADDITIVE;
		} else if(pressHandleWindingBack){
			pressHandle.color = 0xFFC39191;
			pressHandle.lerpManager.targetPosition.y = Constants.CHAIN_PULLEY_BASE_PRESS_HANDLE_POSITION;
			if(pressHandle.y <= (Constants.CHAIN_PULLEY_BASE_PRESS_HANDLE_POSITION + 4)){
				pressHandleWindingBack = false;
			}
		} else {
			if (Cursor.mouseIsTouching(pressHandle) && PlayState.curRoom == 'left' || pressHandlePressed && PlayState.curRoom == 'left') {
				pressHandle.color = 0xFF806666;
				
				if(FlxG.mouse.pressed && !pressHandlePressed){
					pressHandlePressed = true;
					pressHandlePressedY = FlxG.mouse.y;
				}
			} else {
				pressHandle.color = 0xFFD5C5C5;
			}

		
			if(pressHandlePressed){
				if (!FlxG.mouse.pressed || PlayState.curRoom != 'left') {
					pressHandlePressed = false;
				} else {				
					pressHandle.lerpManager.targetPosition.y = Constants.CHAIN_PULLEY_BASE_PRESS_HANDLE_POSITION + (Constants.CHAIN_PULLEY_PRESS_DOWN_POSITION_ADDITIVE * FlxMath.bound((FlxG.mouse.y - pressHandlePressedY) / (FlxG.height / 2.5), 0, 1));

					if(pressHandle.y > Constants.CHAIN_PULLEY_BASE_PRESS_HANDLE_POSITION + (Constants.CHAIN_PULLEY_PRESS_DOWN_POSITION_ADDITIVE - 10)){ // the handle is pulled down enough..
						pressHandleDown = true;
						pressedDown();
						new FlxTimer(PlayState.timerManager).start(GameValues.getPressSpeed(), function(f):Void{
							pressHandleDown = false;
							pressHandleWindingBack = true;
						});
					}	
				}
			} else {
				pressHandle.lerpManager.targetPosition.y = Constants.CHAIN_PULLEY_BASE_PRESS_HANDLE_POSITION;
			}	
		} 
		
		updateChainPulleyPosition();
	}
    
    /**
     * call this to snap the sprites according to the press handle
     */
    function updateChainPulleyPosition():Void{
		pressChain.x = 550;
		pressHandle.x = pressChain.x + pressChain.width / 2 - pressHandle.width / 2;
		pressChain.y = pressHandle.y - pressChain.height + pressHandle.height;
        
        pressChain.scrollFactor.set(1.45, 1.45);
		pressHandle.scrollFactor.set(1.45, 1.45);
	}
}