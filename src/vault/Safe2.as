/*
Copyright (c) 2009 Maurycy Zarzycki, Mauft.com

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/

package vault{
    
    /**
     * @private
     * Safe is a parent class for sub-safe classes which are used to store and obfuscate a sensitive data
     * for the Vault class.
     */
    internal class Safe2 extends SafeParent{
        
        public var floorSin25         :Number;
        public var ceilCos30          :Number;
        public var atan2plus1         :Number;
        public var module23           :Number;
        public var stringedFloorSquare:String;
        
        override internal function get():Number{
            check();
            return unchanged;
        } 
        
        override internal function set(newNum:Number, skipCheck:Boolean=false):Number{
            if (!skipCheck){
                if (!check()){
                    return 0;
                }
            }
            unchanged           = newNum;
            floorSin25          = Math.floor( Math.sin  (unchanged)              * 25 );
            ceilCos30           = Math.ceil ( Math.cos  (unchanged)              * 30 );
            atan2plus1          = Math.floor( Math.atan2(unchanged, unchanged+1) * 50 );
            module23            = unchanged % 23
            stringedFloorSquare = Math.floor( Math.sqrt (unchanged) ).toString();
            
            return newNum;
        }
        
        override internal function check():Boolean{
            if (floorSin25         != Math.floor( Math.sin  (unchanged)              * 25 )
            || ceilCos30           != Math.ceil ( Math.cos  (unchanged)              * 30 )
            || atan2plus1          != Math.floor( Math.atan2(unchanged, unchanged+1) * 50 )
            || module23            != unchanged % 23
            || stringedFloorSquare != Math.floor( Math.sqrt (unchanged) ).toString()      ){
                
                Vault.fakeValue();
                return false;
                
            } else {
                return true;
                
            }
        }
        
        override internal function safeToString():String{
            return "2" + unchanged.toString() + "`" + floorSin25.toString() + "`" + ceilCos30.toString() + "`" + atan2plus1.toString() + "`" + module23.toString() + "`" + stringedFloorSquare + "`"; 
        }
        
        override internal function stringToSafe(string:String):void{
            string = string.substr(1);
            
            var array:Array = string.split("`");
            
            unchanged           = array[0];
            floorSin25          = array[1];
            ceilCos30           = array[2];
            atan2plus1          = array[3];
            module23            = array[4];
            stringedFloorSquare = array[5];
        } 
    }
}