package view.editor.chart
{
	import com.kvs.charts.chart2D.encry.ISeries;
	import com.kvs.charts.common.SeriesDataPoint;
	import com.kvs.ui.label.TextInputField;
	
	import flash.display.Sprite;
	
	import view.element.chart.ChartElement;
	
	/**
	 *
	 * 图表编辑器
	 *  
	 * @author wanglei
	 * 
	 */	
	public class ChartEditor extends Sprite
	{
		public function ChartEditor(core:CoreApp)
		{
			super();
			
			this.app = core;
			
			dataField.textLayoutFormat.fontSize = 16;
			
			dataField.textLayoutFormat.paddingTop = dataField.textLayoutFormat.paddingLeft 
				= dataField.textLayoutFormat.paddingRight = dataField.textLayoutFormat.paddingBottom = 20;
			
			dataField.textLayoutFormat.fontFamily = "宋体";
			dataField.textLayoutFormat.lineHeight = "150%";
			//dataField.textLayoutFormat.wordSpacing
			
			dataField.updateFormat();
			addChild(dataField);
		}
		
		/**
		 * 当前正在编辑的图表 
		 */		
		public var chart:ChartElement;
		
		/**
		 * 将图表的数据模型转换为文本并输出
		 */		
		public function exportTextFromChart():void
		{
			var str:String = "";
			
			var series:Vector.<ISeries> = chart.series;
			
			for each (var s:ISeries in series)
			{
				str += s.seriesName;
				str += split;
				
				var data:Vector.<SeriesDataPoint> = s.dataItemVOs;
				for each (var p:SeriesDataPoint in data)
				{
					str += split + p.yLabel;
				}
			}
			
			dataField.text = str;
			dataField.updateLayout();
		}
		
		/**
		 */		
		private var split:String = " ";
		
		/**
		 */		
		private function textToXML(text:String):XML
		{
			var xml:XML;
			
			
			return xml;
		}
		
		/**
		 */		
		public function resize():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(app.contentRect.x, app.contentRect.y, app.contentRect.width, app.contentRect.height);
			this.graphics.endFill();
			
			dataField.textWidth = app.contentRect.width - 100;
			dataField.textHeight = app.contentRect.height - 100;
			dataField.updateLayout();
			
			dataField.x = (app.contentRect.width - dataField.textWidth) / 2;
			dataField.y = app.contentRect.y + (app.contentRect.height - dataField.height) / 2;
		}
		
		/**
		 * 数据输入区域 
		 */		
		private var dataField:TextInputField = new TextInputField();
		
		/**
		 */		
		private var app:CoreApp;
	}
}