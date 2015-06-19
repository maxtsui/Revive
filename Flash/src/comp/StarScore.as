package comp 
{
	import com.greensock.TimelineMax;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import core.Assets;
	import utils.SpriteUtil;
	/**
	 * ...
	 * @author Max
	 */
	public class StarScore extends Sprite
	{
		private var starA:Array = [];
		private var starB:Array = [];
		private var starE:Array = [];
		private var listTimeline:Vector.<TimelineMax> = Vector.<TimelineMax>([]);
		
		public function StarScore() 
		{
			for (var i:int = 0; i < 5; i++)
			{
				starA.push(SpriteUtil.getImage(Assets.LOBBY_STAR_EMPTY));
				starB.push(SpriteUtil.getImage(Assets.LOBBY_STAR_FULL));
				starE.push(SpriteUtil.getImage(Assets.LOBBY_STAR_EFFECT));
				var star:Image = starE[i];
				star.pivotX = star.width / 2;
				star.pivotY = star.height / 2;
				star.scaleX = 0.8;
				star.scaleY = 0.8;
				var timeline:TimelineMax = new TimelineMax( { repeat: -1 } );
				timeline.to(star, 0.5, { scaleX:1.15, scaleY:1.15 } );
				timeline.to(star, 0.5, { scaleX:0.8, scaleY:0.8 } );
				listTimeline.push(timeline);
			}
		}
		
		public function setScore(score:int):void
		{
			while (this.numChildren)
			{
				this.removeChildAt(0);
			}
			for each(var timeline:TimelineMax in listTimeline)
			{
				timeline.stop();
			}
			for (var i:int = 0; i < 5; i++)
			{
				if (score > i)
				{
					var effect:Image = starE[i];
					effect.x = 40 * i + 20;
					effect.y = 18;
					this.addChild(effect);
					listTimeline[i].restart();
				}
				var star:DisplayObject = score > i? starB[i]: starA[i];
				this.addChild(star);
				star.x = 40 * i;
			}
		}
		
		override public function dispose():void 
		{
			super.dispose();
			for (var i:int = 0; i < 5; i++)
			{
				(starA[i] as Image).texture.base.dispose();
				(starB[i] as Image).texture.base.dispose();
				(starE[i] as Image).texture.base.dispose();
				listTimeline[i].stop();
				listTimeline[i].clear();
			}
		}
	}

}