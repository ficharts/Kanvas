package model.vo
{
	import flash.display.BitmapData;
	
	import modules.pages.PageEvent;
	import modules.pages.PageQuene;
	import modules.pages.pg_internal;
	
	[Event(name="updateThumb", type="modules.pages.PageEvent")]
	
	[Event(name="deletePageFromUI", type="modules.pages.PageEvent")]
	
	[Event(name="pageSelected", type="modules.pages.PageEvent")]
	
	[Event(name="updatePageIndex", type="modules.pages.PageEvent")]
	
	/**
	 */	
	public final class PageVO extends ElementVO
	{
		public function PageVO()
		{
			super();
			pageVO = this;
			this.styleType = "shape";
			this.type = "page";
		}
		
		override public function exportData(template:XML):XML
		{
			var template:XML = super.exportData(template);
			if (elementVO)
				template.@elementID = elementVO.id;
			return template;
		}
		
		override public function set x(value:Number):void
		{
			if (_x!= value)
			{
				_x = value;
				if (thumbUpdatable)
					dispatchEvent(new PageEvent(PageEvent.UPDATE_THUMB, this));
			}
		}
		
		override public function set y(value:Number):void
		{
			if (_y!= value)
			{
				_y = value;
				if (thumbUpdatable)
					dispatchEvent(new PageEvent(PageEvent.UPDATE_THUMB, this));
			}
		}
		
		override public function set width(value:Number):void
		{
			if (_width!= value)
			{
				_width = value;
				if (thumbUpdatable)
					dispatchEvent(new PageEvent(PageEvent.UPDATE_THUMB, this));
			}
		}
		
		override public function set height(value:Number):void
		{
			if (_height!= value)
			{
				_height = value;
				if (thumbUpdatable)
					dispatchEvent(new PageEvent(PageEvent.UPDATE_THUMB, this));
			}
		}
		
		override public function set scale(value:Number):void
		{
			if (_scale!= value)
			{
				_scale = value;
				if (thumbUpdatable)
					dispatchEvent(new PageEvent(PageEvent.UPDATE_THUMB, this));
			}
		}
		
		override public function set rotation(value:Number):void
		{
			if (_rotation!= value)
			{
				_rotation = value;
				if (thumbUpdatable)
					dispatchEvent(new PageEvent(PageEvent.UPDATE_THUMB, this));
			}
		}
		
		public function get parent():PageQuene
		{
			return pg_internal::parent;
		}
		
		pg_internal var parent:PageQuene
		
		/**
		 */		
		public function set index(value:int):void
		{
			__index = value;	
			
			dispatchEvent(new PageEvent(PageEvent.UPDATE_PAGE_INDEX, this));
		}
		
		public function get index():int
		{
			return __index;
		}
		private var __index:int = -1;
		
		public function get thumbUpdatable():Boolean
		{
			return __thumbUpdatable;
		}
		public function set thumbUpdatable(value:Boolean):void
		{
			if (__thumbUpdatable!= value)
			{
				__thumbUpdatable = value;
			}
		}
		private var __thumbUpdatable:Boolean = true;
		
		public var elementID:uint;
		
		public var bitmapData:BitmapData;
		
		public var elementVO:ElementVO;
	}
}