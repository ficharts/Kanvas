package landray.kp.maps.main
{
	import flash.geom.Rectangle;
	
	import landray.kp.maps.main.elements.*;
	import landray.kp.maps.main.util.MainUtil;
	import landray.kp.utils.CoreUtil;
	import landray.kp.view.Graph;
	
	import model.vo.ElementVO;
	import model.vo.ImgVO;
	
	import util.LayoutUtil;
	
	public final class Main extends Graph
	{
		public function Main()
		{
			super();
			initialize();
		}
		
		private function initialize():void
		{
			elements = new Vector.<Element>;
			labels   = new Vector.<Label>;
			images   = new Vector.<Image>;
		}
		
		override public function flashPlay():void
		{
			for each (var image:Image in images)
				image.smooth = false;
			for each (var label:Label in labels)
				label.smooth = false;
		}
		
		override public function flashStop():void
		{
			for each (var image:Image in images)
				image.smooth = true;
			for each (var label:Label in labels)
				label.smooth = true;
		}
		
		override public function flashTrek():void
		{
			for each (var label:Label in labels)
			{
				if (label.visible)
					label.check();
			}
		}
		
		override public function set dataProvider(value:XML):void
		{
			//clear
			for each (var element:Element in elements)
				viewer.canvas.removeChild(element);
			elements.length = labels.length = images.length = 0;
			
			//create vos and elements
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
						element.render();
						viewer.canvas.addChild(element);
						elements.push(element);
						if (element is Label) labels.push(Label(element));
						if (element is Image) images.push(Image(element));
					}
				}
				catch(error:Error) 
				{
					trace(error.getStackTrace());
				}
				
			}
		}
		
		private var elements:Vector.<Element>;
		private var labels:Vector.<Label>;
		private var images:Vector.<Image>;
	}
}