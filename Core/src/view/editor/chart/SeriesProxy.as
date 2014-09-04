package view.editor.chart
{
	import com.kvs.charts.chart2D.encry.ISeries;
	import com.kvs.utils.RexUtil;
	import com.kvs.utils.dec.NullPad;

	/**
	 *
	 * 用户辅助生成序列和图表的数据模型
	 * 
	 * 不同序列的模型会有一点差异，通过继承此类来应对差异化
	 *  
	 * @author wanglei
	 * 
	 */	
	public class SeriesProxy
	{
		public function SeriesProxy()
		{
		}
		
		/**
		 */		
		private function checkPrefixAndSuffix():void
		{
			for each (var item:String in values)
			{
				var formatter:Array = item.split(item.match(/-?\d+\.?\d*/g)[0]);
				
				if (formatter.length == 2)
				{
					preffix = formatter[0];
					suffix = formatter[1];
					
					if (preffix != "" || suffix != "")
						return;
				}
				else
				{
					if (item.indexOf(formatter[0]) == 0)
						preffix = formatter[0];
					else
						suffix = formatter[0];
				}
				
			}
		}
		
		/**
		 */		
		private var preffix:String = '';
		
		/**
		 */		
		private var suffix:String = '';
		
		/**
		 */		
		public function appendFfix(pre:String, suf:String, confg:XML):void
		{
			confg.@ySuffix = suf;
			confg.@yPrefix = pre;
		}
		
		/**
		 */		
		public function applyData(data:XML, index:uint):void
		{
			data.@[labelField] = labels[index];
			data.@[valueField] = RexUtil.filterNumValue(values[index]);
		}
		
		/**
		 */		
		public function setYAxis(ss:Vector.<ISeries>, index:uint):void
		{
			if (index >= ss.length)
			{
				yAxis = ss[0].yAxis;
			}
			else
			{
				yAxis = ss[index].yAxis;
			}
		}
		
		/**
		 */		
		private var yAxis:String = null;
		
		/**
		 */		
		public function setXml(series:XML):void
		{
			checkPrefixAndSuffix();
			
			var xml:XML = <{type} seriesName={name} xField={labelField} yField={valueField} valuePrefix={preffix} valueSuffix={suffix} yAxis={yAxis}/>;
			
			series.appendChild(xml);
		}
		
		/**
		 */		
		public var index:uint;
		
		/**
		 */		
		public var type:String;
		
		/**
		 */		
		public var name:String;
		
		/**
		 */		
		public function get labelField():String
		{
			return 'x';
		}
		
		/**
		 */		
		public function get  valueField():String
		{
			return 'y'  + index.toString();
		}
		
		/**
		 */		
		public var values:Array;
		
		/**
		 * 
		 */		
		public var labels:Array;
	}
}