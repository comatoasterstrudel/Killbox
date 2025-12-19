package killbox.game.ui;

class BoxCounter extends FlxTypedSpriteGroup<BoxCounterLabel>
{
    final DISTANCE:Float = 10;
    
    var room:Room;
    var boxGroup:FlxSpriteGroup;
    
    public function new (room:Room, boxGroup:FlxSpriteGroup):Void{
        super();
        
        this.room = room;
        this.boxGroup = boxGroup;
        
        new FlxTimer().start(.5, function(tmr):Void{
            tmr.reset();
            updateGroups();
        });
    }

    function updateGroups():Void{
         for(i in members){
            i.kill();
        }
        if(room.roomActive){            
            var groupedBoxes:Array<Array<FlxSprite>> = [];
            
            for(box in boxGroup.members){
                var pos = new FlxPoint(box.x + (box.width / 2), box.y + (box.height / 2));
                
                for(newBox in boxGroup.members){
                    if(box.ID == newBox.ID) continue;
                    
                    if(FlxG.overlap(box, newBox)){
                        var matchedToGroup:Bool = false;
                        
                        for(i in groupedBoxes){
                            if(i.contains(box) || i.contains(newBox)){ //a group in this list already has these boxes
                                if(!i.contains(box)) i.push(box);
                                if(!i.contains(newBox)) i.push(newBox);
                                matchedToGroup = true;
                            }
                        }
                        
                        if(!matchedToGroup){
                            groupedBoxes.push([box, newBox]);
                        }
                    }
                }                
            }
            
            for(i in 0...groupedBoxes.length){
                if(members.length - 1 < i){ //there isnt a label for this group, so make one
                    var label = new BoxCounterLabel(groupedBoxes[i]);
                    add(label);
                } else {
                    var label = members[i];
                    label.revive();
                    label.boxes = groupedBoxes[i];
                    label.updateLabel();
                }
            }
            
            groupedBoxes = [];            
        }
    }
}