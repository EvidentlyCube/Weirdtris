package 
{
	import com.mauft.Control;
	import com.mauft.GlobalUtils;
	import com.mauft.SaveLoad;
	import com.mauft.TextUtils;
	import com.mauft.DisplayManager;

	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.text.TextFieldAutoSize;
	import flash.utils.setTimeout;

	import vault.Safe;
	import vault.Vault;
	import flash.display.StageDisplayState;
	import flash.display.StageAlign;
	import flash.ui.Keyboard;

	dynamic public class Weirdtris extends MovieClip    {;
	public static var completedNoRestart:Boolean = false;
	public static var completedYesRestart:Boolean = false;

	public static var kongregate:*;

	public static var tiles:Array = new Array(300);
	public static var self:Weirdtris;
	public static var currBlock:Array = new Array();
	public static var falling:Array = new Array();
	public static var effects:Array = new Array();

	public static var levelID:int = 0;

	public static var gameStarted:Boolean = false;
	public static var levelCompleted:Boolean = false;
	public static var levelRestart:Boolean = false;

	public static var colors:Array;
	public static var numBlocks:int;
	public static var typeSurvival:Boolean;

	public static var score:Safe = new Safe();
	public static var scoreLast:Safe = new Safe();
	public static var time:Safe = new Safe();

	public static var scorerReady:Boolean = false;

	public static var gameIsPlaying:Boolean = false;

	public static var starVomiter:uint = 0;
	private static var music:SoundChannel;

	public static function set volume(v:Number):void
	{
		soundTransform.volume = v;
		music.soundTransform = soundTransform;
	}

	public static function get volume():Number
	{
		return soundTransform.volume;
	}

	public static var soundTransform:SoundTransform;

	public function Weirdtris()
	{
		self = this;

		stage.align = StageAlign.TOP_LEFT;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		DisplayManager.initializeFlash(this, stage);
		DisplayManager.setBackgroundColor(0xFF000000);


		SaveLoad.setStorage("weirdKafka");
		completedNoRestart = SaveLoad.getData("completedNo") || false;
		completedYesRestart = SaveLoad.getData("completedYes") || false;

		stage.showDefaultContextMenu = false;

		Vault.setCheatCallback(function():void{
		                score.force(0);
		                scoreLast.force(0);
		                time.force(999);
		            });

		Control.init(stage);

		Control.singleHits = false;

		addEventListener(Event.ENTER_FRAME, step);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);

		Weirdtris.soundTransform = new SoundTransform(1);
	}

	public function levelStart(levID:Number, _colors:Array, _numBlocks:int, isSurvival:Boolean):void
	{
		levelID = levID;
		colors = _colors;
		numBlocks = _numBlocks;
		typeSurvival = isSurvival;

		Block.colsLeft[0] = 0;
		Block.colsLeft[1] = 0;
		Block.colsLeft[2] = 0;
		Block.colsLeft[3] = 0;
		Block.colsLeft[4] = 0;
		Block.colsLeft[5] = 0;

		if (! typeSurvival)
		{
			numBlocks = -1;
		}

		for (var i:int = 0; i < 300; i++)
		{
			tiles[i] = null;
		}

		scoreLast.set(score.get());
		levelRestart = false;
		gameStarted = false;
		levelCompleted = false;
	}

	public function handleKeyDown(e:KeyboardEvent):void
	{
		if (e.keyCode == Keyboard.F11){
			DisplayManager.toggleFullScreen();
		}
		if (e.keyCode == Keyboard.F4){
			if (DisplayManager.scaleToFit && DisplayManager.scaleToInteger){
				DisplayManager.scaleToFit = false;
				DisplayManager.scaleToInteger = false;
			} else if (DisplayManager.scaleToFit && !DisplayManager.scaleToInteger){
				DisplayManager.scaleToFit = true;
				DisplayManager.scaleToInteger = true;
			} else {
				DisplayManager.scaleToFit = true;
				DisplayManager.scaleToInteger = false;
			}
			
		}
	}
	public function step(e:Event):void{
		GlobalUtils.updateUtils();

		if (stage.focus && ! stage.focus.stage)
		{
			stage.focus = null;
		}

		var k:int;
		for (k = effects.length; k > 0; k--)
		{
			Fader(effects[k - 1]).update();
		}

		if (levelRestart)
		{
			if (effects.length == 0)
			{
				levelCompleted = false;
				score.set(scoreLast.get());
				score.add(-Math.ceil(score.get() / 10));
				gotoAndStop(currentFrame - 1);
				return;
			}
		}

		if (! gameStarted)
		{
			return;
		}
		if (levelCompleted)
		{
			for (var repeats:uint = 2; repeats; repeats--)
			{
				if (starVomiter)
				{
					new Starer(Math.random() * 400 + 10,starVomiter * 13.875);
					new Starer(Math.random() * 400 + 10,starVomiter * 13.875);
					new Starer(Math.random() * 400 + 10,starVomiter * 13.875);
					new Starer(Math.random() * 400 + 10,starVomiter * 13.875);
					starVomiter--;
				}
			}
			if (effects.length == 0 && scorerReady)
			{
				gotoAndStop(currentFrame + 1);
				levelCompleted = false;
			}
			return;
		}

		var i:Block;
		for (k = falling.length - 1; k >= 0; k--)
		{
			Block(falling[k]).fall();
		}

		while (Block.landed)
		{
			Block.landed = 0;
			for (k = falling.length; k > 0; k--)
			{
				Block(falling[k - 1]).checkFall();
			}
		}

		if (Block.left == 0 || numBlocks == 0)
		{
			completed();
			return;
		}

		if (currBlock.length > 0)
		{
			for (k = currBlock.length; k > 0; k--)
			{
				Block(currBlock[k - 1]).update();
			}
		}
		else
		{
			if (Block.left > 0)
			{
				makeBlock(0,   0);
				makeBlock(420, 570);
			}
		}

		while (Block.toCrawl.length)
		{
			i = Block.toCrawl.pop();
			BlockCrawler.startNewCrawl(i.x,i.y, i.color);
		}

		if (! levelRestart && ! levelCompleted)
		{
			for each (var b:Block in tiles)
			{
				if (b)
				{
					b.blink();
				}
			}
		}

		if (Block.playMove)
		{
			(new SFX_Move).play(0, 0, Weirdtris.soundTransform);
			Block.playMove = false;
		}

		Control.resetHits();
	}

	public static function completed():void
	{
		if (levelCompleted)
		{
			return;
		}


		//kongSubmitStats("Placed in " + levelID, Block.kongUsedInLevel);
		Block.kongUsedInLevel = 0;

		(new SFX_Yeah).play(0, 0, Weirdtris.soundTransform);

		starVomiter = 40;

		levelCompleted = true;

		var k:int;
		var bl:Blinker;

		for (k = effects.length; k > 0; k--)
		{
			if (effects[k - 1] is Blinker)
			{
				bl = Blinker(effects[k - 1]);
				bl.kill();
				bl.removeFromList();
			}
		}

		var i:Block;
		for each (i in falling)
		{
			new Fader(i.gfx,i);
		}

		for each (i in tiles)
		{
			if (i != null)
			{
				new Fader(i.gfx,i);
			}
		}

		for each (i in currBlock)
		{
			new Fader(i.gfx,i);
		}
	}

	public static function restart():void
	{
		if (levelRestart || !gameStarted)
		{
			return;
		}

		levelRestart = true;

		for each (var eff:Fader in effects)
		{
			eff.kill();
		}

		effects.length = 0;

		var i:Block;
		for each (i in falling)
		{
			new Fader(i.gfx,i);
		}

		for each (i in tiles)
		{
			if (i != null)
			{
				new Fader(i.gfx,i);
			}
		}

		for each (i in currBlock)
		{
			new Fader(i.gfx,i);
		}

		score.set(scoreLast.get() * 0.9 | 0);
	}

	public static function makeBlock(x:Number, y:Number):void
	{
		/**/

		var color:int = colors[Math.floor(Math.random() * colors.length)];
		var count:uint = 0;

		if (! typeSurvival)
		{
			while (Block.colsLeft[color] == 0)
			{
				color = colors[Math.floor(Math.random() * colors.length)];
				if (count++ > 600)
				{
					break;
				}
			}
		}


		switch (color)
		{
			case (0) :
				new Block(x, y, 0, new _BLOCK_BLUE(),   true);
				break;
			case (1) :
				new Block(x, y, 1, new _BLOCK_GREEN(),  true);
				break;
			case (2) :
				new Block(x, y, 2, new _BLOCK_ORANGE(), true);
				break;
			case (3) :
				new Block(x, y, 3, new _BLOCK_RED(),    true);
				break;
			case (4) :
				new Block(x, y, 4, new _BLOCK_TURQ(),   true);
				break;
			case (5) :
				new Block(x, y, 5, new _BLOCK_YELLOW(), true);
				break;
		}
	}
}
}