package killbox.game.night.rooms.top.computer;

class ComputerPageAcquireCode extends ComputerPage{
	var codeText:ComputerText;
	
   	override function setupPage():Void{		
		var text = new ComputerText(this, 0, 0, 'CURRENT_CODE:');
		text.size = 12;
		text.setPosition(screen.x + screen.width / 2 - text.width / 2, screen.y + 50);
		add(text);

		codeText = new ComputerText(this, 0, 0, '221212:');
		codeText.size = 30;
		add(codeText);
		
		addButton(Std.int(screen.x + 10), Std.int(screen.y + 165), 'BACK', function():Void{
			changePage('main');
		}); 
		
		generateCode();
   	}	
	
	override function update(elapsed:Float):Void{
		super.update(elapsed);
		
		var theText:String = '';
		
		for(i in code){
			theText += Std.string(i);
		}
		codeText.text = theText;
		codeText.setPosition(screen.x + screen.width / 2 - codeText.width / 2, screen.y + 100);
	}
	
	public static var code:Array<Int> = [];
	
	public static function generateCode():Void{
		code = [];
		
		for(i in 0...GameValues.getVerificationCodeLength()){
			code.push(FlxG.random.int(0,9));
		}
	}
}