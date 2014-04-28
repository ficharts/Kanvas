package com.kvs.charts.chart2D.pie.series
{
	import com.kvs.charts.chart2D.core.events.FiChartsEvent;
	import com.kvs.charts.chart2D.core.series.SeriesItemUIBase;
	import com.kvs.charts.common.SeriesDataPoint;
	import com.kvs.ui.toolTips.ToolTipHolder;
	import com.kvs.ui.toolTips.ToolTipsEvent;
	import com.kvs.ui.toolTips.TooltipStyle;
	import com.kvs.utils.XMLConfigKit.style.LabelStyle;
	import com.kvs.ui.label.LabelUI;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import flash.events.MouseEvent;
	
	/**
	 */	
	public class PartPieUI extends SeriesItemUIBase
	{
		public function PartPieUI(dataItem:SeriesDataPoint)
		{
			super(dataItem);
			
			radDis = (pieDataItem.endRad - pieDataItem.startRad);
			midRad = pieDataItem.startRad + radDis / 2;
		}
		
		/**
		 */		
		private var tooltipHolder:ToolTipHolder = new ToolTipHolder();
		
		/**
		 */		
		override protected function rollOverHandler(evt:MouseEvent):void
		{
			var event:FiChartsEvent = new FiChartsEvent(FiChartsEvent.ITEM_OVER);
			event.dataItem = this.dataItem;
			this.dispatchEvent(event);
			
			this.dispatchEvent(new ToolTipsEvent(ToolTipsEvent.SHOW_TOOL_TIPS, tooltipHolder));
		}
		
		/**
		 */		
		override protected function rollOutHandler(evt:MouseEvent):void
		{
			var event:FiChartsEvent = new FiChartsEvent(FiChartsEvent.ITEM_OUT);
			event.dataItem = this.dataItem;
			this.dispatchEvent(event);
			
			this.dispatchEvent(new ToolTipsEvent(ToolTipsEvent.HIDE_TOOL_TIPS));
		}
		
		/**
		 */		
		override public function downHandler():void
		{
			var event:FiChartsEvent = new FiChartsEvent(FiChartsEvent.ITEM_CLICKED);
			event.dataItem = this.dataItem;
			this.dispatchEvent(event);
		}
		
		/**
		 */		
		public function init():void
		{
			valueLabelUI = new LabelUI;
			valueLabelUI.mdata = this.dataItem.metaData;
			valueLabelUI.style = this.labelStyle;
			valueLabelUI.render();
			addChild(valueLabelUI);
			
			tooltipHolder.metaData = dataItem.metaData;
			tooltipHolder.style = tooltipStyle;
		}
		
		/**
		 */		
		public var labelStyle:LabelStyle;
		
		/**
		 */		
		public var tooltipStyle:TooltipStyle;
		
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
		override public function render():void
		{
			this.graphics.clear();
			
			currState.tx = - radius;
			currState.ty = - radius;
			currState.width = currState.height = radius * 2;
			
			StyleManager.drawArc(this, currState, radius, rads, pieDataItem.metaData);
			
			layoutValueLabel();
		}
		
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
		private var valueLabelUI:LabelUI;
		
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