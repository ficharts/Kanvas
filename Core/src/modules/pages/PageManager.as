package modules.pages
{
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.PerformaceTest;
	import com.kvs.utils.RectangleUtil;
	import com.kvs.utils.graphic.BitmapUtil;
	
	import commands.Command;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import model.CoreFacade;
	import model.CoreProxy;
	import model.ElementProxy;
	import model.vo.PageVO;
	
	import util.CoreUtil;
	import util.LayoutUtil;
	
	import view.element.ElementBase;
	import view.element.PageElement;
	import view.interact.CoreMediator;
	import view.ui.MainUIBase;

	[Event(name="pageAdded", type="modules.pages.PageEvent")]
	
	[Event(name="pageDeleted", type="modules.pages.PageEvent")]
	
	[Event(name="updatePagesLayout", type="modules.pages.PageEvent")]
	
	/**
	 * 负责页面的创建，编辑，删除等
	 */	
	public final class PageManager extends EventDispatcher
	{
		
		public function PageManager($coreMdt:CoreMediator)
		{
			pageQuene = new PageQuene;
			pageQuene.addEventListener(PageEvent.PAGE_ADDED, defaultHandler);
			pageQuene.addEventListener(PageEvent.PAGE_DELETED, defaultHandler);
			pageQuene.addEventListener(PageEvent.UPDATE_PAGES_LAYOUT, defaultHandler);
		}
		
		/**
		 * 根据画布当前布局获取pageVO
		 */
		public function addPageFromUI(index:int = 0):void
		{
			var bound:Rectangle = coreMdt.coreApp.bound;
			var proxy:ElementProxy = new ElementProxy;
			
			
			
			proxy.x = (bound.left + bound.right) * .5;
			proxy.y = (bound.top + bound.bottom) * .5;
			proxy.rotation = - coreMdt.canvas.rotation;
			proxy.width = bound.width ;
			proxy.height = bound.height;
			if (proxy.height / proxy.width < .75) proxy.width = proxy.height / .75;
			else if (proxy.height / proxy.width > .75) proxy.height = proxy.width * .75;
			proxy.index = (index > 0 && index < length) ? index : length;
			proxy.ifSelectedAfterCreate = false;
			
			__index = proxy.index;
			
			coreMdt.createNewShapeMouseUped = true;
			coreMdt.sendNotification(Command.CREATE_PAGE, proxy);
		}
		
		/**
		 * 添加页
		 */
		public function addPage(pageVO:PageVO):PageVO
		{
			pageQuene.addPage(pageVO);
			__index = pageVO.index;
			return pageVO;
		}
		
		/**
		 * 在指定位置添加页，index超出范围时自动加到最后一页
		 */
		public function addPageAt(pageVO:PageVO, index:int):PageVO
		{
			pageQuene.addPageAt(pageVO, index);
			__index = pageVO.index;
			
			return pageVO;
		}
		
		/**
		 * 判断pageVO是否在队列
		 */
		public function contains(pageVO:PageVO):Boolean
		{
			return pageQuene.contains(pageVO);
		}
		
		/**
		 * 获取序号为index的pageVO
		 */
		public function getPageAt(index:int):PageVO
		{
			return pageQuene.getPageAt(index);
		}
		
		/**
		 * 获取pageVO的序号
		 */
		public function getPageIndex(pageVO:PageVO):int
		{
			return pageQuene.getPageIndex(pageVO);
		}
		
		/**
		 * 从队列中删除页
		 */
		public function removePage(pageVO:PageVO):PageVO
		{
			if (index == pageVO.index) __index = -1;
			
			return pageQuene.removePage(pageVO);
		}
		
		/**
		 * 从队列中删除序号为index的页
		 */
		public function removePageAt(index:int):PageVO
		{
			return pageQuene.removePageAt(index);
		}
		
		public function removeAllPages():void
		{
			pageQuene.removeAllPages();
			__index = -1;
		}
		
		/**
		 * 设定某页的顺序
		 */
		public function setPageIndex(pageVO:PageVO, index:int, sendEvent:Boolean = false):void
		{
			pageQuene.setPageIndex(pageVO, index, sendEvent);
		}
		
		public function next():void
		{
			indexWithZoom = (index + 1 >= pageQuene.length) ? -1 : index + 1;
		}
		
		public function prev():void
		{
			indexWithZoom = (index - 1 < -1) ? pageQuene.length - 1 : index - 1;
		}
		
		public function reset():void
		{
			__index = -1;
		}
		
		private function defaultHandler(e:PageEvent):void
		{
			dispatchEvent(e);
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
			if (value >= - 1 && value < pageQuene.length)
				__index = value;
		}
		
		/**
		 * 设置当前的页面index，并且自动缩放画布
		 */		
		public function set indexWithZoom(value:int):void
		{
			if (value >= - 1 && value < pageQuene.length)
			{
				__index = value;
				
				if (__index >= 0)
				{
					var scene:Scene = PageUtil.getSceneFromVO(pageQuene.pages[__index], coreMdt.coreApp);
					coreMdt.zoomMoveControl.zoomRotateMoveTo(scene.scale, scene.rotation, scene.x, scene.y);
				}
				else
				{
					coreMdt.zoomMoveControl.zoomAuto();
				}
			}
		}
		
		/**
		 */		
		private var __index:int = -1;
		
		/**
		 * 获取总页数
		 */
		public function get length():int
		{
			return pageQuene.length;
		}
		
		/**
		 * 获取pageVO集合
		 */
		public function get pages():Vector.<PageVO>
		{
			return pageQuene.pages;
		}
		
		private var pageQuene:PageQuene;
		
		public function notifyPageVOUpdateThumb(vo:PageVO):void
		{
			if (vo)
				vo.dispatchEvent(new PageEvent(PageEvent.UPDATE_THUMB, vo));
		}
		
		public function registOverlappingPageVOs(current:ElementBase):void
		{
			if (current.isPage && current.parent) //元素本身是页面
			{
				registUpdateThumbVO(current.vo.pageVO);
			}
			if (current.screenshot) //元素为可见元素
			{
				var elements:Vector.<ElementBase> = proxy.elements;
				if (elements)
				{
					var currentRect:Rectangle = LayoutUtil.getItemRect(coreMdt.canvas, current, false, true, false);
					for each(var element:ElementBase in elements)
					{
						if (element.isPage)
						{
							var elementRect:Rectangle = LayoutUtil.getItemRect(coreMdt.canvas, element, false, true, false);
							if (RectangleUtil.rectOverlapping(currentRect, elementRect))
								registUpdateThumbVO(element.vo.pageVO);
						}
					}
				}
			}
		}
		
		public function registUpdateThumbVO(vo:PageVO):void
		{
			if (refreshed)
			{
				refreshed = false;
				updateThumbVOS.length = 0;
			}
			if (vo)
			{
				if (updateThumbVOS.indexOf(vo) == -1)
				{
					vo.thumbUpdatable = false;
					updateThumbVOS.push(vo);
				}
			}
		}
		
		public function refreshVOThumbs(pageVOs:Vector.<PageVO> = null):Vector.<PageVO>
		{
			refreshed = true;
			if (pageVOs)
			{
				for each (var vo:PageVO in pageVOs)
					registUpdateThumbVO(vo);
			}
			var tmp:Vector.<PageVO> = updateThumbVOS;
			for each (vo in tmp)
			{
				vo.thumbUpdatable = true;
				vo.dispatchEvent(new PageEvent(PageEvent.UPDATE_THUMB, vo));
			}
			return (pageVOs) ? null : updateThumbVOS.concat();
		}
		
		private static var refreshed:Boolean = false;
		
		private static const updateThumbVOS:Vector.<PageVO> = new Vector.<PageVO>;
		
		public function refreshPageThumbsByElement(element:ElementBase):Vector.<PageVO>
		{
			var vector:Vector.<PageVO> = getOverlappingPages(element);
			for each (var vo:PageVO in vector)
				registUpdateThumbVO(vo);
			
			return refreshVOThumbs();
		}
		
		public function getOverlappingPages(current:ElementBase):Vector.<PageVO>
		{
			if (current.isPage)
			{
				var vector:Vector.<PageVO> = new Vector.<PageVO>;
				vector.push(current);
			}
			if (current.screenshot)
			{
				var elements:Vector.<ElementBase> = proxy.elements;
				if(!vector) vector = new Vector.<PageVO>;
				if( elements)
				{
					var currentRect:Rectangle = LayoutUtil.getItemRect(coreMdt.canvas, current, false, true, false);
					for each(var element:ElementBase in elements)
					{
						if (element.isPage)
						{
							var elementRect:Rectangle = LayoutUtil.getItemRect(coreMdt.canvas, element, false, true, false);
							if (RectangleUtil.rectOverlapping(currentRect, elementRect))
								vector.push(element.vo.pageVO);
						}
					}
				}
			}
			return vector;
		}
		
		public function getThumbByPageVO(pageVO:PageVO, w:Number, h:Number, mainUI:MainUIBase, color:uint = 0xFFFFFF, smooth:Boolean = false):BitmapData
		{
			
			//scale
			var vw:Number = w;
			var vh:Number = h;
			var pw:Number = pageVO.scale * pageVO.width;
			var ph:Number = pageVO.scale * pageVO.height;
			var scale:Number = ((vw / vh) > (pw / ph)) ? vh / ph : vw / pw;
			var rotation:Number = -pageVO.rotation;
			var radian  :Number = MathUtil.angleToRadian(pageVO.rotation);
			var cos:Number = Math.cos(radian);
			var sin:Number = Math.sin(radian);
			
			//算出pageVO的左上角point
			var tp:Point = new Point;
			tp.x = - .5 * pageVO.scale * pageVO.width;
			tp.y = - .5 * pageVO.scale * pageVO.height;
			
			var rx:Number = tp.x * cos - tp.y * sin;
			var ry:Number = tp.x * sin + tp.y * cos;
			
			tp.x = rx + pageVO.x;
			tp.y = ry + pageVO.y;
			LayoutUtil.convertPointCanvas2Stage(tp, -(vw - pw * scale) * .5, -(vh - ph * scale) * .5, scale, rotation);
			
			//移至居中再截图
			var offsetX:Number = .5 * (w - mainUI.stage.stageWidth);
			var offsetY:Number = .5 * (h - mainUI.stage.stageHeight);
			
			tp.offset(offsetX, offsetY);
			
			var rect:Rectangle = new Rectangle(-offsetX, -offsetY, w, h);
			mainUI.canvas.toShotcutState(-tp.x, -tp.y, scale, rotation, rect);
			mainUI.synBgImageToCanvas();
			
			var mat:Matrix = new Matrix;
			mat.scale(mainUI.bgImageCanvas.scaleX, mainUI.bgImageCanvas.scaleY);
			mat.rotate(mainUI.bgImageCanvas.rotation);
			mat.translate(mainUI.bgImageCanvas.x + offsetX, mainUI.bgImageCanvas.y + offsetY);
			var bg:BitmapData = BitmapUtil.drawWithSize(mainUI.bgImageCanvas, w, h, false, color, mat, smooth);
			mat = new Matrix;
			mat.translate(offsetX, offsetY);
			var im:BitmapData = BitmapUtil.drawWithSize(mainUI.canvas, w, h, true, 0, mat, smooth);
			var sp:Sprite = new Sprite;
			sp.addChild(new Bitmap(bg));
			sp.addChild(new Bitmap(im));
			//mainUI.parent.addChild(sp);
			var bmd:BitmapData = new BitmapData(w, h, false, color);
			bmd.draw(sp, null, null, null, null, true);
			
			mainUI.canvas.toPreviewState();
			mainUI.synBgImageToCanvas();
			return bmd;
		}
		
		private function get proxy():CoreProxy
		{
			return CoreFacade.coreProxy;
		}
		
		private function get coreMdt():CoreMediator
		{
			return CoreFacade.coreMediator;
		}
	}
}