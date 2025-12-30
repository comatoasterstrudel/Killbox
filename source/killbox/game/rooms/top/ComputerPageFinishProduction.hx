package killbox.game.rooms.top;

class ComputerPageFinishProduction extends ComputerPage{
   	override function setupPage():Void{		
		addButton(Std.int(screen.x + 10), Std.int(screen.y + 165), 'BACK', function():Void{
			changePage('main');
		}); 
   	}	
}