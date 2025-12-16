package killbox.game;

class PlayState extends FlxState
{
	var rooms:Map<String, Room> = [];
	var roomList:Array<String> = [];
	var curRoom:String = '';
	var roomGroup:FlxTypedGroup<Room>;
	
	override public function create()
	{
		roomGroup = new FlxTypedGroup<Room>();
		add(roomGroup);
		
		addRoom('main');
		addRoom('left');
		addRoom('right');
		addRoom('ceiling');
		
		changeRoom('main');
		
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
	
	function changeRoom(newRoom:String):Void{
		curRoom = newRoom;
		updateActiveRooms();	
	}
	
	function updateActiveRooms():Void{
		for(i in roomList){
			if(i == curRoom){
				rooms.get(i).roomActive = true;
			} else {
				rooms.get(i).roomActive = false;
			}
		}
	}
}
