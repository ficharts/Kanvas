package landray.kp.manager
{
	import landray.kp.core.KPConfig;
	import landray.kp.core.kp_internal;
	import landray.kp.maps.main.util.MainUtil;
	import landray.kp.utils.CoreUtil;
	
	import model.vo.PageVO;
	
	import modules.pages.PageQuene;
	import modules.pages.PageUtil;
	import modules.pages.Scene;

	/**
	 */	
	public final class ManagerPage
	{
		public  static const instance:ManagerPage = new ManagerPage;
		private static var   created :Boolean;
		public function ManagerPage()
		{
			if(!created) 
			{
				created = true;
				super();
				initialize();
			} 
			else 
			{
				throw new Error("Single Ton!");
			}
		}
		
		public function next():void
		{
			if (length > 0)
				indexWithZoom = (index + 1 >= quene.length) ? -1 : index + 1;
		}
		
		public function prev():void
		{
			if (length > 0)
				indexWithZoom = (index - 1 < -1) ? quene.length - 1 : index - 1;
		}
		
		public function reset():void
		{
			if (length > 0)
				__index = -1;
		}
		
		private function initialize():void
		{
			quene = new PageQuene;
			config = KPConfig.instance;
		}
		
		private function sortVOIndex(a:PageVO, b:PageVO):int
		{
			if (a.index < b.index)
				return -1;
			else if (a.index == b.index)
				return 0;
			else
				return 1;
		}
		
		public function get index():int
		{
			return __index;
		}
		
		public function set index(value:int):void
		{
			if (value >= -1 && value < quene.length)
				__index = value;
		}
		
		/**
		 */		
		public function set indexWithZoom(value:int):void
		{
			if (value >= -1 && value < quene.length)
			{
				__index = value
					
				if (index >= 0)
				{
					config.kp_internal::controller.zoomElement(quene.pages[index]);
				}
				else
				{
					config.kp_internal::controller.zoomAuto();
				}
			}
			
		}
		
		private var __index:int = -1;
		
		public function get length():int
		{
			return quene.length;
		}
		
		public function get pages():Vector.<PageVO>
		{
			return quene.pages;
		}
			
		public function set dataProvider(value:Object):void
		{
			if (value is XMLList)
				var list:XMLList = value as XMLList;
			if (list)
			{
				var vos:Vector.<PageVO> = new Vector.<PageVO>;
				for each (var xml:XML in list)
				{
					var vo:PageVO = MainUtil.getElementVO(xml.@type) as PageVO;
					CoreUtil.mapping(xml, vo);
					vos.push(vo);
				}
				vos.sort(sortVOIndex);
				for each (vo in vos)
					quene.addPage(vo);
			}
		}
		
		private var quene:PageQuene;
		
		private var config:KPConfig;
	}
}