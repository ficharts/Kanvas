package view.shapePanel.pageForCreateCompt
{
	import com.kvs.ui.FiUI;
	import com.kvs.utils.layout.BoxLayout;
	
	import flash.display.Sprite;
	
	import view.ItemSelector;
	
	/**
	 * 元素选择页面，里面存放了多个元素选择单元
	 */	
	public class ItemSelectorPageBase extends FiUI
	{
		public function ItemSelectorPageBase()
		{
			super();
		}
		
		/**
		 * 
		 */		
		public function get pageHeight():Number
		{
			return boxLayout.getRectHeight();
		}
		
		/**
		 */		
		public function get gutter():Number
		{
			return boxLayout.gap;
		}
		
		/**
		 */		
		override protected function init():void
		{
			super.init();
			
			boxLayout.setLoc(0, 0);
			boxLayout.setItemSizeAndFullWidth(w, iconSize, iconSize);
			boxLayout.ready();
			
			var comp:ItemSelector;
			for each (comp in selectors)
			{
				boxLayout.layout(comp);
				comp.styleXML = btnStyleXML;
				addChild(comp);
			}
		}
		
		/**
		 */		
		protected var iconSize:uint = 46;
		
		/**
		 */		
		private var boxLayout:BoxLayout = new BoxLayout;
		
		/**
		 */		
		public function get selector():ItemSelector
		{
			return null;
		}

		/**
		 */		
		public function set selector(value:ItemSelector):void
		{
			selectors.push(value);
		}

		/**
		 */		
		private var selectors:Vector.<ItemSelector> = new Vector.<ItemSelector>;  
		
		/**
		 * 页面ID， 页面间导航时会用到
		 */		
		private var _pageID:String = '';

		public function get id():String
		{
			return _pageID;
		}

		public function set id(value:String):void
		{
			_pageID = value;
		}
		
		/**
		 */		
		private　var _title:String = '';

		/**
		 */
		public function get title():String
		{
			return _title;
		}

		/**
		 * @private
		 */
		public function set title(value:String):void
		{
			_title = value;
		}
		
		/**
		 */		
		public var btnStyleXML:XML = <states>
										<normal radius='20'>
											<fill color='#0082B4' alpha='0.6' type='linear'/>
										</normal>
										<hover radius='20' >
											<fill color='#555555' alpha='0.8'/>
										</hover>
										<down radius='20' >
											<fill color='#BBBBBB' alpha='0.5'/>
										</down>
									</states>		

		
	}
}