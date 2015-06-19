package 
{
	import core.GameCore;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import scene.LobbyScene;
	import starling.core.Starling;
	import org.gestouch.core.Gestouch;
	import org.gestouch.input.NativeInputAdapter;
	import org.gestouch.extensions.starling.StarlingDisplayListAdapter;
	import org.gestouch.extensions.starling.StarlingTouchHitTester
	import starling.display.DisplayObject;
	import utils.SqliteUtil;
	
	/**
	 * ...
	 * @author Max
	 */
	public class Main extends Sprite 
	{
		
		private var _starling:Starling;
		
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// entry point
			
			// new to AIR? please read *carefully* the readme.txt files!
			//GameCore.container = this;
			GameCore.CONTAINER = this;
			_starling = new Starling(GameCore, stage);
			_starling.start();
			
			Gestouch.inputAdapter = new NativeInputAdapter(stage);
			Gestouch.addDisplayListAdapter(DisplayObject, new StarlingDisplayListAdapter());
			Gestouch.addTouchHitTester(new StarlingTouchHitTester(_starling), -1);
		}
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			SqliteUtil.updateHP(LobbyScene.HP, LobbyScene.RECOVERTIME, (new Date()).time);
			NativeApplication.nativeApplication.exit();
		}
		
	}
	
}