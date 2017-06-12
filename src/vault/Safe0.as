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
    internal class Safe0 extends SafeParent{
        
        public var module10   :Number;
        public var module13   :Number;
        public var module3571 :Number;
        public var squareFloor:Number;
        public var stringed   :String;
        
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
            
            unchanged   = newNum;
            module10    = newNum % 10;
            module13    = newNum % 13;
            module3571  = newNum % 3571;
            squareFloor = Math.floor( Math.sqrt(newNum) );
            stringed    = newNum.toString();
            
            return newNum;
        }
        
        override internal function check():Boolean{
            if (module10   != unchanged % 10
            || module13    != unchanged % 13
            || module3571  != unchanged % 3571
            || squareFloor != Math.floor( Math.sqrt(unchanged) )
            || stringed    != unchanged.toString()             ){
                Vault.fakeValue();
                return false;
                
            } else {
                return true;
                
            }
        }
        
        override internal function safeToString():String{
            return "0" + unchanged.toString() + "`" + module10.toString() + "`" + module13.toString() + "`" + module3571.toString() + "`" + squareFloor.toString() + "`" + stringed + "`"; 
        }
        
        override internal function stringToSafe(string:String):void{
            string = string.substr(1);
            
            var array:Array = string.split("`");
            
            unchanged   = array[0];
            module10    = array[1];
            module13    = array[2];
            module3571  = array[3];
            squareFloor = array[4];
            stringed    = array[5];
        } 
    }
}