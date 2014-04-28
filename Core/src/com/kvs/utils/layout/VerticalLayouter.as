package com.kvs.utils.layout
{
	/**
	 */	
	public class VerticalLayouter
	{
		public function VerticalLayouter()
		{
		}
		
		/**
		 */		
		public function ready():void
		{
			rowIndex = 0;
		}
		
		/**
		 */		
		public var locX:Number = 0;
		
		/**
		 */		
		public var locY:Number = 0;
		
		/**
		 */		
		private var rowIndex:uint = 0;
		
		/**
		 */		
		public function layout(item:IBoxItem):void
		{
			if (width == 0)
				width = item.w + gap * 2;
			
			item.x = locX + gap;
			item.y = locY + gap + (item.h + gap) * rowIndex;
			
			height = item.y + item.h + gap - locY;
			
			rowIndex ++;
		}
		
		/**
		 */		
		public var width:Number = 0;
		
		/**
		 */		
		public var height:Number = 0;
		
		/**
		 */		
		public var gap:uint = 10;
	}
}