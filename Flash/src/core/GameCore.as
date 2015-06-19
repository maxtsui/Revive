package core 
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.Font;
	import scene.*;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import utils.SpriteUtil;
	import utils.SqliteUtil;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Max
	 */
	public class GameCore extends Sprite
	{
		public static var STAGE:Stage;
		public static var CONTAINER:Object;
		public static const SIZE:Point = new Point(750, 1334);
		private static var RIPPE_TEXTURE:Texture;
		protected var myScene:Object;
		private var listRippe:Array = [];
		
		public function GameCore() 
		{
			init();
		}
		
		private function init():void
		{
			Font.registerFont(Assets.FONT_EDWARDIAN);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			//this.addEventListener(TouchEvent.TOUCH, onTouch);
			if (listRippe.length == 0)
			{
				for (var i:int = 0; i < 50; i++)
				{
					listRippe.push(getRippe());
				}
			}
		}
		
		private function onStage(e:Event):void
		{
			fitSceneSize();
			switchScene(HomeScene);
			SqliteUtil.createDB();
		}
		
		private function fitSceneSize():void
		{
			STAGE = this.stage;
			var r1:Number = this.stage.stageWidth / SIZE.x;
			var r2:Number = this.stage.stageHeight / SIZE.y;
			var r:Number = Math.min(r1, r2);
			var w:Number = SIZE.x * r;
			var h:Number = SIZE.y * r;
			this.scaleX = r;
			this.scaleY = r;
			this.x = Math.max((this.stage.stageWidth - w), 0) / 2;
			this.y = Math.max((this.stage.stageHeight - h), 0) / 2;
			
			var spr:flash.display.Sprite = new flash.display.Sprite();
			spr.graphics.beginFill(0x000000);
			spr.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
			spr.graphics.endFill();
			spr.graphics.beginFill(0xFFFFFF);
			spr.graphics.drawRect(this.x, this.y, w, h);
			spr.graphics.endFill();
			var bitmapData:BitmapData = new BitmapData(this.stage.stageWidth, this.stage.stageHeight);
			bitmapData.draw(spr);
			var texture:Texture = Texture.fromBitmapData(bitmapData);
			var bg:Image = new Image(texture);
			bitmapData.dispose();
			bg.touchable = false;
			this.stage.addChildAt(bg, 0);
		}
		
		private function switchScene(cls:Class):void
		{
			if (this.myScene)
			{
				this.myScene.removeEventListener(DataEvent.MSG, onSceneMsg);
				var oldScene:BaseScene = this.myScene as BaseScene;
				var container:DisplayObjectContainer = this;
				var newScene:BaseScene = new cls();
				TweenLite.killTweensOf(oldScene);
				myScene = newScene;
				myScene.addEventListener(DataEvent.MSG, onSceneMsg);
				TweenLite.to(oldScene, 1, { alpha: 0, ease: Linear.easeIn, onComplete: function():void
				{
					oldScene.parent.removeChild(oldScene, true);
					container.addChildAt(newScene, 0);
					newScene.alpha = 0;
					TweenLite.to(newScene, 0.75, { alpha: 1, delay: 0.25,  ease: Linear.easeOut } );
				}});
			}
			else
			{
				this.myScene = new cls();
				this.myScene.addEventListener(DataEvent.MSG, onSceneMsg);
				this.addChildAt(this.myScene as DisplayObject, 0);
			}
		}
		
		private function onSceneMsg(e:DataEvent):void
		{
			switch(e.eventData.action)
			{
				case HomeScene.GO_TO_LOBBY:
					switchScene(LobbyScene);
					break;
				case LobbyScene.GO_TO_GAME:
					switchScene(GameScene);
					this.myScene.startGame(e.eventData.data);
					break;
				case GameScene.GO_TO_RESULT:
					switchScene(Result2Scene);
					this.myScene.setResult(e.eventData.data);
					break;
				case "gotoEnd":
					switchScene(EndingScene);
					break;
			}
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var listTouch:Vector.<Touch> = e.getTouches(GameCore.STAGE, TouchPhase.BEGAN);
			listTouch = e.getTouches(GameCore.STAGE, TouchPhase.MOVED, listTouch);
			for each (var touch:Touch in listTouch)
			{
				var rippe:Image;
				if (listRippe.length == 0)
				{
					rippe = getRippe();
				}
				else
				{
					rippe = listRippe.pop();
				}
					
 				var xy:Point = touch.getLocation(GameCore.STAGE);
				SpriteUtil.addChild(this.stage, rippe, "effect", xy.x - 10, xy.y - 10) as Image;
				rippe.scaleX = 5;
				rippe.scaleY = 5;
				TweenLite.from(rippe, 1, { scaleX:0, scaleY:0, alpha: 0.25, onComplete:function():void { rippe.parent.removeChild(rippe); listRippe.push(rippe); } } );
				break;
			}
		}
		
		private function getRippe():Image
		{
			if (RIPPE_TEXTURE == null)
			{
				var bitmap:Bitmap = new Assets.HOME_RIPPLE();
				RIPPE_TEXTURE = Texture.fromBitmap(bitmap);
				bitmap.bitmapData.dispose();
			}
				
			var rippe:Image = new Image(RIPPE_TEXTURE);
			rippe.pivotX = rippe.width / 2;
			rippe.pivotY = rippe.height / 2;
			rippe.blendMode = BlendMode.ADD;
			rippe.alpha = 0;
			rippe.scaleX = 2;
			rippe.scaleY = 2;
			rippe.touchable = false;
			return rippe;
		}
	}

}