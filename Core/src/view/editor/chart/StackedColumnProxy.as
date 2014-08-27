package view.editor.chart
{
	public class StackedColumnProxy extends SeriesProxy
	{
		public function StackedColumnProxy()
		{
			super();
		}
		
		/**
		 */		
		override public function setXml(series:XML):void
		{
			var xml:XML = <stack seriesName={name} xField={labelField} yField={valueField}/>;
			
			if (!series.hasOwnProperty("stackedColumn"))
				series.appendChild(<stackedColumn/>);
			
				series.stackedColumn.appendChild(xml);
		}
	}
}