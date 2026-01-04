package killbox.game.rooms.top;

class ComputerPageFinishProduction extends ComputerPage{
	var text1:ComputerText;
	var confirmButton:ComputerButton;

	public var onConfirm:FlxSignal;
	
   	override function setupPage():Void{		
		addButton(Std.int(screen.x + 10), Std.int(screen.y + 165), 'BACK', function():Void{
			changePage('main');
		}); 
		text1 = new ComputerText(this, 0, 0, '221212:');
		add(text1);
		text1.size = 12;
		confirmButton = addButton(Std.int(screen.x + screen.width / 2 - 40), Std.int(screen.y + 100), 'Confirm', function():Void {
			confirmBoxes();
		});
		onConfirm = new FlxSignal();
	}

	public function updateBoxesToConfirm(allBoxes:Int, availableBoxes:Int):Void {
		text1.text = '[ $allBoxes ] Boxes Ready';

		if (allBoxes > 0) {
			text1.text += ' \nConfirm [ $availableBoxes ] Boxes?';
			confirmButton.pressable = true;
		} else {
			confirmButton.pressable = false;
		}
		text1.setPosition(screen.x + screen.width / 2 - text1.width / 2, screen.y + 50);
	}

	function confirmBoxes():Void {
		onConfirm.dispatch();
	}
}