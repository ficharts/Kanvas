package view.interact.interactMode
{
	import com.kvs.utils.Map;
	
	import model.flashes.Flasher;
	import model.vo.PageVO;
	
	import view.element.ElementBase;
	import view.interact.CoreMediator;
	
	/**
	 *
	 * 页面内容编辑状态，现用来编辑页面内容元素的闪现
	 *  
	 * @author wanglei
	 * 
	 */	
	public class PageEditMode extends ModeBase
	{
		public function PageEditMode(mainMediator:CoreMediator)
		{
			super(mainMediator);
		}
		
		/**
		 * 
		 * 传递页面类型的元素，根据其初始化编辑状态
		 */		
		public function init(element:ElementBase):void
		{
			curPage = element;
			curPage.numLabel.mouseEnabled = curPage.numLabel.mouseChildren = curPage.numLabel.buttonMode = false;
			
			childElements.clear();
			flashers.clear();
			
			//将页面的动画抓取出来
			if (curPage.vo.pageVO.flashers)
			{
				for each (var f:Flasher in curPage.vo.pageVO.flashers)
				flashers.put(f.elementID, f);
			}
			
			curPage = element;
			
			var elements:Vector.<ElementBase> = mainMediator.collisionDetection.elements;
			var ele:ElementBase;
			
			var eleInPage:ElementBase;
			for each (ele in elements)
			{
				eleInPage = mainMediator.collisionDetection.ifElementIn(ele, curPage);
				
				//检测原件在页面内, 并且自身不是页面
				if (eleInPage && eleInPage != curPage && eleInPage.isPage == false)
					childElements.put(eleInPage.vo.id, eleInPage);
			}
			
			//模拟生成动画
			var flasher:Flasher;
			for each (ele in childElements)
			{
				flasher = new Flasher();
				flasher.element = ele;
				
				flashers.put(flasher.elementID, flasher);
			}
			
		}
		
		/**
		 */		
		override public function overEle(ele:ElementBase):void
		{
			
		}
		
		/**
		 */		
		override public function outEle():void
		{
			
		}
		
		/**
		 */		
		private var flashers:Map = new Map;
		
		/**
		 */		
		private var childElements:Map = new Map;
		
		/**
		 */		
	 	private var curPage:ElementBase;
		
		/**
		 */		
		override public function zoomPageByNum(page:PageVO):void
		{
		}
		
		/**
		 */		
		override public function selectElement(element:ElementBase):void
		{
			
		}
		
		/**
		 */		
		override public function startMoveEle(e:ElementBase):void
		{
			
		}
		
		/**
		 */		
		override public function stopMoveEle():void
		{
			
		}
		
		/**
		 */		
		override public function toUnSelectedMode():void
		{
			//重设页面的动画
			if (flashers.isEmpty() == false)
			{
				curPage.vo.pageVO.flashers = new Vector.<Flasher>;
					
				
				
			}
			
			curPage.numLabel.mouseEnabled = curPage.numLabel.mouseChildren = true;
			curPage = null;
			
			mainMediator.enableKeyboardControl();
			mainMediator.currentMode = mainMediator.unSelectedMode;
			
			mainMediator.zoomMoveControl.enable();
			
			
		}
	}
}