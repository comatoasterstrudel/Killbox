package killbox.game.night.ghost;

class GhostAiList{
    public var list:Map<String, Int> = [];
    
    public function new(?list:Map<String, Int>){
        for(i in GhostUtil.ghostList){
            if(list != null && list.exists(i)){
                this.list.set(i, list.get(i));
            } else {
                this.list.set(i, 0);
            }
        }
    }
}