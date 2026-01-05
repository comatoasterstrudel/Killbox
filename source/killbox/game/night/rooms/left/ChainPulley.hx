package killbox.game.night.rooms.left;

class ChainPulley extends FlxSpriteGroup
{
    var pressedDown:Void->Void;
    
    public var pressChain:FlxSprite;
	public var pressHandle:FlxSprite;
	
	public var pressHandlePressed:Bool = false;
	public var pressHandlePressedY:Float = 0;
	public var pressHandleDown:Bool = false;
	public var pressHandleWindingBack:Bool = false;
    
    public function new(pressedDown:Void->Void):Void{
        super();
        
        this.pressedDown = pressedDown;
        
        pressChain = new FlxSprite().makeGraphic(20, 400, 0xFF212121);
		add(pressChain);
		
		pressHandle = new FlxSprite(0, Constants.CHAIN_PULLEY_BASE_PRESS_HANDLE_POSITION).makeGraphic(200, 40, 0xFFD5C5C5);
		add(pressHandle);
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);

		if(pressHandleDown){
			pressHandle.color = 0xFFE37171;
			pressHandlePressed = false;
			pressHandle.y = Utilities.lerpThing(pressHandle.y, Constants.CHAIN_PULLEY_BASE_PRESS_HANDLE_POSITION + Constants.CHAIN_PULLEY_PRESS_DOWN_POSITION_ADDITIVE, elapsed, 5);
		} else if(pressHandleWindingBack){
			pressHandle.color = 0xFFC39191;
			pressHandle.y = Utilities.lerpThing(pressHandle.y, Constants.CHAIN_PULLEY_BASE_PRESS_HANDLE_POSITION, elapsed, 2);
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
					pressHandle.y = Utilities.lerpThing(pressHandle.y, Constants.CHAIN_PULLEY_BASE_PRESS_HANDLE_POSITION + (Constants.CHAIN_PULLEY_PRESS_DOWN_POSITION_ADDITIVE * FlxMath.bound((FlxG.mouse.y - pressHandlePressedY) / (FlxG.height / 2.5), 0, 1)), elapsed, 5);
				
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
				pressHandle.y = Utilities.lerpThing(pressHandle.y, Constants.CHAIN_PULLEY_BASE_PRESS_HANDLE_POSITION, elapsed, 5);
			}	
		} 
		
		updateChainPulleyPosition();
	}
    
    function updateChainPulleyPosition():Void{
		pressChain.x = 550;
		pressHandle.x = pressChain.x + pressChain.width / 2 - pressHandle.width / 2;
		pressChain.y = pressHandle.y - pressChain.height + pressHandle.height;
        
        pressChain.scrollFactor.set(1.45, 1.45);
		pressHandle.scrollFactor.set(1.45, 1.45);
	}
}