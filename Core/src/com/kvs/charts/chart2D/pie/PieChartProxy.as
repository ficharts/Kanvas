package com.kvs.charts.chart2D.pie
{
	import com.kvs.charts.chart2D.core.Chart2DStyleTemplate;
	import com.kvs.charts.chart2D.core.model.ChartBGStyle;
	import com.kvs.charts.chart2D.core.model.DataRender;
	import com.kvs.charts.chart2D.pie.series.PieSeries;
	import com.kvs.charts.chart2D.pie.series.Series;
	import com.kvs.charts.common.ChartColors;
	import com.kvs.charts.common.ChartDataFormatter;
	import com.kvs.charts.legend.LegendStyle;
	import com.kvs.ui.toolTips.TooltipStyle;
	import com.kvs.utils.XMLConfigKit.Model;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;

	/**
	 */	
	public class PieChartProxy
	{
		public function PieChartProxy()
		{
			XMLVOLib.registerCustomClasses(<colors path='com.kvs.utils.XMLConfigKit.style.Colors'/>);
			
			Series;
			XMLVOLib.registerCustomClasses(<series path='com.kvs.charts.chart2D.pie.series.Series'/>);
			
			PieSeries;
			XMLVOLib.registerCustomClasses(<pie path='com.kvs.charts.chart2D.pie.series.PieSeries'/>);
			
			ChartBGStyle;
			XMLVOLib.registerCustomClasses(<chartBG path='com.kvs.charts.chart2D.core.model.ChartBGStyle'/>);
			
			ChartDataFormatter;
			XMLVOLib.registerCustomClasses(<dataFormatter path='com.kvs.charts.common.ChartDataFormatter'/>);
			
			XMLVOLib.setASLabelStyleKey('title');
			XMLVOLib.setASLabelStyleKey('subTitle');
			XMLVOLib.setASLabelStyleKey('valueLabel');
			
			XMLVOLib.registerObjectToProperty('config', 'valueLabel', 'text');
			XMLVOLib.registerObjectToProperty('valueLabel', 'text', 'value');
			
			XMLVOLib.registerObjectToProperty('config', 'tooltip', 'text');
			XMLVOLib.registerObjectToProperty('tooltip', 'text', 'value');
			
			XMLVOLib.registerObjectToProperty('config', 'title', 'text');
			XMLVOLib.registerObjectToProperty('title', 'text', 'value');
			
			XMLVOLib.registerObjectToProperty('legend', 'label', 'text');
			XMLVOLib.registerObjectToProperty('label', 'text', 'value');
			
			TooltipStyle;
			XMLVOLib.registerCustomClasses(<tooltip path='com.kvs.ui.toolTips.TooltipStyle'/>);
			
			LegendStyle;
			XMLVOLib.registerCustomClasses(<legend path='com.kvs.charts.legend.LegendStyle'/>);
			
			DataRender;
			XMLVOLib.registerCustomClasses(<icon path='com.kvs.charts.chart2D.core.model.DataRender'/>);
		}
		
		private var _configXML:XML;

		/**
		 */
		public function get configXML():XML
		{
			return _configXML;
		}

		/**
		 * @private
		 */
		public function set configXML(value:XML):void
		{
			_configXML = value;
		}

		/**
		 * 创建新模型，一次性 应用混合好的样式；
		 */		
		public function setChartModel(value:XML):void
		{
			XMLVOLib.clearPartLib();
			
			// 先刷新颜色板，因稍后会构建图表的数据模型
			if (configXML && configXML.hasOwnProperty("colors"))
			{
				ChartColors.clear();
				XMLVOMapper.fuck(configXML, ChartColors);
			}
			
			this._chartModel = new PieChartModel();
			
			XMLVOLib.registerPartXML(PieChartModel.PIE_SERIES_STYLE, value.child('pieSeriesStyle'), Model.SYSTEM);
			
			var seriesDataStyle:XML = <seriesDataStyle/>
			
			seriesDataStyle.appendChild(value.child('tooltip'));
			seriesDataStyle.appendChild(value.child('valueLabel'));
			XMLVOLib.registerPartXML(PieChartModel.SERIES_DATA_STYLE, seriesDataStyle, Model.SYSTEM);
			
			for each (var item:XML in value.child('template').children())
				XMLVOLib.registerPartXML(item.@id, item, item.name().toString());
			
			XMLVOMapper.fuck(value, chartModel);
		}
		
		/**
		 * 根据样式名称设置对应的样式表； 
		 */		
		public function setCurStyleTemplate(styleName:String = 'Simple'):void
		{
			currentStyleName = styleName;
			currentStyleXML = Chart2DStyleTemplate.getTheme(currentStyleName);
			XMLVOMapper.fuck(currentStyleXML, ChartColors);
		}
		
		/**
		 * 当前的样式模板；
		 */		
		public function set currentStyleXML(value:XML):void
		{
			_currentStyleXML = value;
		}
		
		/**
		 */		
		public function get currentStyleXML():XML
		{
			return _currentStyleXML;
		}
		
		/**
		 */		
		private var _currentStyleXML:XML;
		
		/**
		 * 当前的样式名称， 此名称与样式模板一一对应；
		 */		
		public var currentStyleName:String = 'Simple';
		
		/**
		 * @return 
		 */		
		public function get chartModel():PieChartModel
		{
			return _chartModel;
		}
		
		/**
		 */		
		private var _chartModel:PieChartModel = new PieChartModel;
	}
}