package killbox.game.night.rooms.top;

class ComputerPageFinishProduction extends ComputerPage{
	var text1:ComputerText;
	var confirmButton:ComputerButton;

	var text2:ComputerText;

	public var onConfirm:FlxSignal;
	
	var producing:Bool = false;

	var productionProgress:Float = 0;

	var productionTextProgress:Float = 0;
	var productionTexts:Array<String> = [
		'Shipping in progress',
		'Shipping in progress.',
		'Shipping in progress..',
		'Shipping in progress...'
	];
	var productionTextID:Int = 0;

	var productionBar:FlxBar;

	var lastActive:Bool = false;
	
   	override function setupPage():Void{		
		addButton(Std.int(screen.x + 10), Std.int(screen.y + 165), 'BACK', function():Void{
			changePage('main');
		}); 
		text1 = new ComputerText(this, 0, 0, '221212:');
		add(text1);
		text1.size = 12;
		confirmButton = addButton(Std.int(screen.x + screen.width / 2 - 40), Std.int(screen.y + 100), 'Ship', function():Void {
			confirmBoxes();			
		});
		onConfirm = new FlxSignal();
		text2 = new ComputerText(this, 0, 0, 'Shipping in progress');
		add(text2);
		text2.size = 12;

		productionBar = new FlxBar(0, screen.y + 100, LEFT_TO_RIGHT, Std.int(screen.width / 1.4), 30, this, 'productionProgress', 0, 1);
		productionBar.numDivisions = 40;
		productionBar.createColoredEmptyBar(0xFF00AB01);
		productionBar.createColoredFilledBar(FlxColor.GREEN);
		productionBar.x = screen.x + screen.width / 2 - productionBar.width / 2;
		add(productionBar);

		changeStatus(false);
	}

	override function update(elapsed:Float):Void {
		super.update(elapsed);

		if (producing) {
			productionTextProgress += elapsed * FlxG.random.float(.9, 2);
			if (productionTextProgress >= 1) {
				productionTextProgress = 0;
				productionTextID++;
				if (productionTextID >= productionTexts.length)
					productionTextID = 0;
			}
			text2.text = productionTexts[productionTextID];
		}

		changeStatus(producing);
	}

	public function updateBoxesToConfirm(allBoxes:Int, availableBoxes:Int):Void {
		text1.text = '[ $allBoxes ] Boxes Ready';

		if (allBoxes > 0) {
			text1.text += ' \nShip [ $availableBoxes ] Boxes?';
			confirmButton.pressable = true;
		} else {
			confirmButton.pressable = false;
		}
		text1.setPosition(screen.x + screen.width / 2 - text1.width / 2, screen.y + 50);
		text2.setPosition(screen.x + screen.width / 2 - text1.width / 2, screen.y + 50);
	}

	function confirmBoxes():Void {
		onConfirm.dispatch();
		productionProgress = 0;

		changeStatus(true);
		FlxTween.tween(this, {productionProgress: 1}, GameValues.getConfirmationTime(), {
			onComplete: function(f):Void {
				changeStatus(false);
			}
		});

		productionTextID = 0;
		productionTextProgress = 0;
	}

	function changeStatus(producing:Bool):Void {
		this.producing = producing;

		for (i in [text1, confirmButton]) {
			i.visible = !producing;
		}
		for (i in [text2, productionBar]) {
			i.visible = producing;
		}
	}
}