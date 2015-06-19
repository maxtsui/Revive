package utils 
{
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	/**
	 * ...
	 * @author Max
	 */
	public class SqliteUtil 
	{
		private static var conn:SQLConnection;
		
		public static function createDB():void
		{
			var file:File = File.applicationStorageDirectory.resolvePath("data.db");
			conn = new SQLConnection();
			conn.addEventListener(SQLEvent.OPEN, onOpen);
			conn.open(file);
		}
		
		public static function update(id:int, score:int, lock:int):void
		{
			getStatement("REPLACE INTO score(id, score, lock) VALUES(" + id.toString() + "," + score.toString() + "," + lock.toString() + ");").execute();
		}
		
		public static function updateHP(hp:int, recoverTime:Number, endTime:Number):void
		{
			getStatement("REPLACE INTO hp(id, hp, recoverTime, endTime) VALUES(1," + hp.toString() + "," + recoverTime.toString() + "," + endTime.toString() + ");").execute();
		}
		
		public static function getHP():SQLStatement
		{
			return getStatement("SELECT * FROM hp");
		}
		
		public static function getData():SQLStatement
		{
			return getStatement("SELECT * FROM score");
		}
		
		private static function onOpen(e:SQLEvent):void
		{
			getStatement("CREATE TABLE IF NOT EXISTS score(id INTEGER PRIMARY KEY, score INTEGER, lock INTEGER);").execute();
			getStatement("CREATE TABLE IF NOT EXISTS hp(id INTEGER PRIMARY KEY, hp INTEGER, recoverTime NUMERIC, endTime NUMERIC);").execute();
		}
		
		private static function getStatement(value:String):SQLStatement
		{
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = conn;
			statement.text = value;
			return statement;
		}
	}

}