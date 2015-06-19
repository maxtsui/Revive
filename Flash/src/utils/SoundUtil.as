package utils 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Max
	 */
	public class SoundUtil 
	{
		private static const list:Dictionary = new Dictionary();
		
		public static function playSound(sc:Class, ch:int = 0):SoundChannel
		{
			stopSound(ch);
			var sound:Sound = new sc() as Sound;
			var channel:SoundChannel = sound.play(1);
			list[ch] = channel;
			return channel;
		}
		
		public static function stopSound(ch:int = 0):void
		{
			if (list[ch] is SoundChannel)
			{
				(list[ch] as SoundChannel).stop();
			}
		}
	}

}