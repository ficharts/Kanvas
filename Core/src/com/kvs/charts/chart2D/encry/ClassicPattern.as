package com.kvs.charts.chart2D.encry
{
	import com.kvs.charts.chart2D.bubble.BubblePointRender;
	import com.kvs.charts.chart2D.column2D.ColumnSeries2D;
	import com.kvs.charts.chart2D.core.axis.AxisBase;
	import com.kvs.charts.chart2D.core.events.FiChartsEvent;
	import com.kvs.charts.chart2D.core.itemRender.ItemRenderEvent;
	import com.kvs.charts.chart2D.core.itemRender.PointRenderBace;
	import com.kvs.charts.chart2D.marker.MarkerSeries;
	import com.kvs.charts.common.IDisCombilePointRender;
	import com.kvs.ui.label.LabelUI;
	import com.kvs.ui.toolTips.TooltipDataItem;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * 
	 * 经典渲染模式有动画，有数据点和数值标签
	 */	
	public class ClassicPattern implements IChartPattern
	{
		public function ClassicPattern(base:CB)
		{
			chartMain = base;
		}
		
		/**
		 */		
		public function preConfig():void
		{
			
		}
		
		/**
		 */		
		public function renderSeries():void
		{
			for each(var series:SB in chartMain.chartSeries)
				series.render();
		}
		
		/**
		 */		
		private var chartMain:CB;
		
		/**
		 */		
		public function init():void
		{
		}
		
		/**
		 */		
		public function toZoomPattern():void
		{
		}
		
		/**
		 */		
		public function toClassicPattern():void
		{
		}
		
		/**
		 */		
		public function configSeriesAxis(scrolAxis:AxisBase):void
		{
		}
		
		/**
		 */		
		public function getItemRenderFromSereis():void
		{
			itemRenders = [];
			chartMain.chartCanvas.clearItemRenders();
			
			// 汇总  节点渲染器；
			for each (var seriesItem:SB in chartMain.chartSeries)
			{
				// 柱状图与散点图的节点渲染器优先作为主体渲染节点
				if (seriesItem is ColumnSeries2D || seriesItem is MarkerSeries)
				{
					var renders:Array = [];
					renders = renders.concat(seriesItem.itemRenders);
					itemRenders = renders.concat(itemRenders);
				}
				else
				{
					itemRenders = itemRenders.concat(seriesItem.itemRenders);
				}
			}
			
			leftOffBubblesItemRender();// 调节显示列表深度；
			for each (var itemRender:PointRenderBace in itemRenders)
			{
				if (itemRender)
				{
					itemRender.render();
					chartMain.chartCanvas.addItemRender(itemRender);
				}
			}
		}
		
		/**
		 */		
		public function renderItemRenderAndDrawValueLabels():void
		{
			for each (var itemRender:PointRenderBace in itemRenders)
			{
				if (itemRender)
					itemRender.layout();
			}
			
			chartMain.chartCanvas.clearValuelabels();
			drawValueLabels(itemRenders);
		}
		
		/**
		 */		
		public function updateValueLabelHandler(evt:ItemRenderEvent):void
		{
			chartMain.chartCanvas.clearValuelabels();
			drawValueLabels(this.itemRenders);
		}
		
		/**
		 * 当布局或者图例显示状态发生改变时更新数值标签显示；
		 */		
		private function drawValueLabels(renders:Array):void
		{
			var px:Number;
			var py:Number;
			var bd:LabelUI;
			
			for each (var itemRender:PointRenderBace in renders)
			{
				if (itemRender == null) continue;
				if (itemRender.valueLabel.enable == false) continue;
				
				px = itemRender.x + itemRender.valueLabelUI.x;
				py = itemRender.y + itemRender.valueLabelUI.y;
				
				bd = itemRender.valueLabelUI;
				
				if (itemRender.valueLabelUI.visible && itemRender.isEnable && itemRender.visible)
				{
					bd.x = px;
					bd.y = py;
					chartMain.chartCanvas.addValueLabel(bd);
				}
			}
		}
		
		/**
		 * 把汽包渲染器靠前排列， 这样可以先加入显示列表， 不至于遮盖住其他节点渲染器；
		 */		
		private function leftOffBubblesItemRender():void
		{
			var bubbles:Array = [];
			var length:uint = itemRenders.length;
			for (var i:uint = 0; i < length;)
			{
				if (itemRenders[i] is BubblePointRender)
				{
					bubbles.push(itemRenders[i]);
					itemRenders.splice(i, 1);
					length -= 1;
				}
				else
				{
					i ++;
				}
			}
			
			bubbles.sort(orderBubbles, Array.NUMERIC);
			itemRenders = bubbles.concat(itemRenders);
		}
		
		/**
		 * 从大到小排列Bubble,大的在下， 小的在上显示；
		 */		
		private function orderBubbles(prev:BubblePointRender, next:BubblePointRender):int
		{
			if (Number(prev.itemVO.zValue) < Number(next.itemVO.zValue))
				return 1;
			else if (Number(prev.itemVO.zValue) > Number(next.itemVO.zValue))
				return - 1;
			else 
				return 0;
		}
		
		/**
		 */
		protected var itemRenders:Array;
		
		/**
		 * 
		 * 仅当动画开关开启并且初次加载时动画才会播放；
		 * 
		 * 如果开启滤镜效果会特别豪资源，所以在动画播放之前要关闭滤镜效果；
		 * 
		 */		
		public function renderEnd():void
		{
			var seriesItem:SB;
			
			// 为播放动画做准备；
			if (chartMain.chartModel.animation && ifFirstRender)
			{
				flashSeriesPercent = 0;
				chartMain.chartCanvas.setItemAndValueLabelsAlpha(flashItemRenderPercent);
			}
			else
			{
				flashSeriesPercent = 1;
			}
			
			for each (seriesItem in chartMain.chartSeries)
			seriesItem.percent = flashSeriesPercent;
			
			//播放动画
			if (chartMain.chartModel.animation && ifFirstRender)
			{
				flashTimmer.addEventListener(TimerEvent.TIMER, flashSeriesHandler, false, 0, true);
				flashTimmer.start();
			}
			else
			{
				chartMain.dispatchEvent(new FiChartsEvent(FiChartsEvent.RENDERED));
			}
		}
		
		/**
		 */		
		private function flashSeriesHandler(evt:Event):void
		{
			flashSeriesPercent += .05;
			if (flashSeriesPercent > 1)
			{
				ifFirstRender = false;// 新数据渲染动画仅播放一次；
				flashSeriesPercent = 1;
				flashTimmer.stop();
				flashTimmer.removeEventListener(TimerEvent.TIMER, flashSeriesHandler);
				
				// 柱体动画播放完毕后播放渲染节点动画；
				flashItemRenderPercent = .05;
				flashTimmer.addEventListener(TimerEvent.TIMER, flashItemRendersHandler, false, 0, true);
				flashTimmer.start();
			}
			
			for each (var seriesItem:SB in chartMain.chartSeries)
				seriesItem.percent = flashSeriesPercent;
		}
		
		/**
		 */		
		private function flashItemRendersHandler(evt:TimerEvent):void
		{
			flashItemRenderPercent += .1;
			if (flashItemRenderPercent >= 1)
			{
				flashItemRenderPercent = 1;
				flashTimmer.stop();
				flashTimmer.removeEventListener(TimerEvent.TIMER, flashItemRendersHandler);
				
				chartMain.dispatchEvent(new FiChartsEvent(FiChartsEvent.RENDERED));
			}
			
			chartMain.chartCanvas.setItemAndValueLabelsAlpha(flashItemRenderPercent);
		}
		
		/**
		 */		
		private var flashSeriesPercent:Number;
		
		/**
		 */		
		private var flashItemRenderPercent:Number;
		
		/**
		 */		
		private var ifFirstRender:Boolean = true;
		
		/**
		 */		
		private var flashTimmer:Timer = new Timer(30, 0);
		
		/**
		 */		
		public function scaleData(startValue:Object, endValue:Object):void
		{
		}
	}
}