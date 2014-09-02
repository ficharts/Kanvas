package landray.kp.manager
{
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	
	import landray.kp.core.KPConfig;
	import landray.kp.core.kp_internal;
	import landray.kp.maps.main.util.MainUtil;
	import landray.kp.utils.CoreUtil;
	
	import model.vo.PageVO;
	
	import modules.pages.IPageManager;
	import modules.pages.PageQuene;
	import modules.pages.flash.FlashChart;
	import modules.pages.flash.FlashIn;
	import modules.pages.flash.FlashOut;
	import modules.pages.flash.IFlash;
	
	import view.element.IElement;

	/**
	 */	
	public final class ManagerPage implements IPageManager
	{
		public  static const instance:ManagerPage = new ManagerPage;
		private static var   created :Boolean;
		
		/**
		 */		
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
		
		/**
		 */		
		public function next():void
		{
			if (length > 0)
			{
				var curPage:PageVO;
				if (index != - 1)
					curPage = quene.getPageAt(index);
				
				var nextIndex:int = (index + 1 >= quene.length) ? -1 : index + 1;
				
				if (curPage && curPage.flashers && curPage.flashers.length)
				{
					if (curPage.flashIndex < curPage.flashers.length)
					{
						curPage.flashers[curPage.flashIndex].next();
						curPage.flashIndex += 1;
					}
					else
					{
						indexWithZoom = nextIndex;
					}
				}
				else
				{
					indexWithZoom = nextIndex;
				}
			}
		}
		
		/**
		 */		
		public function prev():void
		{
			if (length > 0)
			{
				var curPage:PageVO;
				
				if (index != - 1)
					curPage = quene.getPageAt(index);
				
				var prevIndex:int = (index - 1 < -1) ? quene.length - 1 : index - 1;
				
				if (curPage && curPage.flashers && curPage.flashers.length)
				{
					if (curPage.flashIndex == 0)
					{
						indexWithZoom = prevIndex;
					}
					else
					{
						curPage.flashIndex -= 1;
						curPage.flashers[curPage.flashIndex].prev();
					}
				}
				else
				{
					indexWithZoom = prevIndex;
				}
			}
		}
		
		/**
		 */		
		public function reset():void
		{
			if (length > 0)
				__index = -1;
		}
		
		/**
		 */		
		private function initialize():void
		{
			quene = new PageQuene;
			config = KPConfig.instance;
		}
		
		/**
		 */		
		private function sortVOIndex(a:PageVO, b:PageVO):int
		{
			if (a.index < b.index)
				return -1;
			else if (a.index == b.index)
				return 0;
			else
				return 1;
		}
		
		/**
		 */		
		public function get index():int
		{
			return __index;
		}
		
		/**
		 */		
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
		
		/**
		 */		
		private var __index:int = -1;
		
		/**
		 */		
		public function get length():uint
		{
			return quene.length;
		}
		
		/**
		 */		
		public function get pages():Vector.<PageVO>
		{
			return quene.pages;
		}
			
		/**
		 */		
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
					
					initPageFlashes(vo, xml);
					
					vo.flashIndex = 0;
					var flasher:IFlash;
					
					for each (flasher in vo.flashers)
						flasher.start();
					
					vos.push(vo);
				}
				
				vos.sort(sortVOIndex);
				for each (vo in vos)
					quene.addPage(vo);
			}
		}
		
		/**
		 */			
		private function initPageFlashes(page:PageVO, pageXML:XML):void
		{
			if (pageXML.hasOwnProperty("flashes"))
			{
				page.flashers = new Vector.<IFlash>;
				
				var f:IFlash;
				var fxml:XML;
				var nodeN:String;
				for each(fxml in pageXML.flashes.children())
				{
					nodeN = fxml.name();
					
					if (nodeN == "flashIn")
						f = new FlashIn();
					else if (nodeN == "flashOut")
						f = new FlashOut();
					else if (nodeN == "flashChart")
						f = new FlashChart();
					else
						f = new FlashIn();
					
					XMLVOMapper.fuck(fxml, f);
					f.element = config.kp_internal::elementMap.getValue(f.elementID.toString()) as IElement;// 匹配动画原件
					
					page.flashers.push(f);
				}
			}
		}
		
		/**
		 */		
		private var quene:PageQuene;
		
		/**
		 */		
		private var config:KPConfig;
	}
}