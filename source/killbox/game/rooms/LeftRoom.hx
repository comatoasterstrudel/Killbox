package killbox.game.rooms;

class LeftRoom extends Room
{
	var bgBack:FlxSprite;
	var bgFront:FlxSprite;
    
	var pressChain:FlxSprite;
	var pressHandle:FlxSprite;
	
	var boxFrontConveyorSprites:FlxSpriteGroup;
	
	final BASE_PRESS_HANDLE_POSITION:Float = 100;
	final PRESS_DOWN_POSITION_ADDITIVE:Float = 200;
	
	var pressHandlePressed:Bool = false;
	var pressHandlePressedY:Float = 0;
	var pressHandleDown:Bool = false;
	var pressHandleWindingBack:Bool = false;
	
	var pressTop:FlxSprite;
	var pressBottom:FlxSprite;
	
	var boxCounterFront:BoxCounter;
	
    override function setupRoom():Void{        
		bgBack = new FlxSprite().loadGraphic('assets/images/night/roomLeft/leftRoomBack.png');
		bgBack.screenCenter();
		bgBack.scrollFactor.set(0, 0);
		add(bgBack);  
        
		bgFront = new FlxSprite().loadGraphic('assets/images/night/roomLeft/leftRoomPlaceholder.png');
		bgFront.screenCenter();
		add(bgFront);  

		boxFrontConveyorSprites = new FlxSpriteGroup();
		add(boxFrontConveyorSprites);
		
		pressTop = new FlxSprite().makeGraphic(215, 500, 0xFF1D1D1D);
		add(pressTop);
		
		pressBottom = new FlxSprite(0, 80).makeGraphic(270, 60, 0xFF303030);
		add(pressBottom);
		
		pressChain = new FlxSprite().makeGraphic(20, 400, 0xFF212121);
		add(pressChain);
		
		pressHandle = new FlxSprite(0, BASE_PRESS_HANDLE_POSITION).makeGraphic(200, 40, 0xFFD5C5C5);
		add(pressHandle);
	
		updatePressPosition();
		
		boxCounterFront = new BoxCounter(this, boxFrontConveyorSprites);
		boxCounterFront.camera = playState.camUI;
		add(boxCounterFront);
		
        possibleMovements = [
            RIGHT => 'main'
        ];
    }
	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		bgBack.scrollFactor.set(0.65, 0.65);
		
		handleFrontConveyor();
		handlePress(elapsed);
	}

	function handleFrontConveyor():Void{
		for(box in boxFrontConveyorSprites){
			var boxData = playState.getBoxByID(box.ID);

			if(boxData.status == LEFT_CONVEYOR){
				if(box.x < 200){
					box.velocity.x = 0;
					boxData.status = LEFT_SLIDING;
					FlxTween.tween(box, {x: 150}, 1, {ease: FlxEase.quartOut, onComplete: function(f):Void{
						boxData.status = LEFT_WAITING;
					}});
				}
			}
		}	
	}
	
	function handlePress(elapsed:Float):Void{
		pressChain.scrollFactor.set(1.45, 1.45);
		pressHandle.scrollFactor.set(1.45, 1.45);
		
		if(pressHandleDown){
			pressHandle.color = 0xFFE37171;
			pressHandlePressed = false;
			pressHandle.y = Utilities.lerpThing(pressHandle.y, BASE_PRESS_HANDLE_POSITION + PRESS_DOWN_POSITION_ADDITIVE, elapsed, 5);
		} else if(pressHandleWindingBack){
			pressHandle.color = 0xFFC39191;
			pressHandle.y = Utilities.lerpThing(pressHandle.y, BASE_PRESS_HANDLE_POSITION, elapsed, 2);
			if(pressHandle.y <= (BASE_PRESS_HANDLE_POSITION + 4)){
				pressHandleWindingBack = false;
			}
		} else {
			if(Cursor.mouseIsTouching(pressHandle) || pressHandlePressed){
				pressHandle.color = 0xFF806666;
				
				if(FlxG.mouse.pressed && !pressHandlePressed){
					pressHandlePressed = true;
					pressHandlePressedY = FlxG.mouse.y;
				}
			} else {
				pressHandle.color = 0xFFD5C5C5;
			}
		
			if(pressHandlePressed){
				if(!FlxG.mouse.pressed){
					pressHandlePressed = false;
				} else {
					pressHandle.y = Utilities.lerpThing(pressHandle.y, BASE_PRESS_HANDLE_POSITION + (PRESS_DOWN_POSITION_ADDITIVE * FlxMath.bound((FlxG.mouse.y - pressHandlePressedY) / (FlxG.height / 2.5), 0, 1)), elapsed, 5);
				
					if(pressHandle.y > BASE_PRESS_HANDLE_POSITION + (PRESS_DOWN_POSITION_ADDITIVE - 10)){ // the handle is pulled down enough..
						pressHandleDown = true;
						startPress();
						new FlxTimer().start(GameValues.getPressSpeed(), function(f):Void{
							pressHandleDown = false;
							pressHandleWindingBack = true;
						});
					}	
				}
			} else {
				pressHandle.y = Utilities.lerpThing(pressHandle.y, BASE_PRESS_HANDLE_POSITION, elapsed, 5);
			}	
		} 
		
		updatePressPosition();
	}
	
	function startPress():Void{
		FlxTween.tween(pressBottom, {y: 60 + 260}, GameValues.getPressSpeed() / 6, {ease: FlxEase.quartOut, onComplete: function(f):Void{
			FlxTween.tween(pressBottom, {y: 60}, GameValues.getPressSpeed() / 6, {startDelay: (GameValues.getPressSpeed() / 6) * 5, ease: FlxEase.quartOut, onComplete: function(f):Void{
				//
			}});
		}});
	}
	
	function updatePressPosition():Void{
		pressChain.x = 550;
		pressHandle.x = pressChain.x + pressChain.width / 2 - pressHandle.width / 2;
		pressChain.y = pressHandle.y - pressChain.height + pressHandle.height;
		
		pressTop.x = 100;
		pressBottom.x = pressTop.x + pressTop.width / 2 - pressBottom.width / 2;
		pressTop.y = pressBottom.y - pressTop.height;
	}
	
	override function sendBox(id:Int, boxSendType:BoxSendType):Void
	{
		if (boxSendType == MAIN_TO_LEFT)
		{
			addBoxToFront(id);
		}
	}

	function addBoxToFront(id:Int):Void
	{
		var box = new FlxSprite(FlxG.width, 270).makeGraphic(100, 100, 0xFF424242);
		box.ID = id;
		box.velocity.x = -GameValues.getConveyorSpeed();
		boxFrontConveyorSprites.add(box);

		playState.getBoxByID(id).status = LEFT_CONVEYOR;
	}
} 