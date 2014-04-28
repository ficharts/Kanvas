package com.kvs.ui.dragDrop
{
	import com.kvs.utils.Map;

	public class DragDropManager
	{
		public function DragDropManager()
		{
		}
		
		/**
		 */		
		public static function resiter(id:String, dropper:DragDropper):void
		{
			map.put(id, dropper);
		}
		
		/**
		 */		
		private static var map:Map = new Map;
	}
}