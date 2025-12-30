package killbox.game.rooms.right;

class ConfirmationKeypad extends FlxSpriteGroup
{
    var padBg:FlxSprite;
	var padStand:FlxSprite;
	var buttons:Array<ConfirmationKeypadButton> = []; 
	var label:FlxText;

	var interactable:Bool = true;
	var curCode:Array<Int> = [];
    
    public function new():Void{
        super();
        
        padBg = new FlxSprite(670, 340).makeGraphic(120, 160, 0xFFC4C4C4);
        
        padStand = new FlxSprite().makeGraphic(70, 30, 0xFF807C7C);
        padStand.setPosition(padBg.x + padBg.width / 2 - padStand.width / 2, padBg.y + padBg.height);
        add(padStand);
        
        add(padBg);
        
        addButtons();
		label = new FlxText(0, 0, 0, '0201', 25);
		add(label);
	}

	override function update(elapsed:Float):Void {
		super.update(elapsed);

		updateLabel();
	}
    
    function addButtons():Void{
        var xID:Int = 0;
        var yID:Int = 0;
        
        for(i in 0...10){
            if(i == 0){
                xID = 1;
                yID = 3;
            }
            
            var button = new ConfirmationKeypadButton(padBg, '$i', 0xFFFFFFFF, xID, yID, function():Void{
				addNumber(i);
            });
            add(button);
            
            if(i == 0){
                xID = 0;
                yID = 0;
            } else {
                xID ++;
            
                if(xID > 2) {
                    xID = 0;
                    yID ++;
                }   
            }            
        }
        
        var button = new ConfirmationKeypadButton(padBg, 'confirm', 0xFFADDDB8, 2, 3, function():Void{
			confirmCode();
		});
		add(button);

		var button = new ConfirmationKeypadButton(padBg, 'cancel', 0xFFDDADAD, 0, 3, function():Void {
			clearCode();
		});
		add(button);
	}

	function addNumber(num:Int):Void {
		if (!interactable)
			return;

		if (curCode.length >= GameValues.getVerificationCodeLength()) {
			cantDoAction();
			return;
		}
		curCode.push(num);

		updateLabel();
	}

	function updateLabel():Void {
		var labelText:String = '';
		for (i in curCode) {
			labelText += Std.string(i);
		}
		label.text = labelText;
		label.setPosition(padBg.x + padBg.width / 2 - label.width / 2, padBg.y + padBg.height + 10);
	}

	function clearCode():Void {
		curCode = [];
		updateLabel();
	}

	function confirmCode():Void {
		interactable = false;

		var succeeded:Bool = true;

		for (i in 0...ComputerPageAcquireCode.code.length) {
			if (ComputerPageAcquireCode.code[i] != curCode[i]) {
				succeeded = false;
			}
		}

		if (succeeded) {
			label.color = FlxColor.LIME;
			ComputerPageAcquireCode.generateCode();
		} else {
			label.color = FlxColor.RED;
		}

		FlxFlicker.flicker(label, 1, 0.1, true, true, function(f):Void {
			curCode = [];
			label.color = FlxColor.WHITE;
			updateLabel();

			if (succeeded) {
				interactable = true;
			} else {
				interactable = true;
			}
        });
	}

	function cantDoAction():Void {
		FlxTween.cancelTweensOf(label);
		FlxTween.shake(label, 0.05, .1, X);
	}
}