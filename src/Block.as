package{
    import com.mauft.Control;
    
    import flash.display.MovieClip;
    
    public class Block{
        public static var kongTotalDestroyed:uint = 0;
        public static var kongUsedInLevel   :uint = 0;
        
        public var x:Number;
        public var y:Number
        public var color:Number;
        public var gfx:MovieClip;
        public var active:Boolean = false;
        public var gravity:Number = 0
        
        public var lastCrawlCheck:Number = 0;
        
        public static var colsLeft:Array = [0, 0, 0, 0, 0, 0];
        
        public static function get left():Number{ return colsLeft[0] + colsLeft[1] + colsLeft[2] + colsLeft[3] + colsLeft[4] + colsLeft[5]; }
        
        public static var change:Number = 0;
        
        public static var combo:int = 0;
        
        public static var toCrawl:Array = new Array();
        
        public static var landed:int = 0;
        
        public static var playMove:Boolean = false;
        
        private var blinker:Blinker;
        
        public function blink():void{
            if (blinker){
                if (blinker.isFinished)
                    blinker = null;
                else
                    return;
            }
            
            if (!blinker && Math.random() < 0.002 && Weirdtris.levelCompleted == false && Weirdtris.levelRestart == false)
                blinker = new Blinker(gfx)
        }
        
        public function Block(_x:Number, _y:Number, _col:Number, _gfx:MovieClip, _active:Boolean = false){
            x      = _x;
            y      = _y;
            color  = _col;
            gfx    = _gfx;
            active = _active;
            
            Weirdtris.self.addChildAt(gfx, 1)
            
            if (active){
                gfx.name = "funk"
                Weirdtris.currBlock.push(this)
                new InFader(gfx, 0.1);
            } else {
                setTile();
                new InFader(gfx);
                colsLeft[color]++;
            } 
        }
        
        public function update():void{
            
            var iteration:int = Control.isKeyDown(Control._DOWN) ? 6 : 2;
            
            
            
            if (Control.isKeyHit(Control._LEFT) && isFree(x - 1, y) && isFree(x - 1, y + 29) && x > 0 ){
                x -= 30;
                playMove = true;
            } else if (Control.isKeyHit(Control._RIGHT) && isFree(x + 30, y) && isFree(x + 30, y + 29) && x < 400){
                x += 30;
                playMove = true;
            }
            
            while (active && iteration--){
                if (y < 285){
                    gravity += 0.1;
                } else if (y > 285){
                    gravity -= 0.1;
                }
                
                y += gravity
                
                
                
                if (gravity > 0 && (!isFree(x, y + 30) || !isFree(x + 29, y + 29))){
                    
                    change++;
                    
                    colsLeft[color]++;
                    
                    combo = 0;
                    
                    x = Math.floor(x / 30) * 30;
                    y = Math.floor((y + 2) / 30) * 30;
                    
                    toCrawl.push(this);
                    
                    setTile();
                    
                    kongUsedInLevel++;
                    
                    
                    (new SFX_Drop).play(0, 0, Weirdtris.soundTransform);
                    
                } else if (gravity < 0 && (!isFree(x, y) || !isFree(x + 29, y))){
                        
                    change++;
                    
                    colsLeft[color]++;
                    
                    combo = 0;
                    
                    x = Math.floor(x / 30) * 30;
                    y = Math.floor(y / 30) * 30 + 30;
                    
                    toCrawl.push(this);
                    
                    setTile();
                    
                    kongUsedInLevel++;
                    
                    
                    (new SFX_Drop).play(0, 0, Weirdtris.soundTransform);
                }
                
                gfx.x = x
                gfx.y = y
            }
        }
        
        public function fall():void{
            gfx.x = x;
            gfx.y = y;
            
            if (y < 285){
                gravity += 0.2;
            } else {
                gravity -= 0.2;
            }
            
            y += gravity;
            
            checkFall();
        }
        
        public function checkFall():void{
            if (gravity > 0){
                if (!isFree(x, y + 30) || y > 270){
                    x = Math.floor(x / 30) * 30;
                    y = Math.floor((y + 2) / 30) * 30;
                    
                    Weirdtris.falling.splice(Weirdtris.falling.indexOf(this), 1);
                    
                    setTile();
                    
                    gfx.x = x;
                    gfx.y = y;
                    
                    landed++
                    
                    toCrawl.push(this);
                    
                    
                }
            } else {
                if (!isFree(x, y - 0.1) || y < 300.1){
                    x = Math.floor(x / 30) * 30;
                    y = Math.floor((y - 0.1) / 30) * 30 + 30;
                    
                    Weirdtris.falling.splice(Weirdtris.falling.indexOf(this), 1);
                    
                    setTile();
                    
                    gfx.x = x;
                    gfx.y = y;

                    landed++
                    
                    toCrawl.push(this);
                    
                    
                }
            }
        }
        
        public function pop(color:int, faller:Boolean = false):void{
            
            var blo:Block;
            
            if (faller){
                Weirdtris.tiles[x/30 + y / 2] = null;
                
                gravity = 0;
                
                Weirdtris.falling.push(this);
                
                if (y > 285){
                    blo = Weirdtris.tiles[x/30 + y / 2 + 15];
                    if (blo){ blo.pop(123, true); }
                    
                } else if (y < 285){
                    blo = Weirdtris.tiles[x/30 + y / 2 - 15];
                    if (blo){ blo.pop(123, true); }
                }
               
                return;
            }
            
            kongTotalDestroyed++;
            
            if (color != this.color){ return; }
            
            if (blinker){
                blinker.kill();
                blinker.removeFromList();
            }
            
            Weirdtris.tiles[(x/30 | 0) + (y / 2 | 0)] = null;
            
            blo = Weirdtris.tiles[x/30 + y / 2 + 1];
            if (blo){ blo.pop(color); }
            
            blo = Weirdtris.tiles[x/30 + y / 2 - 1];
            if (blo){ blo.pop(color); }
            
            blo = Weirdtris.tiles[x/30 + y / 2 + 15];
            if (blo){ blo.pop(color); }
            
            blo = Weirdtris.tiles[x/30 + y / 2 - 15];
            if (blo){ blo.pop(color); }
            
            colsLeft[color]--;
            
            if (Weirdtris.numBlocks > 0){
                Weirdtris.numBlocks--;
            }
            
            change--;
            
            combo += 1;
            
            Weirdtris.score.add(10 * combo);
            
            if (y > 285){
                blo = Weirdtris.tiles[x/30 + y / 2 + 15];
                if (blo){ blo.pop(123, true); }
                
            } else if (y < 285){
                blo = Weirdtris.tiles[x/30 + y / 2 - 15];
                if (blo){ blo.pop(123, true); }
            }
            new Starer(x, y);
            new Starer(x, y);
            new Starer(x, y);
            new Starer(x, y);
            
            
            new Fader(gfx);
        }
        
        public function setTile():void{
            active = false;
            
            gravity = 0;
            
            if (Weirdtris.currBlock.indexOf(this) != -1){
                Weirdtris.currBlock.splice(Weirdtris.currBlock.indexOf(this), 1);
            }
            
            
            Weirdtris.tiles[x/30 + y / 2] = this;
        }
        
        
        public function isFree(x:Number, y:Number):Boolean{
            x = Math.floor(x / 30);
            y = Math.floor(y / 30);
            
            return Weirdtris.tiles[x + y * 15] == null;
        }
    }
}