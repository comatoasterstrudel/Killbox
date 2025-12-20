package killbox.game.rooms.left;

class LeftRoom extends Room
{
	var bgBack:FlxSprite;
	var bgFront:FlxSprite;
    
	var boxPress:BoxPress;
	
	var chainPulley:ChainPulley;
	
	var boxFrontConveyorSprites:FlxSpriteGroup;
	
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
		
		boxPress = new BoxPress();
		add(boxPress);
		
		chainPulley = new ChainPulley(boxPress.startBoxPress);
		add(chainPulley);
				
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