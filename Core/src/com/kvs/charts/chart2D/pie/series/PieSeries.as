package com.kvs.charts.chart2D.pie.series
{
	import com.kvs.charts.chart2D.core.itemRender.ItemRenderEvent;
	import com.kvs.charts.chart2D.pie.PieChartModel;
	import com.kvs.charts.chart2D.pie.PieDataFormatter;
	import com.kvs.charts.common.ChartColors;
	import com.kvs.utils.XMLConfigKit.Model;
	import com.kvs.charts.common.SeriesDataPoint;
	import com.kvs.charts.legend.model.LegendVO;
	import com.kvs.charts.legend.view.LegendEvent;
	import com.kvs.ui.toolTips.TooltipStyle;
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.RexUtil;
	import com.kvs.utils.XMLConfigKit.IEditableObject;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.effect.Effects;
	import com.kvs.utils.XMLConfigKit.effect.IEffectable;
	import com.kvs.utils.XMLConfigKit.style.LabelStyle;
	import com.kvs.utils.XMLConfigKit.style.States;
	import com.kvs.utils.XMLConfigKit.style.elements.IStyleElement;
	import com.kvs.utils.dec.NullPad;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import flash.display.Sprite;

	/**
	 */	
	public class PieSeries extends Sprite implements IEditableObject, IStyleElement, IEffectable
	{
		public function PieSeries()
		{
		}
		
		/**
		 */		
		public function render():void
		{
			var partUI:PartPieUI;
			
			if (this.ifDataChanged)
			{
				while (this.numChildren)
					this.removeChildAt(0);
				
				var dataItem:PieDataItem;
				partUIs = new Vector.<PartPieUI>;
				
				for each (dataItem in this.dataItemVOs)
				{
					partUI = new PartPieUI(dataItem);
					partUI.states = this.states;
					partUI.labelStyle = this.valueLabel;
					partUI.tooltipStyle = this.tooltip;
					partUI.init();
					partUIs.push(partUI);
					addChild(partUI);
				}
			}
			
			if (ifSizeChanged || ifDataChanged)
			{
				for each(partUI in this.partUIs)
				{
					partUI.radius = this.radius;
					partUI.rads = new Vector.<Number>;
					
					var partRad:Number = precisionRad;
					var rad:Number = 0;
					var segment:uint = Math.ceil(partUI.angleRadRange / partRad);
					
					for (var i:uint = 0; i < segment; i ++)
					{
						if (i == segment - 1) // Last point.
						{
							rad = partUI.pieDataItem.endRad;
						}
						else
						{
							rad = partUI.pieDataItem.startRad + partRad * i;
						}
						
						partUI.rads.push(rad);
					}
					
					partUI.render();
					
					StyleManager.setEffects(this, this, this);
				}
				
				this.ifDataChanged = this.ifSizeChanged = styleChanged = false;
				
			}
		}
		
		/**
		 */		
		public var styleChanged:Boolean = false;
		
		/**
		 */		
		private var _valueLabel:LabelStyle;

		/**
		 * 数值标签的样式 
		 */
		public function get valueLabel():LabelStyle
		{
			return _valueLabel;
		}

		/**
		 * @private
		 */
		public function set valueLabel(value:LabelStyle):void
		{
			_valueLabel = value;
		}

		/**
		 */		
		private var _tooltip:TooltipStyle;

		/**
		 * 信息提示的样式
		 */
		public function get tooltip():TooltipStyle
		{
			return _tooltip;
		}

		/**
		 * @private
		 */
		public function set tooltip(value:TooltipStyle):void
		{
			_tooltip = XMLVOMapper.updateObject(value, _tooltip, Model.TOOLTIP, this) as TooltipStyle;
		}

		/**
		 */		
		private function angleToRad(value:Number):Number
		{
			return value * Math.PI / 180;
		}
		
		/**
		 * @return 
		 */		
		private function get precisionRad():Number
		{
			return precisionLength / this.radius;
		}
		
		/**
		 * 弧线的等分距离，决定了弧线的光滑度，
		 */		
		private var precisionLength:Number = 0.5;
		
		/**
		 */		
		private var partUIs:Vector.<PartPieUI>;
		
		/**
		 */		
		private var _radius:Number = 0;

		/**
		 * 饼图的半径自适应窗口尺寸
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
			if (value != _radius && value > 0)
			{
				_radius = value;
				ifSizeChanged = true;
			}
		}

		/**
		 */		
		private var ifSizeChanged:Boolean = false;
		
		/**
		 */		
		public function beforeUpdateProperties(xml:* = null):void
		{
			XMLVOMapper.fuck(XMLVOLib.getXML(PieChartModel.PIE_SERIES_STYLE, Model.SYSTEM), this);
			XMLVOMapper.fuck(XMLVOLib.getXML(PieChartModel.SERIES_DATA_STYLE, Model.SYSTEM), this);
		}
		
		/**
		 */		
		public function created():void
		{
			chartColorManager = new ChartColors;
		}
		
		/**
		 */		
		public function configed():void
		{
		}
		
		
		
		//-------------------------------------
		//
		// 图表颜色
		//
		//-------------------------------------
		
		/**
		 */		
		private var _color:Object

		public function get color():Object
		{
			return _color;
		}

		public function set color(value:Object):void
		{
			_color = StyleManager.setColor(value);;
		}
		
		/**
		 */		
		protected var chartColorManager:ChartColors;
		
		
		
		
		
		//------------------------------------------
		//
		// 图例控制， 仅对渲染节点
		//
		//------------------------------------------
		
		private function itemRenderOverHandler(evt:LegendEvent):void
		{
			evt.legendVO.metaData.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.SERIES_OVER));
		}
		
		private function itemRenderOutHandler(evt:LegendEvent):void
		{
			evt.legendVO.metaData.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.SERIES_OUT));
		}
		
		private function itemRenderHideHandler(evt:LegendEvent):void
		{
			evt.legendVO.metaData.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.SERIES_HIDE));
		}
		
		private function itemRenderShowHandler(evt:LegendEvent):void
		{
			evt.legendVO.metaData.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.SERIES_SHOW));
		}
		
		
		
		
		//---------------------------------------------------
		//
		// 数据字段的初始化
		//
		//---------------------------------------------------
		
		/**
		 */		
		public function initData(value:Vector.<Object>):void
		{
			var seriesDataItem:PieDataItem;
			var dataSum:Number = 0;
			var startRad:Number = 0;
			var partRad:Number = 0;
			dataItemVOs = new Vector.<PieDataItem>;
			
			var precision:uint = 0;
			var temPrecision:uint = 0;
			
			for each (var item:Object in value)
			{
				seriesDataItem = new PieDataItem;
				
				seriesDataItem.metaData = item;
				//XMLVOMapper.pushXMLDataToVO(item, seriesDataItem.metaData);//将XML转化为对象
				
				seriesDataItem.label = item[this.labelField]; 
				seriesDataItem.value = item[this.valueField]; 
				
				if (RexUtil.ifTextNull(seriesDataItem.label)&& RexUtil.ifTextNull(seriesDataItem.value))
				{
					seriesDataItem = null;				
					continue;
				}
				
				if (Number(seriesDataItem.value) < 0)
				{
					seriesDataItem = null;
					continue;				
				}
				
				if (color)
					seriesDataItem.color = uint(color);
				else
					seriesDataItem.color = chartColorManager.chartColor;
				
				dataSum += Number(seriesDataItem.value);
				dataItemVOs.push(seriesDataItem);
				
				// 计算小数点保留位数用
				temPrecision = RexUtil.checkPrecision(seriesDataItem.value.toString())
				if ( temPrecision > precision)
					precision = temPrecision;
			}
			
			dataFormatter.precision = precision;
			
			startRad = this.angleToRad(startAngle);
			 
			for each (seriesDataItem in dataItemVOs)
			{
				seriesDataItem.xLabel = dataFormatter.formatLabel(seriesDataItem.label);
				seriesDataItem.yLabel = dataFormatter.formatValue(seriesDataItem.value);
				
				seriesDataItem.zValue = Number(seriesDataItem.value) / dataSum * 100;
				seriesDataItem.zLabel = MathUtil.round(Number(seriesDataItem.zValue), 2) + '%';
				
				seriesDataItem.startRad = startRad;
				partRad = Number(seriesDataItem.zValue) / 100 * Math.PI * 2;
				seriesDataItem.endRad = startRad + partRad;
				startRad += partRad;
					
				XMLVOMapper.pushAttributesToObject(seriesDataItem, seriesDataItem.metaData, 
					['label', 'value', 'xLabel', 'yLabel', 'color', 'zValue', 'zLabel']);
				
				// 默认数值标签的元数据内容
				seriesDataItem.metaData.valueLabel = seriesDataItem.zLabel;
				
				// 默认tooltip
				seriesDataItem.metaData.tooltip = seriesDataItem.xLabel + "," + seriesDataItem.yLabel;
			}
			
			ifDataChanged = true;
		}
		
		/**
		 */		
		private var ifDataChanged:Boolean = false;
		
		/**
		 */		
		private var _startAngle:Number = 0

		public function get startAngle():Number
		{
			return _startAngle;
		}

		public function set startAngle(value:Number):void
		{
			_startAngle = value;
		}
		
		/**
		 */		
		private var dataItemVOs:Vector.<PieDataItem>;
		
		/**
		 */		
		public function get legendData():Vector.<LegendVO>
		{
			var legendVOes:Vector.<LegendVO> = new Vector.<LegendVO>;
			var legendVO:LegendVO;
			
			for each(var item:SeriesDataPoint in dataItemVOs)	
			{
				legendVO = new LegendVO();
				legendVO.metaData = item; // 用于精确控制节点的状态
				legendVO.addEventListener(LegendEvent.LEGEND_ITEM_OVER, itemRenderOverHandler, false, 0, true);
				legendVO.addEventListener(LegendEvent.LEGEND_ITEM_OUT, itemRenderOutHandler, false, 0, true);
				legendVO.addEventListener(LegendEvent.HIDE_LEGEND, itemRenderHideHandler, false, 0, true);
				legendVO.addEventListener(LegendEvent.SHOW_LEGEND, itemRenderShowHandler, false, 0, true);
				legendVOes.push(legendVO);
			}
			
			return legendVOes;
		}
		
		/**
		 */		
		private var _labelField:String;

		/**
		 */
		public function get labelField():String
		{
			return _labelField;
		}

		/**
		 * @private
		 */
		public function set labelField(value:String):void
		{
			_labelField = value;
		}

		/**
		 */		
		private var _valueField:String;

		public function get valueField():String
		{
			return _valueField;
		}

		public function set valueField(value:String):void
		{
			_valueField = value;
		}
		
		/**
		 */		
		private var _dataFormatter:PieDataFormatter;

		/**
		 */
		public function get dataFormatter():PieDataFormatter
		{
			return _dataFormatter;
		}

		/**
		 * @private
		 */
		public function set dataFormatter(value:PieDataFormatter):void
		{
			_dataFormatter = value;
		}
		
		
		
		
		//------------------------------------------------
		//
		//
		//  样式状态控制
		//
		//
		//------------------------------------------------
		
		
		/**
		 */		
		public function get states():States
		{
			return _states;
		}
		
		/**
		 */		
		public function set states(value:States):void
		{
			_states = XMLVOMapper.updateObject(value, _states, "states", this) as States;;
		}
		
		/**
		 */		
		private var _states:States;
		
		/**
		 */		
		protected var _style:String;
		
		/**
		 */
		public function get style():String
		{
			return _style;
		}
		
		/**
		 *  style 采取的是继承模式，更新原有样式
		 */
		public function set style(value:String):void
		{
			_style = XMLVOMapper.updateStyle(this, value, "pie");
		}
		
		/**
		 * 
		 * 以id方式定义style和states时，刷新整个states样式
		 * 
		 */		
		public function fresh():void
		{
			_states = new States;
			_effects = new Effects;
		}
		
		/**
		 */		
		private var _effects:Effects;
		
		/**
		 */
		public function get effects():Object
		{
			return _effects;
		}
		
		/**
		 * @private
		 */
		public function set effects(value:Object):void
		{
			_effects = XMLVOMapper.updateObject(value, _effects, "effects", this) as Effects;
		}
		
	}
}