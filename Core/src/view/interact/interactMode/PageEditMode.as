package view.interact.interactMode
{
	import com.kvs.utils.Map;
	
	import flash.geom.Point;
	
	import model.vo.PageVO;
	
	import modules.pages.flash.Flasher;
	import modules.pages.flash.FlasherHolder;
	
	import util.LayoutUtil;
	
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
		 * 根据当前的动画编号，设定新添加的动画编号
		 */		
		public function addFlash(fhr:FlasherHolder):void
		{
			var index:uint = 0;
			for each (var fh:FlasherHolder  in flasherHolders)
			{
				if (fh.flasher && fh.flasher.index > index)
					index = fh.flasher.index;
			}
			
			fhr.flasher.index = index + 1;
			
			freshIndex();
			fhr.rework();
		}
		
		/**
		 * 
		 * 删除当前动画，重新排列其余动画的index
		 */		
		public function removeFlash(fhr:FlasherHolder):void
		{
			var holders:Vector.<FlasherHolder> = freshIndex();
			
			for each (var fh:FlasherHolder in holders)
				fh.rework();
		}
		
		/**
		 *  按照动画编号的顺序从小到大排列flasherholder 
		 * 
		 */		
		private function freshIndex():Vector.<FlasherHolder>
		{
			var holdersHasFlash:Vector.<FlasherHolder> = new Vector.<FlasherHolder>;
			for each(var fh:FlasherHolder in flasherHolders)
			{
				if (fh.flasher)
					holdersHasFlash.push(fh);
			}
			
			var temHolder:FlasherHolder;
			var i:uint;
			for (i = 0; i < holdersHasFlash.length - 1; i ++)
			{
				if (holdersHasFlash[i + 1].flasher.index < holdersHasFlash[i].flasher.index)
				{
					temHolder = holdersHasFlash[i + 1];
					holdersHasFlash[i + 1] = holdersHasFlash[i];
					holdersHasFlash[i] = temHolder;
				}
			}
			
			for (i = 0; i < holdersHasFlash.length; i ++)
			{
				holdersHasFlash[i].flasher.index = i + 1;
			}
			
			return holdersHasFlash;
		}
		
		
		/**
		 * 
		 * 传递页面类型的元素，根据其初始化编辑状态
		 */		
		public function init():void
		{
			curPage.numLabel.mouseEnabled = curPage.numLabel.mouseChildren = curPage.numLabel.buttonMode = false;
			
			flasherHolders.length = 0;
			
			var elements:Vector.<ElementBase> = mainMediator.collisionDetection.elements;
			var ele:ElementBase;
			
			var eleInPage:ElementBase;
			var fh:FlasherHolder;
			
			//将页面内的基本原件交给flasherholder临时管理
			for each (ele in elements)
			{
				eleInPage = mainMediator.collisionDetection.ifElementIn(ele, curPage);
				
				//检测原件在页面内, 并且自身不是页面
				if (eleInPage && eleInPage != curPage && eleInPage.isPage == false)
				{
					fh = new FlasherHolder(eleInPage, mainMediator, this);
					
					
					var point:Point = LayoutUtil.elementPointToStagePoint(ele.vo.x, ele.vo.y, mainMediator.canvas);
					fh.x = point.x;
					fh.y = point.y;
					fh.w = ele.scaledWidth * mainMediator.canvas.scale;
					fh.h = ele.scaledHeight * mainMediator.canvas.scale;
					
					flasherHolders.push(fh);
					mainMediator.mainUI.addChild(fh);
				}
			}
			
			//将页面的动画抓取出来, 匹配到元素动画管理器上
			if (curPage.vo.pageVO.flashers)
			{
				for each (var f:Flasher in curPage.vo.pageVO.flashers)
				{
					for each (fh in flasherHolders)
					{
						if (f.element == fh.ele)
						{
							fh.flasher = f;
							fh.rework();
							
							break;
						}
					}
				}
				
			}
			
		}
		
		/**
		 */		
		override public function toUnSelectedMode():void
		{
			var holders:Vector.<FlasherHolder> = freshIndex();
			var fh:FlasherHolder;
			
			curPage.vo.pageVO.flashers = new Vector.<Flasher>;
			for each (fh in holders)
				curPage.vo.pageVO.flashers.push(fh.flasher);
			
			//重设页面的动画
			if (flasherHolders.length)
			{
				for each (fh in flasherHolders)
				{
					fh.destroy();
					if (mainMediator.mainUI.contains(fh))
						mainMediator.mainUI.removeChild(fh);
				}
			}
			
			flasherHolders.length = 0;
			
			curPage.numLabel.mouseEnabled = curPage.numLabel.mouseChildren = true;
			curPage = null;
			
			mainMediator.enableKeyboardControl();
			mainMediator.currentMode = mainMediator.unSelectedMode;
			
			mainMediator.zoomMoveControl.enable();
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
		private var flasherHolders:Vector.<FlasherHolder> = new Vector.<FlasherHolder>;
		
		/**
		 */		
		public var curPage:ElementBase;
		
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
	}
}