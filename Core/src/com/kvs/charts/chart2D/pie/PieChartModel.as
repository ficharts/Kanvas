package com.kvs.charts.chart2D.pie
{
	import com.kvs.charts.chart2D.core.model.Chart2DModel;
	import com.kvs.charts.chart2D.core.model.ChartBGStyle;
	import com.kvs.charts.chart2D.pie.series.Series;
	import com.kvs.utils.XMLConfigKit.Model;
	import com.kvs.charts.legend.LegendStyle;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.LabelStyle;

	/**
	 * 饼图的模型
	 */	
	public class PieChartModel
	{
		/**
		 */		
		public static const PIE_SERIES_STYLE:String = 'pieSeriesStyle';
		
		/**
		 * 数值，工具提示等元素的样式 
		 */		
		public static const SERIES_DATA_STYLE:String = 'seriesDataStyle';
		
		/**
		 * 
		 */		
		public function PieChartModel()
		{
		}
		
		/**
		 */		
		private var _series:Series;

		/**
		 */
		public function get pieSeries():Series
		{
			return _series;
		}

		/**
		 * @private
		 */
		public function set pieSeries(value:Series):void
		{
			_series = value;
		}
		
		/**
		 */		
		public function set series(value:Series):void
		{
			_series = value;
		}
		
		/**
		 */		
		public function get series():Series
		{
			return this._series;
		}

		
		//-----------------------------------------
		//
		// 数据格式与样式控制
		//
		//-----------------------------------------
		
		/**
		 */		
		private var _legend:LegendStyle;
		
		/**
		 */
		public function get legend():LegendStyle
		{
			return _legend;
		}
		
		/**
		 * @private
		 */
		public function set legend(value:LegendStyle):void
		{
			_legend = XMLVOMapper.updateObject(value, _legend, Model.LEGEND, this) as LegendStyle;
			
			XMLVOLib.dispatchCreation(Chart2DModel.UPDATE_LEGEND_STYLE, value);
		}
		
		/**
		 * 数据格式定义；
		 */		
		private var _dataFormatter:PieDataFormatter = new PieDataFormatter;
		
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
		
		/**
		 */
		public function get precision():uint
		{
			return _dataFormatter.precision;
		}
		
		/**
		 * @private
		 */
		public function set useGrouping(value:Object):void
		{
			_dataFormatter.useGrouping = value;
		}
		
		/**
		 */
		public function get useGrouping():Object
		{
			return _dataFormatter.useGrouping;
		}
		
		/**
		 * @private
		 */
		public function set precision(value:uint):void
		{
			_dataFormatter.precision = value;
		}
		
		/**
		 * 数值前缀
		 */		
		public function get valuePrefix():String
		{
			return _dataFormatter.valuePrefix;
		}
		
		public function set valuePrefix(value:String):void
		{
			_dataFormatter.valuePrefix = value;
		}
		
		
		/**
		 * 数值前缀
		 */		
		public function get yPrefix():String
		{
			return _dataFormatter.valuePrefix;
		}
		
		public function set yPrefix(value:String):void
		{
			_dataFormatter.valuePrefix = value;
		}
		
		/**
		 * 数值后缀
		 */		
		public function get valueSuffix():String
		{
			return _dataFormatter.valueSuffix;
		}
		
		public function set valueSuffix(value:String):void
		{
			_dataFormatter.valueSuffix = value;
		}
		
		/**
		 */		
		public function set ySuffix(value:String):void
		{
			_dataFormatter.valueSuffix = value
		}
		
		/**
		 */		
		public function get ySuffix():String
		{
			return _dataFormatter.valueSuffix
		}
		
		
		//-------------------------------------------------
		//
		// 标题样式与设置
		//
		//-------------------------------------------------
		
		
		
		
		
		
		
		//------------------------------------------------------------
		//
		//
		// 背景
		//
		//
		//-----------------------------------------------------------
		
		/**
		 */		
		private var _chartBG:ChartBGStyle = new ChartBGStyle;
		
		/**
		 */
		public function get chartBG():ChartBGStyle
		{
			return _chartBG;
		}
		
		/**
		 * @private
		 */
		public function set chartBG(value:ChartBGStyle):void
		{
			_chartBG = value;
		}
		
		/**
		 */		
		private var _fullScreen:Boolean = true;

		/**
		 */
		public function get fullScreen():Object
		{
			return _fullScreen;
		}

		/**
		 * @private
		 */
		public function set fullScreen(value:Object):void
		{
			_fullScreen = XMLVOMapper.boolean(value);
		}
		
		/**
		 */
		public function get animation():Object
		{
			return _animation;
		}
		
		/**
		 * @private
		 */
		public function set animation(value:Object):void
		{
			_animation = XMLVOMapper.boolean(value);
		}
		
		/**
		 * 是否开启开场动画
		 */		
		private var _animation:Object = true;
		
		/**
		 */		
		public function get bgVisible():Object
		{
			return this.chartBG.enable;
		}
		
		public function set bgVisible(value:Object):void
		{
			this.chartBG.enable = value;
		}
		

	}
}