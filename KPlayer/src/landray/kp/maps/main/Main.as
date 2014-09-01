package landray.kp.maps.main
{
	import landray.kp.core.KPConfig;
	import landray.kp.core.kp_internal;
	import landray.kp.maps.main.elements.*;
	import landray.kp.maps.main.util.MainUtil;
	import landray.kp.utils.CoreUtil;
	import landray.kp.view.Graph;
	
	import model.vo.ElementVO;
	
	/**
	 */	
	public final class Main extends Graph
	{
		public function Main()
		{
			super();
			initialize();
		}
		
		/**
		 */		
		private function initialize():void
		{
			elements = new Vector.<Element>;
			labels   = new Vector.<Label>;
			images   = new Vector.<Image>;
			groups   = new Vector.<Group>;
		}
		
		/**
		 */		
		override public function flashPlay():void
		{
			for each (var image:Image in images)
				image.smooth = false;
		}
		
		/**
		 */		
		override public function flashStop():void
		{
			for each (var image:Image in images)
				image.smooth = true;
		}
		
		/**
		 */		
		override public function flashTrek():void
		{
			for each (var label:Label in labels)
			{
				if (label.visible)
					label.check();
			}
		}
		
		/**
		 */		
		override public function set dataProvider(value:XML):void
		{
			//clear
			for each (var element:Element in elements)
				viewer.canvas.removeChild(element);
				
			elements.length = labels.length = images.length = groups.length = 0;
			
			//create vos and elements
			var config:KPConfig = KPConfig.instance;
			config.kp_internal::elementMap.clear();
			
			var list:XMLList = value.children();
			for each (var xml:XML in list) 
			{
				var vo:ElementVO = MainUtil.getElementVO(String(xml.@type));
				CoreUtil.mapping(xml, vo);
				
				try
				{
					//这里他妈的有特殊字符的话就导致崩溃了
					element = MainUtil.getElementUI(vo);
					
					if (element)
					{
						CoreUtil.applyStyle(element.vo);
						CoreUtil.mapping(xml, vo);
						viewer.canvas.addChild(element);
						element.render();
						
						elements.push(element);
						config.kp_internal::elementMap.put(element.vo.id.toString(), element);
						
						if (element is Label) labels.push(Label(element));
						if (element is Image) images.push(Image(element));
						
						if (element is Group)
						{
							element.vo.xml = xml;
							groups.push(element);
						}
					}
				}
				catch(error:Error) 
				{
					trace(error.getStackTrace());
				}
				
			}
			
			//组合的初始化, 匹配组合关系
			for each(var groupElement:Group in groups)
			{
				for each(var item:XML in groupElement.vo.xml.children())
				{
					element = config.kp_internal::elementMap.getValue(item.@id.toString());		
					groupElement.childElements.push(element);
				}
			}
			
		}
		
		private var elements:Vector.<Element>;
		private var labels:Vector.<Label>;
		private var images:Vector.<Image>;
		private var groups:Vector.<Group>;
		
	}
}