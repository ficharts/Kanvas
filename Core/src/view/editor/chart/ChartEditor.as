package view.editor.chart
{
	import com.kvs.charts.chart2D.encry.ISeries;
	import com.kvs.ui.label.TextInputField;
	import com.kvs.utils.RexUtil;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import flashx.textLayout.events.UpdateCompleteEvent;
	
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
			dataField.addEventListener(UpdateCompleteEvent.UPDATE_COMPLETE, textInputHandler);
			dataField.addEventListener(Event.PASTE, pastHandler);
			
			addChild(dataField);
		}
		
		/**
		 * 处理来自excel黏贴的数据, 在粘贴生效前格式化数据
		 * 
		 */		
		private function pastHandler(evt:Event):void
		{
			var data:Object = Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT);
			
			if (data == null)
				return;
			
			var s:String = data.toString();
				
			if (s.indexOf("\t") != - 1)
			{
				//把tab符号逗号
				s = s.replace(/\t/g, ",");
				
				//去掉多余逗号,重新拼接
				var lines:Array = s.split("\n");
				var newLines:Array = new Array;
				var labels:Array = new Array;
				for each (s in lines)
				{
					s = s.split(",").join(", ");
					s = s.replace(/(^\,\s)|(\,\s$)/g, "");//剔除多余的逗号
					
					labels.push(s.split(", "));//把每行的值放入一个二位数组里
				}
				
				//把序列的数据行格式化
				if (labels.length > 1 && labels[0].length + 1 == labels[1].length)
				{
					for (var i:uint = 1; i < labels.length; i ++)
						labels[i][0] = labels[i][0] + ":";// 给序列名位置做一个标示，方便后面格式化
				}
				
				//将所有数据重新组装
				newLines.length = 0;
				for each (var r:Array in labels)
				{
					s = r.join(", ");
					s = s.replace(/\:\,\s*/g, ":\n");
					
					newLines.push(s);
				}
				
				s = newLines.join('\n\n') + "\n";
				Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, s, false);
				//dataField.text = s;
			}
			
		}
		
		/**
		 */		
		private function textInputHandler(evt:UpdateCompleteEvent):void
		{
			
		}
		
		/**
		 *
		 * 修正文本中不正确的格式，如中文的逗号 
		 * 
		 */		
		public function formatText():void
		{
			var text:String = dataField.text;
			
			if (text.indexOf("，") != - 1)
			{
				text = text.replace(/\，/g, ",");
				dataField.text = text;
			}
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
			
			//获取labels
			var labels:Vector.<String> = series[0].labels;
			str += labels.join(split);
			
			// 换行
			str += "\n\n";
			
			for each (var s:ISeries in series)
			{
				str += s.exportValues(split);
				
				str += "\n\n";
			}
			
			dataField.text = str;
			dataField.updateLayout();
		}
		
		/**
		 */		
		private var split:String = ", ";
		
		/**
		 * 将文本框中的字符串解析成图表的配置和数据
		 */		
		public function applyTextToChart():void
		{
			formatText();
			
			//现有图表的序列类型
			var type:String = chart.series[0].type;
			
			
			//文本数据
			var text:String = dataField.text;
			text = text.replace(/\n+/gi,"\t");//先合并行,去掉多余的换行,同时为了防止as3对多行文字的正则匹配不准确
			
			//把每一行放到数组里
			var lines:Array = text.split("\t");
			
			if (lines.length == 0)// 没有数据
				return;
			
			var labels:Array = [];
			var seriesText:Array = new Array;
			
			var line:String;
			var i:uint;
			
			for (i = 0; i < lines.length; i ++)
			{
				line = lines[i];
				
				//先匹配序列，相邻两行/三行，一行是序列名，一行是数据
				if (i + 2 < lines.length && isSeriesName(line) && isTextData(lines[i + 2]))
				{
					seriesText.push(line + lines[i + 1] + "\n" +lines[i + 2]);
					i +=2;
					
					continue;
				}
				else if (i + 1 < lines.length && isSeriesName(line) && isTextData(lines[i + 1]))
				{
					seriesText.push(line + lines[i + 1]);
					i ++;
					
					continue;
				}
				else if (isTextData(line))
				{
					labels.push(line);
				}
				else
				{
					continue;
				}
				
			}
			
			
			//数据不够
			if (labels.length < 1 || seriesText.length < 1)
				return;
			
			//剔除前后的空格
			labels = labels[0].split(",");
			RexUtil.trimArray(labels);
			
			//根据文本数据，生成xml配置
			var ss:Vector.<SeriesProxy> = new Vector.<SeriesProxy>;
			var s:SeriesProxy;
			
			var series:XML = <series/>;
			iffixed = false;
			
			for (i = 0; i < seriesText.length; i ++)
			{
				var sa:Array = seriesText[i].split(":");
				var sn:String = sa[0];
				
				var sdata:Array;
				var bubbleData:Array;
				if (sa[1].toString().indexOf("\n") != -1)
				{
					var a:Array = sa[1].split("\n");
					sdata = a[0].split(",");
					bubbleData = a[1].split(",");
					
					RexUtil.trimArray(bubbleData);
				}
				else
				{
					sdata = sa[1].split(",");
				}
				
				//含有非数字内容的值时，退出
				for each (var item:String in sdata)
				{
					if (RexUtil.ifHasNumValue(item) == false)
						return;
				}
				
				RexUtil.trimArray(sdata);
				checkPrefixAndSuffix(sdata);
				
				// 先建立模型
				if (type == "bar")
				{
					s = new BarSeriesProxy;
				}
				else if (type == "stackedColumn")
				{
					s = new StackedColumnProxy;
				}
				else if (type == "stackedBar")
				{
					s = new StackedBarProxy;
				}
				else if (type == "bubble")
				{
					s = new BubbleSeriesProxy;
					(s as BubbleSeriesProxy).bubbles = bubbleData;
				}
				else if (type == "pie")
				{
					s = new PieSeriesProxy;
				}
				else 
				{
					s = new SeriesProxy;
				}
					
				s.type = type;
				s.name = sn;
				s.index = i;
				s.labels = labels;
				s.values = sdata;
				ss.push(s);
				
				s.setXml(series);
			}
			
			
			//生成数据
			var data:XML = <data/>;
			var d:XML;
			var index:uint = 0;
			for each (var label:String in labels)
			{
				d = <set/>;
				
				for each (s in ss)
					s.applyData(d, index);
				
				data.appendChild(d);
				
				index ++;
			}
			
			//组合新的配置文件
			var config:XML = chart.configXML.copy();
			config.series = series;
			config.data = data;
			s.appendFfix(preffix, suffix, config);
			
			
			chart.configXML = config;
			
			chart.render();
			
		}
		
		/**
		 * 判断一个字符串是否满足数据格式:  字符, 字符 
		 *
		 * @param s
		 * @return 
		 * 
		 */		
		private function isTextData(s:String):Boolean
		{
			var result:Array = s.match(/([^\,]*\,\s)*[^\,]*/g);
				
			if (result.length && s.match(/[^\:]*\:/g).length == 0)
				return true;
				
				
			return false;
		}
		
		/**
		 *
		 * 
		 *  
		 * @param s
		 * @return 
		 * 
		 */		
		private function isSeriesName(s:String):Boolean
		{
			if (s.match(/[^\,]*/g).length && s.match(/[^\:]*\:/g).length)
				return true;
			else
				return false;
		}
		
		/**
		 *
		 * 筛检出数据的前后缀
		 *  
		 * @param values
		 * 
		 */		
		public function checkPrefixAndSuffix(values:Array):void
		{
			if (iffixed)
				return;
			
			for each (var item:String in values)
			{
				var formatter:Array = item.split(item.match(/-?\d+\.?\d*/g)[0]);
				
				if (formatter.length == 2)
				{
					preffix = formatter[0];
					suffix = formatter[1];
					
					if (preffix != "" || suffix != "")
					{
						iffixed = true;
						return;
					}
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
		private var iffixed:Boolean = false;
		
		/**
		 * 值前缀
		 */		
		public var preffix:String = '';
		
		/**
		 * 值后缀
		 */	
		public var suffix:String = '';
		
		
		/**
		 */		
		public function resize():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(app.contentRect.x, app.contentRect.y, app.contentRect.width, app.contentRect.height);
			this.graphics.endFill();
			
			dataField.textWidth = app.contentRect.width - 5;
			dataField.textHeight = app.contentRect.height - 5;
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

