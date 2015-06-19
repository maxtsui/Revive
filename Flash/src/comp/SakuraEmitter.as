package comp
{
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
	
	public class SakuraEmitter extends Emitter3D
	{
		public function SakuraEmitter(clock:Clock)
		{
			super(clock);
			//initializers
			addInitializer(new DisplayObjectClass3D(SakuraPetalWrapper));
			addInitializer(new Life(new UniformRandom(140, 60)));
			addInitializer(new Position3D(new CubeZone(-200, -900, -200, 1600, 300, 1600)));
			addInitializer(new Velocity3D(new CubeZone(-30, 10, -30, 30, 10, 30)));
			addInitializer(new Scale(new UniformRandom(1, 0.3)));
			//actions
			addAction(new Age());
			addAction(new Move3D());
			addAction(new DeathLife());
			addAction(new StardustSpriteUpdate3D());
			addAction(new AlphaCurve(15, 15));
		}
	}

}