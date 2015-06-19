package comp
{
	import core.Assets;
	import flash.display.*;
	import idv.cjcat.stardust.common.actions.Age;
	import idv.cjcat.stardust.common.actions.AlphaCurve;
	import idv.cjcat.stardust.common.actions.DeathLife;
	import idv.cjcat.stardust.common.clocks.Clock;
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.initializers.Life;
	import idv.cjcat.stardust.common.initializers.Scale;
	import idv.cjcat.stardust.common.math.UniformRandom;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.threeD.actions.Move3D;
	import idv.cjcat.stardust.threeD.actions.StardustSpriteUpdate3D;
	import idv.cjcat.stardust.threeD.emitters.Emitter3D;
	import idv.cjcat.stardust.threeD.initializers.DisplayObjectClass3D;
	import idv.cjcat.stardust.threeD.initializers.Position3D;
	import idv.cjcat.stardust.threeD.initializers.Velocity3D;
	import idv.cjcat.stardust.threeD.zones.CubeZone;
	import idv.cjcat.stardust.twoD.display.StardustSprite;
	
	public class SakuraPetalWrapper extends StardustSprite
	{
		private var innerWrapper:Sprite;
		private var petalOmega:Number;
		private var petel:Bitmap;
		private var phase:Number;
		private var scaleXRate:Number;
		private var selfOmega:Number;
		
		public function SakuraPetalWrapper()
		{
			phase = 0;
			//petel = new Bitmap(Main.petelBmd);
			petel = new Assets.LOBBY_P1();
			innerWrapper = new Sprite();
			innerWrapper.addChild(petel);
			petel.rotation = Math.random() * 360;
			rotation *= Math.random() * 360;
			selfOmega = Math.random() * 10;
			petalOmega = Math.random() * 10;
			scaleXRate = Math.random() * 0.03 + 0.07;
			addChild(innerWrapper);
		}
		
		override public function update(emitter:Emitter, particle:Particle, time:Number):void
		{
			petel.rotation += petalOmega * time;
			rotation += selfOmega * time;
			phase += time;
			innerWrapper.scaleX = Math.sin(scaleXRate * phase);
		}
	}

}