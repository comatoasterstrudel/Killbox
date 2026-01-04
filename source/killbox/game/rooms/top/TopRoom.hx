package killbox.game.rooms.top;

import haxe.macro.Expr.ComplexType;

class TopRoom extends Room
{
	var bgBack:FlxSprite;
	var bgFront:FlxSprite;

	var wiresBack:FlxSprite;
	var wiresFront:FlxSprite;

	var computerMonitor:ComputerMonitor;
	var monitorFront:FlxSprite;

	var bottomTube:FlxSprite;
	var topTube:FlxSprite;

	var boxSprites:FlxSpriteGroup;

	var boxCounter:BoxCounter;

	var tubeShader:MaskAlphaShader;
	var tubeGradient:FlxSprite;
	
    override function setupRoom():Void{        
		bgBack = new FlxSprite().loadGraphic('assets/images/night/rooms/top/topRoomBack.png');
		bgBack.screenCenter();
		add(bgBack);

		bgFront = new FlxSprite().loadGraphic('assets/images/night/rooms/top/topRoomFront.png');
		bgFront.screenCenter();
		add(bgFront);

		bottomTube = new FlxSprite().loadGraphic('assets/images/night/rooms/top/topTube.png');
		add(bottomTube);

		tubeGradient = new FlxSprite().loadGraphic('assets/images/night/rooms/top/tubeGradient.png');
		tubeGradient.alpha = 0;
		add(tubeGradient);

		tubeShader = new MaskAlphaShader(tubeGradient, 'assets/images/night/rooms/top/tubeMask.png');

		tubeGradient.shader = tubeShader;
		
		boxSprites = new FlxSpriteGroup();
		add(boxSprites);

		topTube = new FlxSprite().loadGraphic('assets/images/night/rooms/top/topTube.png');
		add(topTube);

		boxCounter = new BoxCounter(this, boxSprites, 30);
		add(boxCounter);
		
		wiresBack = new FlxSprite().loadGraphic('assets/images/night/rooms/top/tvRoomWiresBack.png');
		wiresBack.screenCenter();
		add(wiresBack);

		wiresFront = new FlxSprite().loadGraphic('assets/images/night/rooms/top/tvRoomWiresFront.png');
		wiresFront.screenCenter();
		add(wiresFront);

		computerMonitor = new ComputerMonitor();
		add(computerMonitor);
        
		monitorFront = new FlxSprite().loadGraphic('assets/images/night/rooms/top/topRoomMonitor.png');
		monitorFront.screenCenter();
		add(monitorFront); 
        
		computerMonitor.pageFinishProduction.onConfirm.add(confirmBoxes);

		updateBoxesToConfirm();
		
        possibleMovements = [
            DOWN => 'main'
        ];
    }

	override function update(elapsed:Float):Void {
		super.update(elapsed);

		bgBack.scrollFactor.set(.8, .8);

		wiresBack.scrollFactor.set(1.1, 1.1);
		wiresFront.scrollFactor.set(1.2, 1.2);

		computerMonitor.scrollFactor.set(1.3, 1.3);
		monitorFront.scrollFactor.set(1.3, 1.3);
		bottomTube.scrollFactor.set(1.1, 1.1);
		topTube.scrollFactor.set(1.1, 1.1);
		boxSprites.scrollFactor.set(1.1, 1.1);

		if (roomActive) {
			#if debug
			if (FlxG.keys.justPressed.ONE) {
				var box = new Box(playState.getBoxID());
				playState.boxes.push(box);
				sendBox(box.ID, RIGHT_TO_TOP);
			}
			#end
		}
		manageTube();
		if (tubeGradient.alpha > 0) {
			tubeShader.update();
		}

		updateBoxesToConfirm();
	}

	function manageTube():Void {
		for (box in boxSprites) {
			if (playState.getBoxByID(box.ID).status == TOP_TUBE) {
				if (box.x < 685) {
					box.velocity.x = 0;
					playState.getBoxByID(box.ID).status = TOP_SLIDING;
					FlxTween.tween(box, {x: FlxG.random.float(635, 665), angularVelocity: FlxG.random.float(-1, -20)}, 2, {
						ease: FlxEase.quartOut,
						onComplete: function(f):Void {
							playState.getBoxByID(box.ID).status = TOP_WAITING;
						}
					});
				}
			}
		}
	}

	override function sendBox(id:Int, boxSendType:BoxSendType):Void {
		if (boxSendType == RIGHT_TO_TOP) {
			new FlxTimer().start(GameValues.roomTravelTime(), function(f):Void {
				spawnBox(id);
			});
		}
	}

	function spawnBox(id:Int):Void {
		var boxSprite = new FlxSprite(FlxG.width, FlxG.random.int(100, 110)).loadGraphic('assets/images/night/rooms/right/spikedBox.png');
		boxSprite.ID = id;
		boxSprite.velocity.x = -GameValues.getTubeSpeed();
		boxSprite.angularVelocity = FlxG.random.float(-20, -200);
		boxSprites.add(boxSprite);

		playState.getBoxByID(id).status = TOP_TUBE;
	}

	function updateBoxesToConfirm():Void {
		var allBoxes:Int = 0;
		var availableBoxes:Int = 0;
		for (i in boxSprites) {
			if (playState.getBoxByID(i.ID).status == TOP_SLIDING || playState.getBoxByID(i.ID).status == TOP_WAITING) {
				allBoxes++;
				if (!(availableBoxes >= GameValues.getMaxWorkload())) {
					availableBoxes++;
				}
			}
		}
		computerMonitor.pageFinishProduction.updateBoxesToConfirm(allBoxes, availableBoxes);
	}

	function confirmBoxes():Void {
		var boxesToConfirm:Array<FlxSprite> = [];

		for (i in boxSprites) {
			if (playState.getBoxByID(i.ID).status == TOP_SLIDING || playState.getBoxByID(i.ID).status == TOP_WAITING) {
				boxesToConfirm.push(i);
			}
		}

		var boxesConfirmed:Int = 0;
		for (i in boxesToConfirm) {
			if (boxesConfirmed >= GameValues.getMaxWorkload()) {
				i.alpha = .5;
			} else {
				FlxTween.cancelTweensOf(i);
				playState.getBoxByID(i.ID).status = TOP_CONFIRMING;

				i.loadGraphic('assets/images/night/rooms/top/finishedBox.png');
				i.velocity.set(0, 0);
				i.angularVelocity = 0;
				i.scale.set(1.3, 1.3);
				i.angle = FlxG.random.int(0, 360);
				FlxTween.tween(i.scale, {x: 1, y: 1}, GameValues.getConfirmationTime() / 3, {ease: FlxEase.quartOut});
				FlxTween.tween(i, {
					angle: i.angle + FlxG.random.float(-200, 200),
					x: i.x + FlxG.random.float(-3, 3),
					y: -i.height
				}, GameValues.getConfirmationTime() * FlxG.random.float(.8, 1.2),
				{
					ease: FlxEase.quartIn,
					onComplete: function(f):Void {
						finishBox();
						boxSprites.remove(i, true);
						i.destroy();
					}
				});
			}
			boxesConfirmed++;
		}

		new FlxTimer().start(GameValues.getConfirmationTime(), function(f):Void {
			for (i in boxSprites) {
				if (i.alpha == .5)
					i.alpha = 1;
			}
		});
	}

	function finishBox():Void {
		FlxTween.cancelTweensOf(tubeGradient);
		tubeGradient.alpha = FlxG.random.float(.7, 1);
		tubeGradient.y = 0;
		var time = FlxG.random.float(2, 2.5);
		FlxTween.tween(tubeGradient, {y: -70, alpha: 0}, time, {ease: FlxEase.quartOut});
	}

	override function enterRoom():Void {
		computerMonitor.tranIn();
	}

	override function leaveRoom():Void {
		computerMonitor.tranOut();
	}
}