package com.kvs.charts.chart2D.area2D
{
	import com.kvs.charts.chart2D.core.model.Chart2DModel;
	import com.kvs.charts.chart2D.core.series.IDirectionSeries;
	import com.kvs.charts.chart2D.core.series.ISeriesRenderPattern;
	import com.kvs.charts.chart2D.line.LineSeries;
	import com.kvs.charts.chart2D.line.PartLineUI;
	import com.kvs.utils.XMLConfigKit.Model;
	import com.kvs.charts.common.SeriesDataPoint;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.Style;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import flash.display.Shape;

	/**
	 * 
	 * 区域图序列
	 * 
	 */	
	public class AreaSeries2D extends LineSeries implements IDirectionSeries
	{
		/**
		 */		
		public function AreaSeries2D()
		{
			super();
			
			curRenderPattern = new ClassicAreaRender(this);
		}
		
		/**
		 */		
		override public function get type():String
		{
			return "area";
		}
		
		/**
		 */		
		override public function beforeUpdateProperties(xml:*=null):void
		{
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.SERIES_DATA_STYLE, Model.SYSTEM), this);
			XMLVOMapper.fuck(XMLVOLib.getXML(Chart2DModel.AREA_SERIES, Model.SYSTEM), this);
		}
		
	}
}