package{
    import flash.display.MovieClip;
    import flash.geom.ColorTransform;
    
    public class Fader{
        
        protected var gfx:MovieClip
        
        protected var block:Block;
        
        protected var cT:ColorTransform
        
        public var isFinished:Boolean = false;
        
        public function Fader(gfx:MovieClip, block:Block = null){
            this.gfx = gfx;
            
            cT = gfx.transform.colorTransform;
            
            Weirdtris.effects.push(this);
            
            this.block = block;
        }
        
        public function kill():void{
            cT.alphaMultiplier = 0
            
            gfx.transform.colorTransform = cT;
            
        }
        
        public function update():void{
            cT.redOffset   += 30;
            cT.greenOffset += 30;
            cT.blueOffset  += 30;
            cT.alphaMultiplier -= 0.06;
            
            gfx.transform.colorTransform = cT;
            
            if (block){
                block.update();
            }
            
            if (cT.alphaMultiplier <= 0){
                gfx.parent.removeChild(gfx);
                if (block){
                    if (Weirdtris.currBlock.indexOf(block) > -1){
                        Weirdtris.currBlock.splice(Weirdtris.currBlock.indexOf(block), 1);
                    } else if (Weirdtris.falling.indexOf(block) > -1){
                        Weirdtris.falling.splice(Weirdtris.falling.indexOf(block), 1);
                    } else {
                        Weirdtris.tiles[block.x/30 + block.y/2] = null;
                    }
                }
                
                Weirdtris.effects.splice(Weirdtris.effects.indexOf(this), 1);
                
                isFinished = true;
            }
        }
    }
}