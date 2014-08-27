package view.interact.interactMode
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import model.vo.PageVO;
	
	import modules.pages.flash.FlasherHolder;
	import modules.pages.flash.IFlash;
	
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
		 * 删除所有动画控制器
		 */		
		public function reset():void
		{
			
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
			
			mainMediator.mainUI.dispatchEvent(new KVSEvent(KVSEvent.DATA_CHANGED));
		}
		
		/**
		 * 删除当前动画，重新排列其余动画的index
		 */		
		public function removeFlash(fhr:FlasherHolder):void
		{
			var holders:Vector.<FlasherHolder> = freshIndex();
			
			for each (var fh:FlasherHolder in holders)
				fh.rework();
				
				mainMediator.mainUI.dispatchEvent(new KVSEvent(KVSEvent.DATA_CHANGED));
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
			
			holdersHasFlash.sort(sortHolders);
			
			function sortHolders(a:FlasherHolder, b: FlasherHolder):Object
			{
				if (a.flasher.index > b.flasher.index)
					return 1;
				else if (a.flasher.index < b.flasher.index)
					return - 1;
				else
					return 0;
				
				return 0;
			}
			
			/*for (i = 0; i < holdersHasFlash.length - 1; i ++)
			{
				if (holdersHasFlash[i + 1].flasher.index < holdersHasFlash[i].flasher.index)
				{
					temHolder = holdersHasFlash[i + 1];
					holdersHasFlash[i + 1] = holdersHasFlash[i];
					holdersHasFlash[i] = temHolder;
				}
			}*/
			
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
			ifConfirmData = true;
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
					fh.w = ele.scaledWidth * mainMediator.canvas.scaleX;
					fh.h = ele.scaledHeight * mainMediator.canvas.scaleY;
					fh.rotation = ele.vo.rotation + mainMediator.canvas.rotation;
					fh.render();
					
					flasherHolders.push(fh);
					mainMediator.mainUI.addChild(fh);
				}
			}
			
			//将页面的动画抓取出来, 匹配到元素动画管理器上
			if (curPage.vo.pageVO.flashers)
			{
				for each (var f:IFlash in curPage.vo.pageVO.flashers)
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
			
			//点击或者esc按键方式取消页面动画编辑
			mainMediator.mainUI.canvas.addEventListener(MouseEvent.CLICK, canvasClickHandler, false, 0, true);
			mainMediator.mainUI.stage.addEventListener(KeyboardEvent.KEY_UP, escHandler, false, 0, true);
		}
		
		/**
		 */		
		override public function resetPageEdit():void
		{
			for each (var fh:FlasherHolder in flasherHolders)
			{
				fh.flasher = null;
				fh.rework();
			}
		}
		
		/**
		 * 把旧的页面动画数据重新付给当前holders
		 */		
		override public function cancelPageEdit():void
		{
			ifConfirmData = false;
		}
		
		/**
		 * 默认退出时都会确认页面动画，如果用户取消页面编辑，则不确认
		 */		
		private var ifConfirmData:Boolean = false;
		
		/**
		 */		
		override public function toSelectMode():void
		{
			var fh:FlasherHolder;
			
			if (ifConfirmData)
			{
				var holders:Vector.<FlasherHolder> = freshIndex();
				curPage.vo.pageVO.flashers = new Vector.<IFlash>;
				
				for each (fh in holders)
				curPage.vo.pageVO.flashers.push(fh.flasher);
			}
			
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
			//curPage = null;
			
			mainMediator.enableKeyboardControl();
			mainMediator.currentMode = mainMediator.selectedMode;
			
			mainMediator.zoomMoveControl.enable();
			
			mainMediator.mainUI.canvas.removeEventListener(MouseEvent.CLICK, canvasClickHandler);
			mainMediator.mainUI.stage.removeEventListener(KeyboardEvent.KEY_UP, escHandler);
			
			mainMediator.resetCanvasState();
			
			mainMediator.currentElement = curPage;
			curPage.toSelectedState();
			mainMediator.showSelector();
			
			curPage = null;
		}
		
		/**
		 */		
		private function canvasClickHandler(evt:MouseEvent):void
		{
			var point:Point = new Point(evt.stageX, evt.stageY);
			
			//如果鼠标点击到页面区域以外，推出页面编辑状态
			if(curPage.hitTestPoint(point.x, point.y) == false)
				mainMediator.mainUI.dispatchEvent(new KVSEvent(KVSEvent.CONFIRM_PAGE_EDIT));
		}
		
		/**
		 */		
		private function escHandler(evt:KeyboardEvent):void
		{
			if (evt.keyCode == Keyboard.ESCAPE)
				mainMediator.mainUI.dispatchEvent(new KVSEvent(KVSEvent.CANCEL_PAGE_EDIT));
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