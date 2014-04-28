package util.undoRedo
{
	import flash.events.Event;
	
	/**
	 */	
	public class UndoRedoEvent extends Event
	{
		/**
		 * 可撤销
		 */		
		public static const ENABLE:String = 'enable';
		
		/**
		 * 不可撤消
		 */		
		public static const DISABLE:String = 'disable';
		
		/**
		 */		
		public function UndoRedoEvent(type:String, operation:String)
		{
			super(type, true);
			this.operation = operation;
		}
		
		/**
		 */		
		override public function clone():Event
		{
			return new UndoRedoEvent(type, operation);
		}
		
		public var operation:String;
	}
}