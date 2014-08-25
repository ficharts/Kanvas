package view.editor.chart
{
	public class StackedBarProxy extends BarSeriesProxy
	{
		public function StackedBarProxy()
		{
			super();
		}
		
		
		/**
		 */		
		override public function setXml(series:XML):void
		{
			var xml:XML = <stack seriesName={name} xField={labelField} yField={valueField}/>;
			
			if (!series.hasOwnProperty("stackedBar"))
				series.appendChild(<stackedBar/>);
			
			series.stackedBar.appendChild(xml);
		}
	}
}