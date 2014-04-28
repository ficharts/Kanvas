package modules.pages
{
	import flash.events.EventDispatcher;
	import model.vo.PageVO;

	[Event(name="pageAdded", type="modules.pages.PageEvent")]
	
	[Event(name="pageDeleted", type="modules.pages.PageEvent")]
	
	[Event(name="updatePagesLayout", type="modules.pages.PageEvent")]
	
	/**
	 * 多页面核心类，用于存储页面，排序，添加删除等。
	 *  
	 * @author Landray
	 * 
	 */	
	public final class PageQuene extends EventDispatcher
	{
		public function PageQuene()
		{
			super();
			pg_internal::pages = new Vector.<PageVO>;
		}
		
		/**
		 * 添加页
		 */
		public function addPage(pageVO:PageVO):PageVO
		{
			registPageVO(pageVO, length);
			pages.push(pageVO);
			
			dispatchEvent(new PageEvent(PageEvent.PAGE_ADDED, pageVO));
			dispatchEvent(new PageEvent(PageEvent.UPDATE_PAGES_LAYOUT));
			
			return pageVO;
		}
		
		/**
		 * 在指定位置添加页，index超出范围时自动加到最后一页
		 */
		public function addPageAt(pageVO:PageVO, index:int):PageVO
		{
			if (index >=0 && index <= length)
			{
				if (pageVO.parent != this)
				{
					registPageVO(pageVO, index);
					pages.splice(index, 0, pageVO);
					udpatePageIndex(index, length);
					
					dispatchEvent(new PageEvent(PageEvent.PAGE_ADDED, pageVO));
					dispatchEvent(new PageEvent(PageEvent.UPDATE_PAGES_LAYOUT));
				}
				else
				{
					if (index < length)
					{
						setPageIndex(pageVO, index);
						dispatchEvent(new PageEvent(PageEvent.PAGE_ADDED, pageVO));
					}
					else
					{
						throw new RangeError("提供的索引超出范围。", 2006);
					}
				}
			}
			else
			{
				throw new RangeError("提供的索引超出范围。", 2006);
			}
			
			return pageVO;
		}
		
		/**
		 * 判断pageVO是否在队列
		 */
		public function contains(pageVO:PageVO):Boolean
		{
			return pageVO.parent == this;
		}
		
		/**
		 * 获取序号为index的pageVO
		 */
		public function getPageAt(index:int):PageVO
		{
			var pageVO:PageVO;
			if (index >=0 && index < length)
				pageVO = pages[index];
			else
				throw new RangeError("提供的索引超出范围。", 2006);
			return pageVO;
		}
		
		/**
		 * 获取pageVO的序号
		 */
		public function getPageIndex(pageVO:PageVO):int
		{
			if (contains(pageVO))
				var index:int = pageVO.index;
			else
				throw new ArgumentError("提供的 PageVO 必须是调用者的子级。", 2025);
			
			return index;
		}
		
		/**
		 * 从队列中删除页
		 */
		public function removePage(pageVO:PageVO):PageVO
		{
			if (contains(pageVO))
			{
				var index:int = pageVO.index;
				pages.splice(index, 1);
				removePageVO(pageVO);
				udpatePageIndex(index, length);
				
				dispatchEvent(new PageEvent(PageEvent.PAGE_DELETED, pageVO));
				dispatchEvent(new PageEvent(PageEvent.UPDATE_PAGES_LAYOUT));
			}
			else
			{
				throw new ArgumentError("提供的 PageVO 必须是调用者的子级。", 2025);
			}
			
			return pageVO;
		}
		
		/**
		 * 从队列中删除序号为index的页
		 */
		public function removePageAt(index:int):PageVO
		{
			if (index >= 0 && index < length)
			{
				var pageVO:PageVO = pages[index];
				removePageVO(pageVO);
				pages.splice(index, 1);
				udpatePageIndex(index, length);
				
				dispatchEvent(new PageEvent(PageEvent.PAGE_DELETED, pageVO));
				dispatchEvent(new PageEvent(PageEvent.UPDATE_PAGES_LAYOUT));
			}
			else
			{
				throw new RangeError("提供的索引超出范围。", 2006);
			}
			
			return null;
		}
		
		public function removeAllPages():void
		{
			pages.length = 0;
			dispatchEvent(new PageEvent(PageEvent.PAGE_DELETED));
			dispatchEvent(new PageEvent(PageEvent.UPDATE_PAGES_LAYOUT));
		}
		
		
		/**
		 * 设定某页的顺序
		 */
		public function setPageIndex(pageVO:PageVO, index:int, sendEvent:Boolean = false):void
		{
			if (index >= 0 && index < length)
			{
				var cur:int = pages.indexOf(pageVO);
				if (cur != -1)
				{
					//var aim:int = (index > cur) ? index - 1 : index;
					pages.splice(cur, 1);
					pages.splice(index, 0, pageVO);
					var min:int = Math.min(cur, index);
					var max:int = Math.max(cur, index);
					udpatePageIndex(Math.min(cur, index), Math.max(cur, index) + 1);
					if (sendEvent)
						dispatchEvent(new PageEvent(PageEvent.UPDATE_PAGES_LAYOUT));
				}
				else
				{
					throw new ArgumentError("提供的 PageVO 必须是调用者的子级。", 2025);
				}
			}
			else
			{
				throw new RangeError("提供的索引超出范围。", 2006);
			}
		}
		
		
		/**
		 * 加入pageVO时，设定VO的index与parent
		 */
		private function registPageVO(pageVO:PageVO, index:int):void
		{
			pageVO.index = index;
			pageVO.pg_internal::parent = this;
		}
		
		/**
		 * 删除pageVO时，对VO的初始化
		 */
		private function removePageVO(pageVO:PageVO):void
		{
			//pageVO.pg_internal::index = - 1;
			pageVO.pg_internal::parent = null;
		}
		
		/**
		 * 更新VO的顺序
		 */
		private function udpatePageIndex(start:int, end:int):void
		{
			for (var i:int = start; i < end; i++)
				pages[i].index = i;
		}
		
		/**
		 * 获取总页数
		 */
		public function get length():int
		{
			return pages.length;
		}
		
		/**
		 * 获取pageVO集合
		 */
		public function get pages():Vector.<PageVO>
		{
			return pg_internal::pages;
		}
		
		pg_internal var pages:Vector.<PageVO>;
	}
}