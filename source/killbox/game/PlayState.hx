package killbox.game;

class PlayState extends FlxState
{
	var rooms:Map<String, Room> = [];
	var roomList:Array<String> = [];
	var curRoom:String = '';
	var roomGroup:FlxTypedGroup<Room>;
	
	var movementUI:MovementUI;

	var camGame:FlxCamera;
	var camTransition:FlxCamera;
	var camUI:FlxCamera;
	
	override public function create()
	{
		camGame = new FlxCamera();
		camGame.bgColor = FlxColor.WHITE;
		FlxG.cameras.add(camGame);

		camTransition = new FlxCamera();
		camTransition.bgColor = 0x00000000;
		FlxG.cameras.add(camTransition, false);

		camUI = new FlxCamera();
		camUI.bgColor = 0x00000000;
		FlxG.cameras.add(camUI, false);
		
		roomGroup = new FlxTypedGroup<Room>();
		add(roomGroup);
		
		addRoom('main');
		addRoom('left');
		addRoom('right');
		addRoom('ceiling');
		
		movementUI = new MovementUI(changeRoom);
		movementUI.camera = camUI;
		add(movementUI);

		curRoom = 'main';
		updateActiveRooms();
		movementUI.updateActiveButtons(rooms.get(curRoom).possibleMovements);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
	
	function addRoom(name:String):Void{
		if(rooms.exists(name)){
			FlxG.log.error('Room ${name} already exists!!');
			return;
		}
		
		var newRoom = Room.getRoomFromName(name, this);
		roomGroup.add(newRoom);
		
		rooms.set(name, newRoom);
		roomList.push(name);
		
		updateActiveRooms();
	}
	
	function changeRoom(newRoom:String):Void
	{
		movementUI.hide();
		var timeToTransition:Float = .6;
		doRoomTransitionAnim(timeToTransition, function():Void
		{
			curRoom = newRoom;
			updateActiveRooms();	
			new FlxTimer().start(timeToTransition / 2, function(f):Void
			{
				movementUI.updateActiveButtons(rooms.get(curRoom).possibleMovements);
			});
		});
	}

	function doRoomTransitionAnim(time:Float, after:Void->Void):Void
	{
		var tranSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		tranSprite.camera = camTransition;
		tranSprite.alpha = 0;
		add(tranSprite);

		FlxTween.tween(tranSprite, {alpha: 1}, time / 2, {
			onComplete: function(f):Void
			{
				after();
				FlxTween.tween(tranSprite, {alpha: 0}, time / 2, {
					onComplete: function(f):Void
					{
						tranSprite.destroy();
					}
				});
			}
		});
	}
	
	function updateActiveRooms():Void{
		for(i in roomList){
			if(i == curRoom){
				rooms.get(i).roomActive = true;
			} else {
				rooms.get(i).roomActive = false;
			}
			rooms.get(i).toggleRoomVisibility();
		}
	}
}
