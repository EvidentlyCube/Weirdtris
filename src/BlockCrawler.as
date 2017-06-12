package{
    import com.mauft.GlobalUtils;
    
    public class BlockCrawler{
        public static var crawlCount:int = 0;
        
        public static var crawlColor:int;
        
        public static var currentCrawlValue:int = 0;
        
        public static var startX:uint;
        public static var startY:uint;
        
        private static function Crawl(x:int, y:int):Boolean{
            var blo:Block = Weirdtris.tiles[x + y * 15];
            if (blo && blo.color == crawlColor && blo.lastCrawlCheck != currentCrawlValue){
                blo.lastCrawlCheck = currentCrawlValue;
                crawlCount++;
                
                if (crawlCount > 2){
                    return true;
                }
                
                if (Crawl(x + 1, y)    ) { return true; }
                if (Crawl(x - 1, y)    ) { return true; }
                if (Crawl(x,     y + 1)) { return true; }
                if (Crawl(x,     y - 1)) { return true; }
            }
            
            return false;
        }
        
        private static function popCrawl(x:int, y:int):void{
            var blo:Block = Weirdtris.tiles[x + y * 15];
            if (blo && blo.color == crawlColor){
                blo.pop(crawlColor);
                
                popCrawl(x - 1, y);
                popCrawl(x + 1, y);
                popCrawl(x, y - 1);
                popCrawl(x, y + 1);
            }
        }
        
        public static function startNewCrawl(x:int, y:int, color:Number):void{
            crawlCount        = 0;
            crawlColor        = color;
            currentCrawlValue++;
            
            startX = x / 30;
            startY = y / 30;
            
            if (Crawl(startX, startY)){
                popCrawl(startX, startY);
                (new SFX_Explo).play(0, 0, Weirdtris.soundTransform);
            }
        }
    }
}