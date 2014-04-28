package com.kvs.charts.chart2D.core.zoomBar
{
	import com.kvs.charts.chart2D.core.model.DataRender;
	import com.kvs.utils.interactive.DragControl;
	import com.kvs.utils.interactive.IDragCanvas;
	
	import flash.display.Sprite;
	
	public class ZoomPointLeft extends Sprite implements IDragCanvas
	{
		public function ZoomPointLeft(zoomBar:ZoomBar)
		{
			super();
			
			this.zoomBar = zoomBar;
			this.addChild(leftZoomPoint);
			
			dragControl = new DragControl(leftZoomPoint, this);
		}
		
		/**
		 */		
		private var zoomBar:ZoomBar;
		
		/**
		 */		
		public var max:Number;
		
		/**
		 * 
		 */		
		public function startScroll():void
		{
			
		}
		
		/**
		 */		
		public function scrolling(offset:Number, sourceOffset:Number):void
		{
			leftZoomPoint.x += offset;
			
			if (leftZoomPoint.x < 0)
				leftZoomPoint.x = 0
			else if (leftZoomPoint.x > max)
				leftZoomPoint.x = max;
			
			zoomBar.zoomWinLeft(leftZoomPoint.x);
		}
		
		/**
		 */		
		public function stopScroll(offset:Number, sourceOffset:Number):void
		{
			
		}
		
		/**
		 */		
		private var dragControl:DragControl;
		
		/**
		 */		
		internal function update(x:Number, w:Number):void
		{
			leftZoomPoint.x = x;
		}
		
		/**
		 */		
		public function render():void
		{
			//以填充色为基准
			leftZoomPoint.mdata = mdata;
			this.leftZoomPoint.render();
		}
		
		/**
		 */		
		public var mdata:Object;
		
		/**
		 */		
		public function setZoomPointRender(render:DataRender):void
		{
			render.toNormal();
			leftZoomPoint.dataRender = render;
		}
		
		/**
		 */		
		private var leftZoomPoint:ZoomPointUI = new ZoomPointUI;
		
	}
}