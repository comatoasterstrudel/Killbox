package killbox.game.night.boxes;

class Box
{
    public var ID:Int;
    public var status:BoxStatus = MAIN_FALLING;
    
    public function new(ID:Int):Void{
        this.ID = ID;
    }
}