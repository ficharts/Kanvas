package util.textFlow
{
	import com.kvs.utils.ClassUtil;
	import com.kvs.utils.RexUtil;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.text.engine.FontLookup;
	import flash.text.engine.TextLine;
	
	import flashx.textLayout.compose.ISWFContext;
	import flashx.textLayout.compose.TextLineRecycler;
	import flashx.textLayout.container.TextContainerManager;
	import flashx.textLayout.conversion.ITextImporter;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.factory.StringTextLineFactory;
	import flashx.textLayout.factory.TextFlowTextLineFactory;
	
	import model.vo.TextVO;

	/**
	 * 全局字体管理类， 负责加载嵌入字体，因嵌入字体过大，需采用异步加载机制；
	 * 
	 * 嵌入字体未加载好之前先以设备字体方式渲染文本， 字体加载完成后采用嵌入字体渲染
	 * 
	 * 重新用嵌入字体渲染之前的采用设备字体的文本；
	 *  
	 */	
	public class FlowTextManager
	{
		/**
		 * 嵌入字体为加载成功前，先注册文本并用设备字体绘制，待字体加载成功后
		 * 
		 * 正式重绘
		 */		
		public static function register(field:ITextFlowLabel):void
		{
			instance.register(field);
		}
		
		/**
		 */		
		public static function renderTextVOLabel(label:ITextFlowLabel, textVO:TextVO):void
		{
			instance.renderTextVOLabel(label, textVO);
		}
		
		/**
		 */		
		public static function render(label:ITextFlowLabel, format:TextFormat, ifUseEmbedFont:Boolean = false):void
		{
			instance.render(label, format, ifUseEmbedFont);
		}
		
		/**
		 * 根据文本内容，自动计算预设宽高，用预设宽高刷新文本;
		 */		
		public static function updateTexLayout(txt:String, txtMNG:TextContainerManager, fixWidth:Number = 0):void
		{
			instance.updateTxtLayout(txt, txtMNG, fixWidth);
		}
		
		/**
		 * 把文本模型应用至文本
		 */		
		public static function applyTextVOToTextField(field:ITextFlowLabel, textVO:TextVO):void
		{
			instance.applyTextVOToTextField(field, textVO);
		}
		
		/**
		 * 初始化文本的最小尺寸
		 */		
		public static function initTextSize(texM:TextContainerManager):void
		{
			instance.initTextSize(texM);
		}
		
		/**
		 * 文本框的最小宽度
		 */		
		public static var txtMinWidth:Number = 0;
		
		/**
		 * 文本框的最小高度
		 */		
		public static var txtMinHeight:Number = 0;
		
		/**
		 */		
		public function FlowTextManager(key:Inner)
		{
			var fontList:Array = Font.enumerateFonts(true);
			
			fontList.sortOn("fontName", Array.CASEINSENSITIVE);
			
			for each (var font:Font in fontList) 
				sysFonts.push(font.fontName);
		}
		
		
		/**
		 */		
		private var sysFonts:Array = new Array;
		
		
		
		
		
		
		
		//----------------------------------------------------------
		//
		//
		// 文本绘制
		//
		//
		//----------------------------------------------------------
		
		/**
		 */		
		private function updateTxtLayout(text:String, txtManager:TextContainerManager, fixWidth:Number = 0):void
		{
			if (ifNeedUpdate)
			{
				if (RexUtil.ifTextNull(text))
				{
					mesuredBound.width = txtMinWidth;
					mesuredBound.height = txtMinHeight;
				}
				else
				{
					if (fixWidth > 0)
						readyBound.width = fixWidth;
					else
						readyBound.width = NaN;
					
					if (text.indexOf("\n") != -1 || text.indexOf("\r") != -1)
					{
						//多行文本
						
						var stringToTextFlow:ITextImporter = TextConverter.getImporter(TextConverter.PLAIN_TEXT_FORMAT);
						
						multyLineTextFlow = stringToTextFlow.importToFlow(text);
						if (multyLineTextFlow)
						{
							multyLineTextFlow.hostFormat = txtManager.hostFormat;
							
							staticTextFlowFactory.compositionBounds = readyBound;
							
							staticTextFlowFactory.createTextLines(recycleTextLine, multyLineTextFlow);
							mesuredBound = staticTextFlowFactory.getContentBounds();
						}
						
					}
					else
					{
						updateSingleLineBound(text, txtManager);
					}
					
					// 仅当设置了fixwidth时，其才生效
					if (fixWidth > 0)
						mesuredBound.width = fixWidth;
					
					//if (mesuredBound.width < txtMinWidth)
						//mesuredBound.width = txtMinWidth
				}
				
				txtManager.compositionWidth = Math.ceil(mesuredBound.width);
				txtManager.compositionHeight =  Math.ceil(mesuredBound.height);
				
				//只有通过调用此函数才能刷新文本，updateContainer 不会触发循环刷新
				ifNeedUpdate = false;
				txtManager.updateContainer();
				ifNeedUpdate = true;
			}
		}
		
		/**
		 */		
		private function initTextSize(txtM:TextContainerManager):void
		{
			var mesureBound:Rectangle = updateSingleLineBound("大", txtM);
			
			txtM.compositionWidth = Math.ceil(mesureBound.width);
			txtM.compositionHeight = Math.ceil(mesureBound.height);
			
			txtMinWidth = txtM.compositionWidth;
			txtMinHeight = txtM.compositionHeight;
				
			txtM.updateContainer();
		}
		
		
									  
		/**
		 * 防止txtManager上的更新时间造成刷新的死循环
		 */	
		private var ifNeedUpdate:Boolean = true;
		
		
		/**
		 * 根据字符，得出文本框尺寸(单行)
		 */		
		private function updateSingleLineBound(txt:String, txtManager:TextContainerManager):Rectangle
		{
			staticStringFactory.compositionBounds = readyBound;
			staticStringFactory.text = txt;
			staticStringFactory.textFlowFormat = txtManager.hostFormat;
			staticStringFactory.createTextLines(recycleTextLine);
			
			//staticStringFactory.
			
			mesuredBound = staticStringFactory.getContentBounds();
			return mesuredBound;
		}
		
		/**
		 */		
		public function recycleTextLine(textLine:TextLine):void
		{
			if (textLine)
			{
				textLine.userData = null;
				TextLineRecycler.addLineForReuse(textLine);
			}
		}
		
		/**
		 */		
		private var readyBound:Rectangle = new Rectangle(0, 0, NaN, NaN);
		
		/**
		 * 文本预设尺寸
		 */		
		private var mesuredBound:Rectangle = new Rectangle;
		
		/**
		 */		
		private var staticTextFlowFactory:TextFlowTextLineFactory = new TextFlowTextLineFactory();
		
		/**
		 */		
		private var staticStringFactory:StringTextLineFactory = new StringTextLineFactory(); 
		
		/**
		 * 多行文本，用来计算多行文本的尺寸
		 */		
		private var multyLineTextFlow:TextFlow; 
		
		
		/**
		 * 渲染文本，字体未加载完成时，先按嵌入字体模式渲染
		 * 
		 * 同时将此文本加入渲染队列，待字体加载完毕后重新渲染；
		 */		
		private function renderTextVOLabel(field:ITextFlowLabel, textVO:TextVO):void
		{
			if (ifFontLoaded)
			{
				field.textLayoutFormat.fontLookup = FontLookup.EMBEDDED_CFF;
			}
			else
			{
				field.textLayoutFormat.fontLookup = FontLookup.DEVICE;
				register(field);
			}
			
			applyTextVOToTextField(field, textVO);
		}
		
		/**
		 * 
		 */		
		private function render(field:ITextFlowLabel, textFormat:TextFormat, ifUseEmbedFont:Boolean = false):void
		{
			if (ifUseEmbedFont)
			{
				if (ifFontLoaded)
				{
					field.textLayoutFormat.fontLookup = FontLookup.EMBEDDED_CFF;
				}
				else
				{
					field.textLayoutFormat.fontLookup = FontLookup.DEVICE;
					register(field);
				}
			}
			
			applyTextformat(field, textFormat);
			field.textManager.setText(field.text);
			updateTxtLayout(field.text, field.textManager, field.fixWidth);
		}
		
		/**
		 * 字体未加载好渲染了的文本被注册， 自己加载ok后重新渲染一次，然后注销；
		 * 
		 * 如果文本在字体加载完成之前被移除，则取消这里的注册；
		 */		
		public function register(item:ITextFlowLabel):void
		{
			var index:int = labelsForRender.indexOf(item);
			
			// 字体加载失败后，不再注册
			if (index == - 1 && ifLoadFontFaild == false)
				labelsForRender.push(item);
		}
		
		/**
		 * 字体加载成功后，对已经渲染了的文本重绘
		 */		
		public function reRender(field:ITextFlowLabel):void
		{
			field.textManager.swfContext = fontInstance;
			field.textLayoutFormat.fontLookup = FontLookup.EMBEDDED_CFF;
			
			// 没有一下这两句，嵌入字体即使加载完成后，他他妈的也不会自动重绘；
			// 这两句缺一不可
			field.textManager.hostFormat = field.textLayoutFormat;
			field.textManager.updateContainer();
			field.afterReRender();
		}
		
		/**
		 * 根据文本VO重绘文本
		 */		
		private function applyTextVOToTextField(field:ITextFlowLabel, textVO:TextVO):void
		{
			// 样式模型转换
			var textFormat:TextFormat = textVO.label.getTextFormat(textVO);
			applyTextformat(field, textFormat);
			
			field.ifMutiLine = textVO.ifMutiLine;
			field.fixWidth = textVO.width;
			
			//重绘文本
			field.textManager.setText(textVO.text);
			
			if (field.ifMutiLine == false)
			{
				//防止文本vo定义的尺寸太小
				var bd:Rectangle = updateSingleLineBound(textVO.text, field.textManager);
				field.textManager.compositionWidth = bd.width;
				field.textManager.compositionHeight = bd.height;
				
				textVO.width = bd.width;
				textVO.height = bd.height;
			}
			else
			{
				field.textManager.compositionWidth = textVO.width;
				field.textManager.compositionHeight = textVO.height;
			}
			
			field.textManager.updateContainer();
		}
		
		/**
		 */		
		private function applyTextformat(field:ITextFlowLabel, format:TextFormat):void
		{
			if (ifUseEmbedFont)
			{
				field.textLayoutFormat.fontFamily = format.font;
			}
			else
			{
				if (sysFonts.indexOf(format.font) != - 1)
					field.textLayoutFormat.fontFamily = format.font;
				else if (sysFonts.indexOf("微软雅黑") != - 1)
					field.textLayoutFormat.fontFamily = "微软雅黑";
				else if (sysFonts.indexOf("黑体") != - 1)
					field.textLayoutFormat.fontFamily = "黑体";
				else
					field.textLayoutFormat.fontFamily = "华文细黑";
			}
			
			field.textLayoutFormat.fontSize = format.size;
			field.textLayoutFormat.color = format.color;
			
			field.textLayoutFormat.lineHeight = "140%";
			
			field.textManager.hostFormat = field.textLayoutFormat;
		}
		
		/**
		 * 桌面模式开启后，防止文本编辑器的字体手影响
		 */		
		public static var ifUseEmbedFont:Boolean = false;
		
		
		
		
		
		
		
		
		//----------------------------------------------------------
		//
		//
		// 嵌入字体加载
		//
		//
		//----------------------------------------------------------
		
		
		/**
		 * 
		 */		
		public static function loadFont(url:String):void
		{
			instance.loadFont(url);
		}
		
		/**
		 * 加载字体文件
		 */		
		private function loadFont(url:String):void
		{
			fontLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, fontLoaded, false, 0, true);
			fontLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, fontLoadFail, false, 0, true);
			
			try
			{
				var loadContext:LoaderContext = new LoaderContext;
				loadContext.applicationDomain = ApplicationDomain.currentDomain;
				fontLoader.load(new URLRequest(url), loadContext);
			} 
			catch(error:Error) 
			{
				
			}
			
		}
		
		/**
		 */		
		private function fontLoadFail(value:IOErrorEvent):void
		{
			labelsForRender.length = 0;
			ifLoadFontFaild = true;
		}
		
		/**
		 */		
		private var ifLoadFontFaild:Boolean = false;
		
		/**
		 */		
		private function fontLoaded(evt:Event):void
		{
			Font.registerFont(fontLoader.content['YaHei']);
			Font.registerFont(fontLoader.content['FangSong']);
			Font.registerFont(fontLoader.content['Sonti']);
			
			sysFonts = sysFonts.concat(fontLoader.content['fonts']);
			
			ifFontLoaded = true;
			
			fontInstance = ClassUtil.getObjectByClassPath('FontLib') as ISWFContext;
			
			staticTextFlowFactory.swfContext = fontInstance;
			staticStringFactory.swfContext = fontInstance;
				
			while(labelsForRender.length)
				reRender(labelsForRender.pop())
		}
		
		/**
		 */		
		private var fontInstance:ISWFContext;
		
		/**
		 * 是否字体已经加载完毕
		 */		
		private var ifFontLoaded:Boolean = false;
		
		/**
		 */		
		private var fontLoader:Loader = new Loader;
		
		/**
		 */		
		private var labelsForRender:Vector.<ITextFlowLabel> = new Vector.<ITextFlowLabel>;
		
		/**
		 * 获取文字管理实例
		 */		
		public static function get instance():FlowTextManager
		{
			if (_instance == null)
				_instance = new FlowTextManager(new Inner);
			
			return _instance;
		}
		
		/**
		 */		
		private static var _instance:FlowTextManager
		
		
	}
}

class Inner 
{
	public function Inner()
	{
		
	}
}