package core 
{
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Max
	 */
	public class DataEvent extends Event 
	{
		public static const MSG:String = "msg";
		public var eventData:Object;
		
		public function DataEvent(_data:Object, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(MSG, bubbles, cancelable);
			this.eventData = _data;
		}
		
	}

}