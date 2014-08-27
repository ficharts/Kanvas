package com.kvs.charts.chart2D.pie.series
{
	import com.kvs.charts.common.SeriesDataPoint;
	import com.kvs.ui.label.LabelUI;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.style.LabelStyle;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import flash.display.Sprite;
	
	/**
	 */	
	public class PartPieUI
	{
		public function PartPieUI(dataItem:SeriesDataPoint)
		{
			this.dataItem = dataItem;
			
			radDis = (pieDataItem.endRad - pieDataItem.startRad);
			midRad = pieDataItem.startRad + radDis / 2;
		}
		
		/**
		 */		
		public function init():void
		{
			valueLabelUI = new LabelUI;
			valueLabelUI.mdata = this.dataItem.metaData;
			valueLabelUI.style = this.labelStyle;
			valueLabelUI.render();
		}
		
		/**
		 */		
		public var labelStyle:LabelStyle;
		
		/**
		 */
		public function get rads():Vector.<Number>
		{
			return _rads;
		}

		/**
		 * @private
		 */
		public function set rads(value:Vector.<Number>):void
		{
			_rads = value;
		}

		/**
		 */		
		public function get angleRadRange():Number
		{
			return pieDataItem.endRad - pieDataItem.startRad;
		}
		
		/**
		 */		
		public function get pieDataItem():PieDataItem
		{
			return dataItem as PieDataItem;
		}
		
		/**
		 */		
		private var dataItem:SeriesDataPoint;
		
		/**
		 */		
		public function render(canvas:Sprite):void
		{
			currState.tx = - radius;
			currState.ty = - radius;
			currState.width = currState.height = radius * 2;
			
			StyleManager.drawArc(canvas, currState, radius, rads, pieDataItem.metaData);
			
			layoutValueLabel();
		}
		
		/**
		 */		
		public var currState:Style;
		
		/**
		 * 调整数值标签的位置及显示
		 */		
		private function layoutValueLabel():void
		{
			if (ifSizeChanged)
			{
				var radius:Number = this.radius - valueLabelUI.width / 2;
					
				valueLabelUI.layout(radius * Math.cos(midRad), - radius * Math.sin(midRad));
				
				if (valueLabelUI.height * 0.5 > radDis * radius)
					valueLabelUI.visible = false;
				else
				{
					if (labelStyle.enable)
						valueLabelUI.visible = true;
				}
				
				ifSizeChanged = false;
			}
		}
		
		
		/**
		 */		
		public var valueLabelUI:LabelUI;
		
		/**
		 */		
		private var _rads:Vector.<Number>
		
		
		/**
		 * 扇形弧度的中间值， 用来定位数值标签的位置； 
		 */		
		private var midRad:Number;
		
		/**
		 * 弧度间隔， 
		 */		
		private var radDis:Number;
		
		
		/**
		 */		
		private var _radius:Number = 0;

		/**
		 */
		public function get radius():Number
		{
			return _radius;
		}

		/**
		 * @private
		 */
		public function set radius(value:Number):void
		{
			if (_radius != value)
			{
				_radius = value;
				ifSizeChanged = true;			
			}
		}

		/**
		 */		
		private var ifSizeChanged:Boolean = false;

	}
}