package killbox.game.rooms.top;

class ComputerPageMain extends ComputerPage{
   	override function setupPage():Void{
		addButton(Std.int(screen.x + 10), Std.int(screen.y + 40), 'FINISH_PRODUCTION', function():Void{
			changePage('finishProduction');
		});
		
		addButton(Std.int(screen.x + 10), Std.int(screen.y + 65), 'ACQUIRE_CODE', function():Void{
			//
		});
		
		addButton(Std.int(screen.x + 10), Std.int(screen.y + 90), 'ECTOPLASM', function():Void{
			//
		});
		
		addButton(Std.int(screen.x + 10), Std.int(screen.y + 115), 'CLOCK_OUT', function():Void{
			//
		});
   	}	
}