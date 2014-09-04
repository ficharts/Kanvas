
package com.kvs.charts.chart2D.encry
{
	import com.kvs.charts.chart2D.bar.BarSeries;
	import com.kvs.charts.chart2D.core.axis.AxisBase;
	import com.kvs.charts.chart2D.core.axis.LinearAxis;
	import com.kvs.charts.chart2D.core.itemRender.ItemRenderEvent;
	import com.kvs.charts.chart2D.core.itemRender.PointRenderBace;
	import com.kvs.charts.chart2D.core.model.Chart2DModel;
	import com.kvs.charts.chart2D.core.model.DataRender;
	import com.kvs.charts.chart2D.core.series.DataIndexOffseter;
	import com.kvs.charts.chart2D.core.series.IDirectionSeries;
	import com.kvs.charts.chart2D.core.series.ISeriesRenderPattern;
	import com.kvs.charts.chart2D.core.series.SeriesDirectionControl;
	import com.kvs.charts.common.ChartColors;
	import com.kvs.charts.common.SeriesDataPoint;
	import com.kvs.charts.legend.model.LegendVO;
	import com.kvs.charts.legend.view.LegendEvent;
	import com.kvs.utils.PerformaceTest;
	import com.kvs.utils.RexUtil;
	import com.kvs.utils.XMLConfigKit.IEditableObject;
	import com.kvs.utils.XMLConfigKit.Model;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.kvs.utils.XMLConfigKit.style.LabelStyle;
	import com.kvs.utils.XMLConfigKit.style.States;
	import com.kvs.utils.XMLConfigKit.style.StatesControl;
	import com.kvs.utils.XMLConfigKit.style.Style;
	import com.kvs.utils.XMLConfigKit.style.elements.IFreshElement;
	import com.kvs.utils.XMLConfigKit.style.elements.IStyleElement;
	
	import flash.display.Sprite;
	
	import view.editor.chart.SeriesProxy;

	/**
	 * 序列的基�
	 */	
	public class SB extends Sprite implements IDirectionSeries, IEditableObject, IStyleElement, IFreshElement, IStyleStatesUI, ISeries
	{

		/**
		 */		
		public function SB()
		{
			super();
			
			addChild(canvas);
		}
		
		/**
		 */		
		public function get proxy():SeriesProxy
		{
			var proxy:SeriesProxy = new SeriesProxy;
			proxy.type = this.type;
			
			
			
			return proxy;
		}
		
		/**
		 * 设置坐标轴的格式
		 * 
		 * 除了全局数据格式，序列也可以单独定义自己的数据格式
		 */		
		public function resetAxisFormat():void
		{
			// 这里目前仅仅定义了数值方向上的格式
			
			if (RexUtil.ifHasText(valuePrefix))
				verticalAxis.dataFormatter.yPrefix = valuePrefix;
			
			if (RexUtil.ifHasText(valueSuffix))
				verticalAxis.dataFormatter.ySuffix = valueSuffix;
		}
		
		/**
		 */		
		private var _valuePrefix:String
		
		/**
		 */
		public function get valuePrefix():String
		{
			return _valuePrefix;
		}

		/**
		 * @private
		 */
		public function set valuePrefix(value:String):void
		{
			_valuePrefix = value;
		}
		
		/**
		 */		
		private var _valueSuffix:String

		public function get valueSuffix():String
		{
			return _valueSuffix;
		}

		public function set valueSuffix(value:String):void
		{
			_valueSuffix = value;
		}

		/**
		 */		
		public function setColor(colorMng:ChartColors):void
		{
			if (!color)
				color = colorMng.chartColor.toString(16);
		}
		
		/**
		 */		
		public function get labels():Vector.<String>
		{
			var labels:Vector.<String> = new Vector.<String>
			
			for each (var data:SeriesDataPoint in dataItemVOs)
				labels.push(data.xLabel);
				
			return labels;
		}
		
		/**
		 */		
		public function exportValues(split:String):String
		{
			var labels:Vector.<String> = new Vector.<String>
			
			for each (var data:SeriesDataPoint in dataItemVOs)
				labels.push(data.yLabel);
			
			return seriesName + ":\n" + labels.join(split);
		}
		
		
		/**
		 * 序列自动计算名称，避免空值引起的图例排版问题
		 */		
		public function initSeriesName(index:uint):uint
		{
			if (RexUtil.ifTextNull(name))
				name = "序列" + index;
			
			return index + 1;
		}
		
		/**
		 */		
		public function get type():String
		{
			return null;
		}
		
		/**
		 */		
		public function get currState():Style
		{
			return _currState;
		}
		
		/**
		 */		
		public function set currState(value:Style):void
		{
			_currState = value;
		}
		
		/**
		 */		
		private var _currState:Style;
		
		/**
		 */		
		public var stateControl:StatesControl;
		
		
		/**
		 * 清空画布
		 */		
		public function clearCanvas():void
		{
			while (canvas.numChildren)
				canvas.removeChildAt(0);
			
			canvas.graphics.clear();
		}

		
		
		
		//--------------------------------------------------------------------------
		//
		//  
		// 渲染模式的状态控制，有经典模式和数据缩放两种模式�每种序列需重写自己的一对渲�
		// 
		// 模式�
		//---------------------------------------------------------------------------
		
		/**
		 */		
		public var curRenderPattern:ISeriesRenderPattern;
		
	
		//----------------------------------------------------------------------
		
		
		
		/**
		 */		
		public var dataOffsetter:DataIndexOffseter = new DataIndexOffseter;
		
		/**
		 *  创建渲染节点并渲染图表序列；
		 * 
		 *  创建渲染节点  > 布局数据节点  > 渲染图表  > 渲染 渲染节点
		 */
		public function render():void
		{
			// 只有当序列中有数据时，才渲染
			if (this.dataItemVOs.length)
				this.curRenderPattern.render();
		}
		
		/**
		 * 图表图形绘制
		 */
		protected function draw():void
		{
			// To override.
		}
		
		/**
		 *  style 采取的是继承模式，更新原有样
		 */
		public function set style(value:String):void
		{
			_style = XMLVOMapper.updateStyle(this, value, type);		
		}		
			
		private var _style:String;

		/**
		 */
		public function get style():String
		{
			return _style;
		}
		
		/**
		 * 
		 * 以id方式定义style和states时，刷新整个states样式
		 * 
		 */		
		public function fresh():void
		{
			_states = new States;
		}
		
		/**
		 */		
		private var _states:States;

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
			_states = XMLVOMapper.updateObject(value, _states, "states", this) as States;
		}
		
		/**
		 */		
		public function beforeUpdateProperties(xml:* = null):void
		{
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.SERIES_DATA_STYLE, Model.SYSTEM), this);
		}
		
		/**
		 */		
		public function created():void
		{
			chartColorManager = new ChartColors;
		}
		
		/**
		 * 序列被创建并配置完毕后回调方� 此方法在数据设置之前调用�
		 */		
		public function configed(colorMananger:ChartColors):void
		{
			if (this.labelDisplay == LabelStyle.NORMAL && verticalAxis is LinearAxis)
				(verticalAxis as LinearAxis).ifExpend = true;
		}
		
		/**
		 */		
		public function set labelDisplay(value:String):void
		{
			_labelDisplay = value;
		}
		
		/**
		 */		
		public function get labelDisplay():String
		{
			return _labelDisplay;
		}
		
		/**
		 */		
		private var _labelDisplay:String = LabelStyle.NORMAL;
		
		/**
		 * 绘制图表的画布或者存放图表元素的容器;
		 */		
		public var canvas:Sprite = new Sprite;

		
		//---------------------------------------------
		//
		// 数值分布特�
		//
		//---------------------------------------------
		
		public function applyDataFeature():void
		{
			this.directionControl.dataFeature = this.verticalAxis.getSeriesDataFeature(
				this.verticalValues.concat());
			
			directionControl.checkDirection(this);
			
			this.canvas.y = baseLine;
		}
		
		/**
		 */		
		public function upBaseLine():void
		{
			directionControl.baseLine = 0;
			
			//return;
			
			if ((verticalAxis as LinearAxis).baseAtZero)
				directionControl.baseLine = verticalAxis.valueToY(0);
			else
				directionControl.baseLine = verticalAxis.valueToY(directionControl.dataFeature.minValue);
		}
		
		/**
		 */		
		public function centerBaseLine():void
		{
			directionControl.baseLine = verticalAxis.valueToY(0);
		}
		
		/**
		 */		
		public function downBaseLine():void
		{
			directionControl.baseLine = 0;
				
			//return;
			
			if ((verticalAxis as LinearAxis).baseAtZero)
				directionControl.baseLine = verticalAxis.valueToY(0);
			else
				directionControl.baseLine = verticalAxis.valueToY(directionControl.dataFeature.maxValue);
		}
		
		/**
		 */		
		public function get baseLine():Number
		{
			return directionControl.baseLine;
		}
		
		/**
		 */		
		protected var directionControl:SeriesDirectionControl = new SeriesDirectionControl();
		 
		/**
		 */		
		public function get controlAxis():AxisBase
		{
			return this.verticalAxis;
		}

		/**
		 */ 
		public var ifDataChanged:Boolean = false;
		
		/**
		 */		
		public var ifSizeChanged:Boolean = false;

		/**
		 *  动画渲染时传入动画进度百分比�各序列执行自己的动画方式�
		 */		
		public function set percent(value:Number):void
		{
			
		}
		
		/**
		 */		
		public function get percent():Number
		{
			return 0;
		}
		
		
		

		
		//-------------------------------------
		//
		// 序列的属性定�
		//
		//-------------------------------------
		

		
		
		//--------------------------------------
		//
		// 序列的渲染节�
		//
		//--------------------------------------

		/**
		 */
		private var _itemRenders:Array;

		public function get itemRenders():Array
		{
			return _itemRenders;
		}

		public function set itemRenders(value:Array):void
		{
			_itemRenders = value;
		}

		/**
		 * 创建渲染节点并初始化其属性；
		 * 
		 * 渲染节点的颜色默认为数据节点的颜色，其他属性均继承于序列的渲染器配置属性；
		 */
		public function createItemRenders():void
		{
			itemRenders = [];
			for each (var item:SeriesDataPoint in dataItemVOs)
				initItemRender(itemRender, item);
		}
		
		/**
		 * 构造节点渲染器
		 */		
		protected function get itemRender():PointRenderBace
		{
			return new PointRenderBace;
		}
		
		/**
		 */		
		protected function initItemRender(itemRender:PointRenderBace, item:SeriesDataPoint):void
		{
			if (ifNullData(item))
				return;
			
			itemRender.itemVO = item;
			
			item.metaData.valueLabel = item.yLabel;
			itemRender.value = value;
			
			itemRender.valueLabel = valueLabel;
			updateLabelDisplay(itemRender);
			
			itemRender.dataRender = this.dataRender;
			
			initTipString(item, getXTip(item), 
				getYTip(item), getZTip(item), itemRender.isHorizontal);
			
			itemRenders.push(itemRender);
		}
		
		/**
		 * 给数据节点的元数据设置tooltip字段�
		 */		
		protected function initTipString(itemVO:SeriesDataPoint, 
									   xTipLabel:String, yTipLabel:String, zTipLabel:String,
									   isHorizontal:Boolean = false):void
		{
			var fullTip:String;
			var xTip:String = xTipLabel;
			var yTip:String = yTipLabel;
			var zTip:String = zTipLabel;
			
			if (itemVO.xDisplayName && itemVO.xDisplayName != '')
				xTip = itemVO.xDisplayName + ':' + xTip;
			
			if (itemVO.yDisplayName && itemVO.yDisplayName != '')
				yTip = itemVO.yDisplayName + ':' + yTip;
			
			if (isHorizontal)
				fullTip = yTip + '<br>' + xTip + zTip;
			else
				fullTip = xTip + '<br>' + yTip + zTip;
			
			if (itemVO.seriesName && itemVO.seriesName != '')
				fullTip = itemVO.seriesName + '<br>' + fullTip;
			
			itemVO.metaData.tooltip = fullTip;
		}
		
		/**
		 */		
		protected function updateLabelDisplay(item:PointRenderBace):void
		{
			item.valueLabel.layout = this.labelDisplay;
			
			if (labelDisplay == LabelStyle.NONE)
				item.valueLabel.enable = false;
			else
				item.valueLabel.enable = true;
			
			if (label)
				item.valueLabel.text.value = label;
		}
		
		/**
		 */		
		public function set label(value:String):void
		{
			_label = value;
		}
		
		/**
		 */		
		private var _label:String;
		
		/**
		 */		
		public function get label():String
		{
			return _label;
		}
		
		/**
		 * 更新数据节点的布局信息�
		 */		
		public function layoutDataItems(startIndex:int, endIndex:int, step:uint = 1):void
		{
			var item:SeriesDataPoint;
			var i:uint = 0;
			for (i = startIndex; i <= endIndex; i +=step)
			{
				item = dataItemVOs[i];
				item.dataItemX = item.x = horizontalAxis.valueToX(item.xVerifyValue, i);
				item.dataItemY = item.y = (verticalAxis.valueToY(item.yVerifyValue));
			}
			
		}
		
		/**
		 * 默认为系统统一配置，如果颜色没有配置则采用节点颜色，序列可以单独定�
		 * 
		 * 渲染节点的显示与尺寸�
		 */		
		private var _dataRender:DataRender;

		/**
		 */
		public function get dataRender():DataRender
		{
			return _dataRender;
		}

		/**
		 * @private
		 */
		public function set dataRender(value:DataRender):void
		{
			_dataRender = XMLVOMapper.updateObject(value, _dataRender, Model.DATA_RENDER, this) as DataRender;
		}
		
		
		
		
		//-----------------------------------------------------
		//
		// 坐标轴数�
		//
		//-----------------------------------------------------

		/**
		 */		
		public function updateAxisValueRange():void
		{
			horizontalAxis.pushValues(horizontalValues.concat());
			verticalAxis.pushValues(verticalValues.concat());
		}
		
		/**
		 */		
		private var _horizontalValues:Vector.<Object> = new Vector.<Object>;

		public function get horizontalValues():Vector.<Object>
		{
			return _horizontalValues;
		}

		public function set horizontalValues(value:Vector.<Object>):void
		{
			_horizontalValues = value;
		}

		/**
		 */		
		private var _verticalValues:Vector.<Object> = new Vector.<Object>;

		public function get verticalValues():Vector.<Object>
		{
			return _verticalValues;
		}

		public function set verticalValues(value:Vector.<Object>):void
		{
			_verticalValues = value;
		}

		
		
		
		
		///--------------------------------------------
		//
		//  图表属�
		//
		//--------------------------------------------
		
		/**
		 */		
		private var _seriesWidth:Number;
		
		public function get seriesWidth():Number
		{
			return _seriesWidth;
		}
		
		public function set seriesWidth(v:Number):void
		{
			if (_seriesWidth != v)
			{
				_seriesWidth = v;
				ifSizeChanged = true;
			}
		}
		
		/**
		 */
		private var _seriesHeight:Number;
		
		public function get seriesHeight():Number
		{
			return _seriesHeight;
		}
		
		public function set seriesHeight(v:Number):void
		{
			if (_seriesHeight != v)
			{
				_seriesHeight = v;
				ifSizeChanged = true;
			}
		}
		
		/**
		 * Container chart draw object.
		 */
		protected var seriesChartContainer:Sprite;
		
		/**
		 */		
		protected var _horizontalAxis:AxisBase;

		public function get horizontalAxis():AxisBase
		{
			return _horizontalAxis;
		}

		/**
		 *  individual aixs.
		 */
		public function set horizontalAxis(v:AxisBase):void
		{
			_horizontalAxis = v;
			_horizontalAxis.direction = AxisBase.HORIZONTAL_AXIS;
			_horizontalAxis.mdata = this;
		}

		/**
		 */
		private var _verticalAxis:AxisBase;

		public function get verticalAxis():AxisBase
		{
			return _verticalAxis;
		}

		public function set verticalAxis(v:AxisBase):void
		{
			_verticalAxis = v;
			_verticalAxis.direction = AxisBase.VERTICAL_AXIX;
			_verticalAxis.mdata = this;
		}
		
		/**
		 * 横轴ID 
		 */		
		private var _hAixs:String;

		/**
		 */
		public function get xAxis():String
		{
			return _hAixs;
		}

		/**
		 * @private
		 */
		public function set xAxis(value:String):void
		{
			_hAixs = value;
		}
		
		/**
		 * 纵轴ID 
		 */		
		private var _vAxis:String;

		public function get yAxis():String
		{
			return _vAxis;
		}

		public function set yAxis(value:String):void
		{
			_vAxis = value;
		}
		
		
		
		
		
		
		//------------------------------------------------------------------
		//
		//
		// 序列数据的处�
		//
		//
		//-----------------------------------------------------------------
		
		/**
		 */
		private var _dataProvider:Vector.<Object>;

		public function get dataProvider():Vector.<Object>
		{
			return _dataProvider;
		}

		/**
		 *  Individual data.
		 */
		public function set dataProvider(value:Vector.<Object>):void
		{
			if (value != _dataProvider)
			{
				_dataProvider = value;
				preInitData();
				ifDataChanged = true;
			}
		}
		
		/**
		 *  初始化坐标轴数据, 预初始化节点数据�
		 * 
		 *  节点数据的完全初始化需等到正式渲染序列之前
		 * 
		 *  因为大数据下�序列的渲染都是采集部分数据动态渲染，
		 * 
		 *  不能所有数据节点一次全部创建并渲染, 太耗性能
		 */
		protected function preInitData():void
		{
			PerformaceTest.start("预构建数据节");
			
			var seriesDataItem:SeriesDataPoint;
			var item:Object;
			var souceDataIndex:uint = 0;
			var actualDataIndex:uint = 0;
			
			dataItemVOs.length = 0;
			horizontalValues.length = 0; 
			verticalValues.length = 0;
			sourceDataItems.length = 0;
			
			var precision:uint = 0;
			var temPrecision:uint = 0;
			
			for each (item in dataProvider)
			{
				seriesDataItem = this.seriesDataItem;
				
				seriesDataItem.xValue = item[xField]; // xValue.
				seriesDataItem.yValue = item[yField]; // yValue.
				
				if (seriesDataItem.xValue == null && seriesDataItem.yValue == null)
				{
					seriesDataItem = null;				
					continue;
				}
				
				setItemColor(item, seriesDataItem);
				
				seriesDataItem.xVerifyValue = this.horizontalAxis.getVerifyData(seriesDataItem.xValue);
				seriesDataItem.yVerifyValue = this.verticalAxis.getVerifyData(seriesDataItem.yValue);
				
				horizontalValues[souceDataIndex] = seriesDataItem.xVerifyValue;
				verticalValues[souceDataIndex] = seriesDataItem.yVerifyValue;
				
				if (RexUtil.ifTextNull(seriesDataItem.xValue) || RexUtil.ifTextNull(seriesDataItem.yValue))
					seriesDataItem = null;
				else
				{
					dataItemVOs[actualDataIndex] = sourceDataItems[actualDataIndex] = seriesDataItem;
					actualDataIndex += 1;
					
					temPrecision = RexUtil.checkPrecision(seriesDataItem[this.value].toString())
					if ( temPrecision > precision)
						precision = temPrecision;
				}
				
				souceDataIndex ++;
			}
			
			if (this is BarSeries)
			{
				if (precision > horizontalAxis.dataFormatter.precision)
					horizontalAxis.dataFormatter.precision = precision;
			}
			else
			{
				if (precision > verticalAxis.dataFormatter.precision)				
					verticalAxis.dataFormatter.precision = precision;
			}
			
			updateMaxIndex();
			
			PerformaceTest.end("预构建数据节");
		}
		
		/**
		 */		
		public function initData():void
		{
			var seriesDataItem:SeriesDataPoint;
			for each (seriesDataItem in dataItemVOs)
				initDataItem(seriesDataItem);
		}
		
		
		/**
		 */		
		protected function initDataItem(seriesDataItem:SeriesDataPoint):void
		{
			seriesDataItem.metaData = {};
			
			seriesDataItem.xLabel = horizontalAxis.getXLabel(seriesDataItem.xVerifyValue);
			seriesDataItem.yLabel = verticalAxis.getYLabel(seriesDataItem.yVerifyValue);
			
			if (seriesDataItem.xValue == null && seriesDataItem.yValue == null)
			{
				seriesDataItem = null;
				return;
			}
				
			seriesDataItem.xDisplayName = horizontalAxis.displayName;
			seriesDataItem.yDisplayName = verticalAxis.displayName;
			
			seriesDataItem.seriesName = seriesName;
			
			XMLVOMapper.pushAttributesToObject(seriesDataItem, seriesDataItem.metaData, 
				['xValue', 'yValue', 'xLabel', 'yLabel', 'xDisplayName', 'yDisplayName', 'seriesName', 'color']);
			
			this.initTipString(seriesDataItem, getXTip(seriesDataItem), getYTip(seriesDataItem),
				getZTip(seriesDataItem), false); 
		}
		
		/**
		 */		
		protected function getXTip(item:SeriesDataPoint):String
		{
			return item.xLabel;
		}
		
		/**
		 */		
		protected function getYTip(item:SeriesDataPoint):String
		{
			return item.yLabel;
		}
		
		/**
		 */		
		protected function getZTip(item:SeriesDataPoint):String
		{
			return "";
		}
		
		/**
		 */		
		protected function updateMaxIndex():void
		{
			if(dataItemVOs.length > 1)
				dataOffsetter.maxIndex = maxDataItemIndex = dataItemVOs.length - 1;
			else
				dataOffsetter.maxIndex = maxDataItemIndex = 0;
		}
		
		/**
		 */		
		protected var sourceDataItems:Vector.<SeriesDataPoint> = new Vector.<SeriesDataPoint>;;
		
		/**
		 * 把节点总数存下来，后继节点渲染会频繁用于计算；
		 */		
		public var maxDataItemIndex:uint = 0;
		
		/**
		 * 构建数据节点VO
		 */		
		protected function get seriesDataItem():SeriesDataPoint
		{
			return new SeriesDataPoint();
		}
		
		/**
		 */		
		public function get legendData():Vector.<LegendVO>
		{
			var legendVOes:Vector.<LegendVO> = new Vector.<LegendVO>;
			var legendVO:LegendVO;
			
			if (this.seriesCount > 1 ||  ifSeriesLegend)
			{
				legendVO = new LegendVO();
				legendVO.addEventListener(LegendEvent.LEGEND_ITEM_OVER, seriesLegendOverHandler, false, 0, true);
				legendVO.addEventListener(LegendEvent.LEGEND_ITEM_OUT, seriesLegendOutHandler, false, 0, true);
				
				legendVO.addEventListener(LegendEvent.HIDE_LEGEND, seriesHideLegendHandler, false, 0, true);
				legendVO.addEventListener(LegendEvent.SHOW_LEGEND, seriesShowLegendHandler, false, 0, true);
				
				legendVO.metaData = this;
				legendVOes.push(legendVO);
				
			}
			else
			{
				for each(var item:SeriesDataPoint in dataItemVOs)	
				{
					legendVO = new LegendVO();
					legendVO.metaData = item; // 用于精确控制节点的状�
					legendVO.addEventListener(LegendEvent.LEGEND_ITEM_OVER, itemRenderOverHandler, false, 0, true);
					legendVO.addEventListener(LegendEvent.LEGEND_ITEM_OUT, itemRenderOutHandler, false, 0, true);
					legendVO.addEventListener(LegendEvent.HIDE_LEGEND, itemRenderHideHandler, false, 0, true);
					legendVO.addEventListener(LegendEvent.SHOW_LEGEND, itemRenderShowHandler, false, 0, true);
					legendVOes.push(legendVO);
				}
			}
			
			return legendVOes;
		}
		
		/**
		 */		
		public function get ifSeriesLegend():Object
		{
			return _ifSeriesLegend;
		}
		
		public function set ifSeriesLegend(value:Object):void
		{
			_ifSeriesLegend = XMLVOMapper.boolean(value);
		}

		/**
		 */		
		private var _ifSeriesLegend:Boolean = true;
		
		
		//----------------------------------------------------
		//
		// 图例控制� 序列控制�
		//
		//----------------------------------------------------
		
		public function seriesHideLegendHandler(evt:LegendEvent):void
		{
			for each (var itemVO:SeriesDataPoint in dataItemVOs)
				itemVO.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.SERIES_HIDE));
			
			this.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.UPDATE_VALUE_LABEL, false, true));
		}
		
		/**
		 */		
		public function seriesShowLegendHandler(evt:LegendEvent):void
		{
			for each (var itemVO:SeriesDataPoint in dataItemVOs)
				itemVO.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.SERIES_SHOW));
				
			this.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.UPDATE_VALUE_LABEL, false, true));
		}
		
		/**
		 */		
		public function seriesLegendOverHandler(evt:LegendEvent):void
		{
			for each (var itemVO:SeriesDataPoint in dataItemVOs)
				itemVO.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.SERIES_OVER));
			
		}
		
		/**
		 */		
		public function seriesLegendOutHandler(evt:LegendEvent):void
		{
			for each (var itemVO:SeriesDataPoint in dataItemVOs)
				itemVO.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.SERIES_OUT));
		}
		
		
		
		
		
		//------------------------------------------
		//
		// 图例控制�仅对渲染节点
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
			this.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.UPDATE_VALUE_LABEL, false, true));
		}
		
		private function itemRenderShowHandler(evt:LegendEvent):void
		{
			evt.legendVO.metaData.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.SERIES_SHOW));
			this.dispatchEvent(new ItemRenderEvent(ItemRenderEvent.UPDATE_VALUE_LABEL, false, true));
		}
											   
		
		
		
		
		
		//-----------------------------------------------------
		//
		// 颜色控制
		//
		//-----------------------------------------------------
		
		/**
		 */		
		protected function setItemColor(sourceDataItem:Object, seriesDataItem:SeriesDataPoint):void
		{
			if (sourceDataItem[colorField])// Special color of item. 
				seriesDataItem.color = StyleManager.getUintColor(sourceDataItem[colorField]);
			else if (singleColor || this.seriesCount > 1)
				seriesDataItem.color = uint(color);// The whole series color.
			else
				seriesDataItem.color = chartColorManager.chartColor;
		}
		
		/**
		 */		
		protected var chartColorManager:ChartColors;
		
		/**
		 * 单序列时，柱体是否采用同一种颜色； 
		 */		
		private var _singleColor:Object = true;
		
		public function get singleColor():Object
		{
			return _singleColor;
		}
		
		public function set singleColor(value:Object):void
		{
			_singleColor = XMLVOMapper.boolean(value);
		}
		
		/**
		 * Series items of this series.
		 */
		private var _dataItemVOs:Vector.<SeriesDataPoint> = new Vector.<SeriesDataPoint>;

		public function get dataItemVOs():Vector.<SeriesDataPoint>
		{
			return _dataItemVOs;
		}

		public function set dataItemVOs(v:Vector.<SeriesDataPoint>):void
		{
			_dataItemVOs = v;
		}

		/**
		 *
		 */
		private var _xField:String;

		public function get xField():String
		{
			return _xField;
		}

		public function set xField(v:String):void
		{
			_xField = v;
		}

		/**
		 */
		private var _yField:String

		public function get yField():String
		{
			return _yField;
		}

		public function set yField(v:String):void
		{
			_yField = v;
		}
		
		/**
		 *  数值显示的字段名称, xLabel, yLabel, zLabel(气泡图会用到),  percentLabel(百分比堆积图);
		 * 
		 *  默认此样式定义的�‘外数值标签�样式�对应的还�‘内数值标签�
		 */		
		private var _valueLabel:LabelStyle// = '${yLabel}';
		
		/**
		 * 数值显�
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
			if (value)
				_valueLabel = value;
		}
		
		/**
		 * 内部数值标签， 柱状� 堆积图， 气泡图会用到�
		 * 
		 * 趋势图仅 外部数值标�可以起效�柱状图通过layout参数设置启用那种�
		 * 
		 * 堆积图默认两种都启用�气泡图仅启用内数值标签；
		 */		
		protected var _innerValueLabel:LabelStyle;

		/**
		 */
		public function get innerValueLabel():LabelStyle
		{
			return _innerValueLabel;
		}

		/**
		 * @private
		 */
		public function set innerValueLabel(value:LabelStyle):void
		{
			_innerValueLabel = value;
		}
		
		/**
		 * 用于 toolTip 的取值方向判断， �或��
		 */		
		public var value:String = 'yValue';
		
		/**
		 */		
		private var _colorField:String;

		public function get colorField():String
		{
			return _colorField;
		}

		public function set colorField(value:String):void
		{
			_colorField = value;
		}

		/**
		 */
		private var _color:Object;

		public function get color():Object
		{
			return _color;
		}

		public function set color(value:Object):void
		{
			_color = StyleManager.setColor(value);
		}

		/**
		 */
		private var _seriesName:String = "";

		public function get seriesName():String
		{
			return _seriesName;
		}

		public function set seriesName(value:String):void
		{
			_seriesName = value;
		}
		
		/**
		 */		
		override public function set name(value:String):void
		{
			_seriesName = value;
		}
		
		/**
		 */		
		override public function get name():String
		{
			return _seriesName;
		}
		
		/**
		 * the count of series in the chart
		 */
		private var _seriesCount:uint = 0;

		public function get seriesCount():uint
		{
			return _seriesCount;
		}

		public function set seriesCount(value:uint):void
		{
			_seriesCount = value;
		}

		/**
		 * index of item
		 */
		protected var _itemIndex:uint;

		public function get seriesIndex():uint
		{
			return _itemIndex;
		}

		public function set seriesIndex(value:uint):void
		{
			_itemIndex = value;
		}

		/**
		 * series type
		 */
		private var _seriesType:String = "";

		public function get seriesType():String
		{
			return _seriesType;
		}

		public function set seriesType(value:String):void
		{
			_seriesType = value;
		}
		
		/**
		 *  特效标识(默认特效打开)
		 **/
		protected var _animation:Object;
		
		/**
		 */		
		public function get animation():Object
		{
			return _animation;
		}
		
		/**
		 */		
		public function set animation(value:Object):void
		{
			_animation = Object;
		}
		
		/**
		 */		
		public function hoverHandler():void
		{
			
		}
		
		/**
		 */		
		public function normalHandler():void
		{
			
		}
		
		/**
		 */		
		public function downHandler():void
		{
			
		}
		
		/**
		 */		
		public function ifNullData(item:SeriesDataPoint):Boolean
		{
			//节点字段不存�
			if (item.xValue == null || item.yValue == null)
				return true;
			
			//基点字段为空
			if (RexUtil.ifTextNull(item.xValue.toString()) || 
				RexUtil.ifTextNull(item.yValue.toString()))
			{
				return true;
			}
			
			return false;
		}
	}
}